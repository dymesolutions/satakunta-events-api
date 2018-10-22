package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.common.utils.DateUtil.jsonDateFormat
import com.dymesolutions.linkedevents.App
import com.dymesolutions.linkedevents.models.*
import com.dymesolutions.linkedevents.utils.EventStatus
import com.dymesolutions.common.utils.JsonBuilders
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import org.joda.time.DateTime
import org.joda.time.format.DateTimeFormat

object EventSerializer {

    private val dateFormat = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")

    fun fromJson(json: JsonObject, user: User, organization: Organization?, event: Event? = null): EventSave {
        val name = json.get("name").asJsonObject

        val shortDescription = json.get("short_description").asJsonObject
        val description = json.get("description").asJsonObject

        val providerContactName = json.get("provider_contact_name").asString
        val providerContactEmail = json.get("provider_contact_email").asString
        val providerContactPhone = json.get("provider_contact_phone").asString

        val providerName = json.get("provider_name").asString
        val providerEmail = json.get("provider_email")?.asString
        val providerPhone = json.get("provider_phone")?.asString
        val providerLink = json.get("provider_link")?.asString

        val eventStatus = json.get("event_status").asString

        val location = json.get("location").asJsonObject
        val locationExtraInfo = json.get("location_extra_info")?.asJsonObject

        val startTime = json.get("start_time").asString

        val images = json.get("images").asJsonArray

        val imageId = when {
            (images.size() > 0) -> {
                val image = images[0].asJsonObject

                val imageUrl = image.get("@id").asString
                val imageUrlComponents = imageUrl.split("/")

                if (imageUrlComponents.contains("image")) {
                    imageUrlComponents[imageUrlComponents.lastIndex - 1].toInt()

                } else {
                    null
                }
            }
            else -> null
        }

        val endTime = json.get("end_time")?.let {
            if (!it.isJsonNull) {
                dateFormat.parseDateTime(it.asString)
            } else {
                null
            }
        }

        val position = json.get("position").asJsonObject

        return EventSave(
            name = MultiLangValue(
                fi = name?.get("fi")?.asString,
                sv = name?.get("sv")?.asString,
                en = name?.get("en")?.asString
            ),

            originId = event?.originId ?: (organization?.originId ?: "anonymous"),
            createdTime = event?.createdTime ?: DateTime.now(),
            lastModifiedTime = DateTime.now(),
            datePublished = event?.datePublished,
            startTime = dateFormat.parseDateTime(startTime),
            endTime = endTime,

            infoUrl = null,
            description = MultiLangValue(
                fi = description.get("fi").asString,
                sv = description.get("sv")?.asString,
                en = description.get("en")?.asString
            ),
            shortDescription = MultiLangValue(
                fi = shortDescription.get("fi").asString,
                sv = shortDescription.get("sv")?.asString,
                en = shortDescription.get("en")?.asString
            ),

            provider = null,

            providerName = providerName,
            providerEmail = providerEmail,
            providerPhone = providerPhone,
            providerLink = providerLink,
            providerContactName = providerContactName,
            providerContactEmail = providerContactEmail,
            providerContactPhone = providerContactPhone,

            eventStatus = eventStatus,
            locationExtraInfo = MultiLangValue(
                fi = locationExtraInfo?.get("fi")?.asString,
                sv = locationExtraInfo?.get("sv")?.asString,
                en = locationExtraInfo?.get("en")?.asString
            ),
            createdById = event?.createdById ?: user.id,
            lastModifiedById = user.id,
            dataSourceId = event?.dataSourceId ?: organization?.dataSourceId ?: "porianon",
            locationId = location.get("id").asString,
            publisherId = event?.publisherId ?: organization?.id ?: "porianon:anonymous",
            superEventId = null,
            customData = null,
            imageId = imageId,
            position = Position(
                lat = position.get("lat")?.let {
                    if (!it.isJsonNull) {
                        it.asDouble
                    } else {
                        null
                    }
                },
                lng = position.get("lng")?.let {
                    if (!it.isJsonNull) {
                        it.asDouble
                    } else {
                        null
                    }
                }
            ),
            publicationStatus = event?.publicationStatus
        )
    }

    fun toJson(event: Event,
               audiences: ArrayList<Keyword>,
               keywords: ArrayList<Keyword>,
               offers: ArrayList<Offer>,
               images: ArrayList<Image>,
               includeParams: List<String>?,
               includeContactInfo: Boolean = false,
               user: User? = null): JsonObject {

        val json = JsonObject()

        json.addProperty("@id", "${App.properties["server.hostName"]}${App.properties["server.apiPath"]}/event/${event.id}/")
        json.addProperty("@context", "http://schema.org")
        json.addProperty("@type", "Event/LinkedEvent")

        json.addProperty("id", event.id)

        // Location
        json.add("location", PlaceSerializer.toJson(event.location, includeParams?.contains("location") ?: false))

        // Keywords
        val audienceArray = JsonArray()
        val keywordArray = JsonArray()
        val offerArray = JsonArray()
        val imageArray = JsonArray()

        keywords.forEach { keyword ->
            keywordArray.add(KeywordSerializer.toJson(keyword, includeParams?.contains("keywords") ?: false))
        }

        audiences.forEach { audience ->
            audienceArray.add(KeywordSerializer.toJson(audience, includeParams?.contains("audience") ?: false))
        }

        offers.forEach { offer ->
            offerArray.add(OfferSerializer.toJson(offer))
        }

        images.forEach { image ->
            imageArray.add(ImageSerializer.toJson(image))
        }

        json.add("keywords", keywordArray)
        json.add("audience", audienceArray)
        json.add("offers", offerArray)
        json.add("images", imageArray)

        json.addProperty("super_event", event.superEventId)
        json.addProperty("event_status", EventStatus.values[event.eventStatus])
        json.add("external_links", JsonArray())

        // json.add("offers", )

        json.addProperty("data_source", event.dataSourceId)
        json.addProperty("publisher", event.publisherId)
        json.add("sub_events", JsonArray())
        json.add("in_language", JsonArray())
        // json.add("audience")
        json.addProperty("custom_data", event.customData)
        json.addProperty("created_time", event.createdTime?.toString(jsonDateFormat))
        json.addProperty("last_modified_time", event.lastModifiedTime?.toString(jsonDateFormat))
        json.addProperty("date_published", event.datePublished?.toString(jsonDateFormat))

        json.addProperty("provider_name", event.providerName)
        json.addProperty("provider_email", event.providerEmail)
        json.addProperty("provider_phone", event.providerPhone)
        json.addProperty("provider_link", event.providerLink)

        // Provider contact info when editing and/or viewing as moderator
        if (includeContactInfo) {
            json.addProperty("provider_contact_name", event.providerContactName)
            json.addProperty("provider_contact_email", event.providerContactEmail)
            json.addProperty("provider_contact_phone", event.providerContactPhone)
        }

        // Position
        json.add("position", event.position?.let { pos ->
            JsonBuilders.toJsonTree(Position(
                lat = pos.lat,
                lng = pos.lng
            ))
        })

        json.addProperty("start_time", event.startTime?.toString(jsonDateFormat))
        json.addProperty("end_time", event.endTime?.toString(jsonDateFormat))
        //json.addProperty("super_event_type", null)
        //json.addProperty("provider", event.provider)

        json.add("description", JsonBuilders.toJsonTree(event.description))
        json.add("short_description", JsonBuilders.toJsonTree(event.shortDescription))
        json.add("name", JsonBuilders.toJsonTree(event.name))
        json.add("location_extra_info", JsonBuilders.toJsonTree(event.locationExtraInfo))
        json.add("info_url", JsonBuilders.toJsonTree(event.infoUrl))

        user?.let {
            json.add("created_by", UserSerializer.toJson(user))
        }

        return json
    }

}

