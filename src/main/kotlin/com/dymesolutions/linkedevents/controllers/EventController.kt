package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.interfaces.Controller
import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.common.utils.DateUtil.formatter
import com.dymesolutions.common.utils.UserUtil
import com.dymesolutions.linkedevents.App
import com.dymesolutions.linkedevents.common.utils.MailUtil
import com.dymesolutions.linkedevents.dao.*
import com.dymesolutions.linkedevents.models.Image
import com.dymesolutions.linkedevents.serializers.EventSerializer
import com.dymesolutions.linkedevents.serializers.OfferSerializer
import com.dymesolutions.linkedevents.utils.MetaObject
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.joda.time.DateTime
import org.joda.time.IllegalFieldValueException
import spark.Request
import spark.Response
import java.util.*

class EventController : Controller {

    companion object {
        private val jsonParser = JsonParser()
    }

    /**
     * Find event by its ID
     */
    override fun getById(req: Request, res: Response, manager: Boolean): Any {
        val eventId = req.params("eventId")
        val includeParams = req.queryParams("include")

        Events.findById(eventId)?.let { event ->
            val images = ArrayList<Image>()

            if (event.imageId != null) images.add(Images.findById(event.imageId))

            val response = EventSerializer.toJson(
                event = event,
                audiences = Keywords.findAllAudiencesByEventId(eventId),
                keywords = Keywords.findAllTopicsByEventId(eventId),
                offers = Offers.findAllByEventId(eventId),
                images = images,
                includeParams = includeParams?.split(",")
            )

            return CommonResponse.ok(response).handle(req, res)
        }

        return CommonResponse.notFound().handle(req, res)
    }

    // API v2 returns extra fields when fetching for editing
    fun getByIdForEdit(req: Request, res: Response, manager: Boolean = false): Any {
        val eventId = req.params("eventId")
        val includeParams = req.queryParams("include")

        val profile = UserUtil.getUserProfile(req, res)

        profile.get().let { userProfile ->

            val userId = userProfile.getAttribute("userId")

            Events.findById(eventId).let { event ->

                event?.let {
                    if (it.createdById == userId ||
                        userProfile.roles.contains("SUPER_USER") ||
                        userProfile.roles.contains("MANAGER")) {

                        val images = ArrayList<Image>()

                        if (it.imageId != null) images.add(Images.findById(it.imageId))

                        val response = EventSerializer.toJson(
                            event = it,
                            audiences = Keywords.findAllAudiencesByEventId(eventId),
                            keywords = Keywords.findAllTopicsByEventId(eventId),
                            offers = Offers.findAllByEventId(eventId),
                            images = images,
                            includeParams = includeParams?.split(","),
                            includeContactInfo = true
                        )

                        return CommonResponse.ok(response).handle(req, res)
                    } else {
                        return CommonResponse.unauthenticated().handle(req, res)
                    }
                }
            }
        }

        return CommonResponse.unauthenticated().handle(req, res)
    }

    /**
     * Find all events, can be controlled with parameters
     */
    override fun getAll(req: Request, res: Response, manager: Boolean): Any {

        fun parseDate(date: String): DateTime {
            return when (date) {
                "today" -> DateTime.now()
                else -> formatter.parseDateTime(date)
            }

        }
        // Optional params
        try {

            val includeParams = req.queryParams("include")
            val bbox = handleBboxParams(req.queryParams("bbox"))
            val pageSize = req.queryParams("page_size")
            val page = req.queryParams("page")
            val text = req.queryParams("text")
            val providerName = req.queryParams("provider_name")
            val start = req.queryParams("start")?.let { parseDate(it) }
            val end = req.queryParams("end")?.let { parseDate(it) }
            val published = req.queryParams("published")
            val sort = req.queryParams("sort")
            val publisher = req.queryParams("publisher")
            val dataSourceId = req.queryParams("data_source")
            val location = req.queryParams("location")
            val keyword = req.queryParams("keyword")

            // Need try because casting parameters to integers.

            Events.findAll(
                pageSize?.toInt() ?: 30,
                page?.toInt() ?: 1,
                start,
                end,
                text,
                providerName,
                published?.toBoolean() ?: true,
                sort,
                publisher,
                dataSourceId,
                location,
                keyword,
                bbox)
                .let { events ->
                    val dataArray = JsonArray()

                    events.forEach { event ->
                        val images = ArrayList<Image>()

                        if (event.imageId != null) images.add(Images.findById(event.imageId))

                        val user = when {
                            manager -> Users.findById(event.createdById ?: 0)
                            else -> null
                        }

                        dataArray.add(EventSerializer.toJson(
                            event = event,
                            audiences = Keywords.findAllAudiencesByEventId(event.id),
                            keywords = Keywords.findAllTopicsByEventId(event.id),
                            offers = Offers.findAllByEventId(event.id),
                            images = images,
                            includeParams = includeParams?.split(","),
                            user = user
                        ))
                    }

                    val response = JsonObject()

                    response.add("meta",
                        MetaObject.build(
                            count = Events.count(
                                start = start,
                                end = end,
                                text = text,
                                providerName = providerName,
                                publisherId = publisher,
                                dataSourceId = dataSourceId,
                                locationId = location,
                                keyword = keyword,
                                published = published?.toBoolean() ?: true
                            ),
                            type = "event",
                            pageSize = pageSize?.toInt() ?: 30,
                            page = page?.toInt() ?: 1))

                    response.add("data", dataArray)

                    return CommonResponse.ok(response).handle(req, res)
                }
        } catch (e: Exception) {
            return when (e) {
                is NumberFormatException -> CommonResponse.badRequest("Passed parameter <page> or <page_size> is not an integer number").handle(req, res)
                is IllegalFieldValueException -> CommonResponse.badRequest("Cannot parse given date").handle(req, res)
                else -> {
                    e.printStackTrace()
                    CommonResponse.badRequest("An error occurred and has been logged").handle(req, res)
                }
            }

        }
    }

    // POST & PUT functions

    override fun add(req: Request, res: Response): Any {
        val requestBodyJson = jsonParser.parse(req.body()) as JsonObject

        val profile = UserUtil.getUserProfile(req, res)

        // First get user id from user profile, then save event and get eventId
        // which can be user to save keyword links and offers.

        profile.get().let { userProfile ->
            userProfile.getAttribute("userId")?.let { profileUserId ->
                Users.findById(profileUserId as Int)?.let { user ->

                    val organization = Organizations.findByUserId(user.id)

                    val event = EventSerializer.fromJson(requestBodyJson, user, organization)

                    Events.add(event)?.let { eventId ->
                        // Create offers
                        val offers = requestBodyJson.get("offers").asJsonArray

                        offers.forEach { offer ->
                            Offers.add(OfferSerializer.fromJson(offer.asJsonObject, eventId))
                        }

                        // Attach Keywords
                        val keywords = requestBodyJson.get("keywords").asJsonArray
                        val audience = requestBodyJson.get("audience").asJsonArray

                        // TODO refactor to "id resolver" Util
                        keywords.forEach {
                            val keyword = it.asJsonObject
                            val keywordIdUrl = keyword.get("@id").asString
                            val keywordUrlComponents = keywordIdUrl.split("/")

                            if (keywordUrlComponents.contains("keyword")) {
                                val keywordId = keywordUrlComponents[keywordUrlComponents.lastIndex - 1]
                                EventKeywords.add(eventId, keywordId)
                            }
                        }

                        audience.forEach {
                            val audienceKeyword = it.asJsonObject
                            val audienceIdUrl = audienceKeyword.get("@id").asString
                            val audienceUrlComponents = audienceIdUrl.split("/")

                            if (audienceUrlComponents.contains("keyword")) {
                                val audienceId = audienceUrlComponents[audienceUrlComponents.lastIndex - 1]
                                EventAudiences.add(eventId, audienceId)
                            }
                        }

                        val response = JsonObject()
                        response.addProperty("@id", "${App.properties["server.hostName"]}${App.properties["server.apiPath"]}/event/$eventId/")

                        MailUtil.sendNewEventNotification(event, user)

                        return CommonResponse.okCreated(response).handle(req, res)
                    }
                }

                return CommonResponse.unauthenticated().handle(req, res)
            }
            return CommonResponse.unauthenticated().handle(req, res)
        }
    }


    override fun update(req: Request, res: Response, manager: Boolean): Any {
        val requestBodyJson = jsonParser.parse(req.body()) as JsonObject
        val eventId = req.params("eventId")
        val profile = UserUtil.getUserProfile(req, res)

        profile.get().let { userProfile ->
            userProfile.getAttribute("userId")?.let { profileUserId ->
                Users.findById(profileUserId as Int)?.let { user ->

                    Events.findById(eventId)?.let { event ->
                        if (event.createdById == profileUserId ||
                            userProfile.roles.contains("SUPER_USER") ||
                            userProfile.roles.contains("MANAGER")) {

                            val organization = Organizations.findByUserId(user.id)

                            EventSerializer.fromJson(requestBodyJson, user, organization, event).let { eventFromJson ->

                                val keywords = requestBodyJson.get("keywords").asJsonArray
                                val audience = requestBodyJson.get("audience").asJsonArray
                                val offers = requestBodyJson.get("offers").asJsonArray

                                Events.update(eventId, eventFromJson).let {
                                    updateEventAudience(audience, eventId)
                                    updateEventKeywords(keywords, eventId)
                                    updateEventOffers(offers, eventId)

                                    MailUtil.sendNewEventNotification(eventFromJson, user, true)

                                    return CommonResponse.okCreated("Event updated").handle(req, res)
                                }
                            }
                        }
                    }
                }

                return CommonResponse.notFound("Event not found").handle(req, res)
            }
        }

        return CommonResponse.unauthorized().handle(req, res)
    }

    private fun updateEventOffers(updatedOffers: JsonArray, eventId: String) {
        Offers.findAllByEventId(eventId).let { offers ->
            val offer = (updatedOffers[0] as JsonObject)
            if (!offers.isEmpty()) {
                Offers.update(OfferSerializer.fromJson(offer.asJsonObject, eventId), offers[0].id)
            }
        }
    }

    private fun updateEventKeywords(keywords: JsonArray, eventId: String) {
        if (keywords.size() > 0) {
            // Find all keywords belonging to event
            EventKeywords.findAllKeywordIdsByEventId(eventId).let { keywordsByEventId ->

                val kk = ArrayList<String>()

                keywords.forEach {
                    val keyword = it.asJsonObject

                    val keywordIdUrl = keyword.get("@id").asString

                    val keywordUrlComponents = keywordIdUrl.split("/")

                    if (keywordUrlComponents.contains("keyword")) {
                        val keywordId = keywordUrlComponents[keywordUrlComponents.lastIndex - 1]

                        kk.add(keywordId)

                        when {
                            keywordsByEventId.contains(keywordId) -> {
                            }
                            else -> EventKeywords.add(eventId, keywordId)
                        }
                    }
                }

                keywordsByEventId.removeAll(kk)

                keywordsByEventId.forEach { keyId ->
                    EventKeywords.delete(eventId, keyId)
                }
            }
        }
    }

    private fun updateEventAudience(audience: JsonArray, eventId: String) {
        EventAudiences.findAllAudienceIdsByEventId(eventId).let { audienceIds ->
            if (audience.size() > 0) {
                audience.forEach {
                    val audienceKeyword = it.asJsonObject
                    val audienceIdUrl = audienceKeyword.get("@id").asString
                    val audienceUrlComponents = audienceIdUrl.split("/")

                    if (audienceUrlComponents.contains("keyword")) {
                        val audienceId = audienceUrlComponents[audienceUrlComponents.lastIndex - 1]

                        when {
                            audienceIds.contains(audienceId) -> {
                            }
                            else -> EventAudiences.add(eventId, audienceId)
                        }

                    }
                }
            } else {

                if (audienceIds.isNotEmpty()) {
                    EventAudiences.deleteAllByEventId(eventId)
                } else {

                }
            }
        }
    }

    override fun delete(req: Request, res: Response, manager: Boolean): Any {
        val eventId = req.params("eventId")

        val profile = UserUtil.getUserProfile(req, res)

        profile.get().let { userProfile ->
            userProfile.getAttribute("userId")?.let { profileUserId ->

                val event = Events.findById(eventId)

                event?.let {
                    return if (it.createdById == profileUserId ||
                        userProfile.roles.contains("SUPER_USER") ||
                        userProfile.roles.contains("MANAGER")) {

                        Events.delete(event.id)

                        CommonResponse.ok().handle(req, res)
                    } else {
                        CommonResponse.unauthorized().handle(req, res)
                    }
                }

                return CommonResponse.notFound().handle(req, res)
            }

            return CommonResponse.unauthenticated().handle(req, res)
        }
    }

    fun publish(req: Request, res: Response, manager: Boolean = false): Any {
        req.body()?.let { requestBody ->
            return try {
                if (manager) {
                    val requestJson = jsonParser.parse(requestBody).asJsonObject
                    val eventId = requestJson.get("event_id").asString

                    Events.publish(eventId)

                    CommonResponse.okCreated().handle(req, res)
                } else {
                    CommonResponse.unauthorized().handle(req, res)
                }
            } catch (e: Exception) {
                e.printStackTrace()
                CommonResponse.badRequest("Malformed JSON").handle(req, res)
            }
        }

        return CommonResponse.badRequest("Request body missing").handle(req, res)
    }


    fun getAllByLoggedInUser(req: Request, res: Response): Any {
        val userIdParam = req.queryParams("user_id")
        val includeParams = req.queryParams("include")
        val pageSize = req.queryParams("page_size")
        val page = req.queryParams("page")
        val published = req.queryParams("published")

        userIdParam?.let {
            try {
                val profile = UserUtil.getUserProfile(req, res)

                val userId = it.toInt()

                profile.get().let { userProfile ->

                    // Need to check for Super User or Manager here to allow them to fetch all this user's events
                    userProfile.getAttribute("userId")?.let { profileUserId ->
                        if (userId == profileUserId ||
                            userProfile.roles.contains("SUPER_USER") ||
                            userProfile.roles.contains("MANAGER")) {

                            Events.findAllByUserId(
                                userId,
                                published = published?.toBoolean() ?: true,
                                pageSize = pageSize?.toInt() ?: 30,
                                page = page?.toInt() ?: 1).let { events ->

                                val dataArray = JsonArray()

                                events.forEach { event ->
                                    val images = ArrayList<Image>()

                                    if (event.imageId != null) images.add(Images.findById(event.imageId))
                                    dataArray.add(EventSerializer.toJson(
                                        event = event,
                                        audiences = Keywords.findAllAudiencesByEventId(event.id),
                                        keywords = Keywords.findAllTopicsByEventId(event.id),
                                        offers = Offers.findAllByEventId(event.id),
                                        images = images,
                                        includeParams = includeParams?.split(",")
                                    ))
                                }

                                val response = JsonObject()

                                response.add("meta", MetaObject.build(
                                    Events.count(
                                        userId = userId,
                                        published = published?.toBoolean() ?: true),
                                    "event",
                                    pageSize?.toInt() ?: 30,
                                    page?.toInt() ?: 1))

                                response.add("data", dataArray)

                                return CommonResponse.ok(response).handle(req, res)
                            }
                        } else {
                            return CommonResponse.unauthorized().handle(req, res)
                        }
                    }
                }

                return CommonResponse.unauthenticated().handle(req, res)

            } catch (e: Exception) {
                e.printStackTrace()

                CommonResponse.badRequest("Parameter <user_id> is not a valid integer number!").handle(req, res)
            }
        }

        return CommonResponse.badRequest("Parameter <user_id> is missing!").handle(req, res)
    }

    private fun handleBboxParams(bboxParam: String?): List<Double>? {
        bboxParam?.split(",")?.let {
            when {
                !it.isEmpty() && it.size == 4 -> {
                    // Enough BBox params
                    val bboxAsDoubleList = ArrayList<Double>()

                    it.forEach { coord ->
                        bboxAsDoubleList.add(coord.toDouble())
                    }

                    return bboxAsDoubleList
                }
                else -> {
                }
            }
        }

        return null
    }
}
