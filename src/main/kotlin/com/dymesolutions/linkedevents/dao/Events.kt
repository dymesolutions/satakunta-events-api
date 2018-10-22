package com.dymesolutions.linkedevents.dao

import com.dymesolutions.common.extensions.PostGIS.point
import com.dymesolutions.common.utils.RandomUtil
import com.dymesolutions.linkedevents.models.*
import com.dymesolutions.linkedevents.utils.EventStatus
import com.dymesolutions.linkedevents.utils.PublicationStatus
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import org.joda.time.DateTime
import org.postgis.Point

object Events : Table(name = "events_event") {
    val id = varchar("id", 50).primaryKey()
    val name = varchar("name", 255)
    val nameFi = varchar("name_fi", 255).nullable()
    val nameSv = varchar("name_sv", 255).nullable()
    val nameEn = varchar("name_en", 255).nullable()

    val originId = varchar("origin_id", 50).nullable()
    val createdTime = datetime("created_time").nullable()
    val lastModifiedTime = datetime("last_modified_time").nullable()

    val infoUrl = varchar("info_url", 1000).nullable()
    val infoUrlFi = varchar("info_url_fi", 1000).nullable()
    val infoUrlSv = varchar("info_url_sv", 1000).nullable()
    val infoUrlEn = varchar("info_url_en", 1000).nullable()

    val description = text("description").nullable()
    val descriptionFi = text("description_fi").nullable()
    val descriptionSv = text("description_sv").nullable()
    val descriptionEn = text("description_en").nullable()

    val shortDescription = text("short_description").nullable()
    val shortDescriptionFi = text("short_description_fi").nullable()
    val shortDescriptionSv = text("short_description_sv").nullable()
    val shortDescriptionEn = text("short_description_en").nullable()

    val datePublished = datetime("date_published").nullable()

    val headline = varchar("headline", 255).nullable()
    val headlineFi = varchar("headline_fi", 255).nullable()
    val headlineSv = varchar("headline_sv", 255).nullable()
    val headlineEn = varchar("headline_en", 255).nullable()

    val secondaryHeadline = varchar("secondary_headline", 255).nullable()
    val secondaryHeadlineFi = varchar("secondary_headline_fi", 255).nullable()
    val secondaryHeadlineSv = varchar("secondary_headline_sv", 255).nullable()
    val secondaryHeadlineEn = varchar("secondary_headline_en", 255).nullable()

    val provider = varchar("provider", 512).nullable()
    val providerFi = varchar("provider_fi", 512).nullable()
    val providerSv = varchar("provider_sv", 512).nullable()
    val providerEn = varchar("provider_en", 512).nullable()

    val providerName = varchar("provider_name", 512).nullable()
    val providerPhone = varchar("provider_phone", 254).nullable()
    val providerEmail = varchar("provider_email", 254).nullable()
    val providerLink = varchar("provider_link", 1000).nullable()
    val providerContactName = varchar("provider_contact_name", 255).nullable()
    val providerContactEmail = varchar("provider_contact_email", 254).nullable()
    val providerContactPhone = varchar("provider_contact_phone", 128).nullable()

    val eventStatus = integer("event_status")

    val locationExtraInfo = varchar("location_extra_info", 400).nullable()
    val locationExtraInfoFi = varchar("location_extra_info_fi", 400).nullable()
    val locationExtraInfoSv = varchar("location_extra_info_sv", 400).nullable()
    val locationExtraInfoEn = varchar("location_extra_info_en", 400).nullable()

    val position = point("position").nullable()

    val startTime = datetime("start_time").nullable()
    val endTime = datetime("end_time").nullable()

    val hasStartTime = bool("has_start_time")
    val hasEndTime = bool("has_end_time")

    val createdById = integer("created_by_id").nullable()
    val dataSourceId = varchar("data_source_id", 100)
    val lastModifiedById = integer("last_modified_by_id").nullable()
    val locationId = varchar("location_id", 50) references Places.id
    val publisherId = varchar("publisher_id", 255)
    val superEventId = varchar("super_event_id", 50).nullable()

    val customData = text("custom_data").nullable()
    val publicationStatus = integer("publication_status")
    val imageId = integer("image_id").nullable()
    val deleted = bool("deleted")

    // TODO refactor to remove, needed here to stay consistent with db:
    val lft = integer("lft")
    val rght = integer("rght")
    val treeId = integer("tree_id")
    val level = integer("level")

    /**
     * @return Event ID
     */
    fun add(event: EventSave): String? {

        val generatedId = generateId(event.dataSourceId)

        transaction {
            insert {
                it[id] = generatedId

                it[name] = event.name.fi ?: ""
                it[nameFi] = event.name.fi
                it[nameSv] = event.name.sv
                it[nameEn] = event.name.en

                it[originId] = event.originId
                it[createdTime] = DateTime.now()
                it[lastModifiedTime] = DateTime.now()

                it[description] = event.description.fi ?: ""
                it[descriptionFi] = event.description.fi ?: ""
                it[descriptionSv] = event.description.sv ?: ""
                it[descriptionEn] = event.description.en ?: ""

                it[shortDescription] = event.shortDescription.fi ?: ""
                it[shortDescriptionFi] = event.shortDescription.fi ?: ""
                it[shortDescriptionSv] = event.shortDescription.sv ?: ""
                it[shortDescriptionEn] = event.shortDescription.en ?: ""

                it[providerName] = event.providerName
                it[providerEmail] = event.providerEmail
                it[providerPhone] = event.providerPhone
                it[providerLink] = event.providerLink

                it[providerContactName] = event.providerContactName
                it[providerContactEmail] = event.providerContactEmail
                it[providerContactPhone] = event.providerContactPhone

                it[eventStatus] = EventStatus.keys[event.eventStatus] ?: 1

                it[locationExtraInfo] = event.locationExtraInfo?.fi
                it[locationExtraInfoFi] = event.locationExtraInfo?.fi
                it[locationExtraInfoSv] = event.locationExtraInfo?.sv
                it[locationExtraInfoEn] = event.locationExtraInfo?.en

                it[position] = event.position?.let { pos ->
                    when {
                        pos.lat == null || pos.lng == null -> null
                        else -> Point(pos.lat, pos.lng)
                    }
                }

                it[startTime] = event.startTime
                it[endTime] = event.endTime
                it[hasStartTime] = true
                it[hasEndTime] = event.endTime != null

                it[createdById] = event.createdById
                it[lastModifiedById] = event.lastModifiedById

                it[dataSourceId] = event.dataSourceId
                it[locationId] = event.locationId
                it[publisherId] = event.publisherId
                it[superEventId] = event.superEventId
                it[customData] = event.customData

                // New events are saved as draft
                it[publicationStatus] = PublicationStatus.keys["draft"] ?: 2
                it[imageId] = event.imageId
                it[deleted] = false

                it[lft] = 1
                it[rght] = 2
                it[treeId] = 1
                it[level] = 0
            }
        }

        return generatedId
    }

    fun count(
        start: DateTime? = null,
        end: DateTime? = null,
        text: String? = null,
        published: Boolean = true,
        publisherId: String? = null,
        dataSourceId: String? = null,
        locationId: String? = null,
        keyword: String? = null,
        userId: Int? = null): Int {


        val publicationStatus = when {
            published -> PublicationStatus.keys["public"] ?: 1
            else -> PublicationStatus.keys["draft"] ?: 2
        }

        return transaction {
            if (userId == null) {
                Events
                    .innerJoin(Places)
                    .slice(id)
                    .select {
                        getSelectExpressions(
                            textQuery = text, start = start, end = end, publicationStatus = publicationStatus,
                            publisherId = publisherId, dataSourceId = dataSourceId, locationId = locationId,
                            keyword = keyword) and
                            (Events.deleted eq false)

                    }.count()
            } else {
                (Events innerJoin Places)
                    .slice(id)
                    .select {
                        getSelectExpressions(
                            textQuery = text, start = start, end = end, publicationStatus = publicationStatus,
                            publisherId = publisherId, dataSourceId = dataSourceId, locationId = locationId,
                            keyword = keyword) and
                            (Events.createdById eq userId)
                    }.count()
            }
        }
    }

    fun countAllForReport(
        published: Boolean = true,
        createdTime: DateTime?
    ): Int {
        val publicationStatus = when {
            published -> PublicationStatus.keys["public"] ?: 1
            else -> PublicationStatus.keys["draft"] ?: 2
        }

        return transaction {
            Events
                .select {
                    (createdTime?.let {
                        Events.deleted eq false
                        //createdTime like
                        (Events.createdTime.between(
                            createdTime.minusDays(1).withTime(21, 0, 0, 0),
                            createdTime.withTime(20, 59, 59, 999)))
                    }?.and(Events.deleted eq false) ?: Events.deleted eq false) and
                    (Events.publicationStatus eq publicationStatus)
                }
                .count()
        }
    }

    fun findById(id: String): Event? {

        // Find event by id with all related info

        return transaction {
            (Events innerJoin Places)
                .slice(getAllFieldsAndRelativeFields())
                .select {
                    (Events.id eq id) and (Places.id eq Events.locationId)
                }.map { event ->
                    constructEventFromResult(event)
                }.let { events ->
                    if (!events.isEmpty()) {
                        events.first()
                    } else {
                        null
                    }
                }
        }
    }

    fun findAllByUserId(
        userId: Int,
        pageSize: Int = 30,
        page: Int = 1,
        published: Boolean = true): ArrayList<Event> {

        val events = ArrayList<Event>()

        val publicationStatus = when {
            published -> PublicationStatus.keys["public"] ?: 1
            else -> PublicationStatus.keys["draft"] ?: 2
        }

        // Limit the results for pagination, pass 0 offset to get the first page
        val offset = if (page == 1) 0 else (page - 1) * pageSize

        transaction {
            (Events innerJoin Places)
                .slice(getAllFieldsAndRelativeFields())
                .select {
                    (Places.id eq Events.locationId) and
                        (Events.createdById eq userId) and
                        (Events.deleted eq false) and
                        (Events.publicationStatus eq publicationStatus)
                }
                // Order first by start time then by created time to avoid missing
                // events that happen at the same time.
                .orderBy(startTime to false, createdTime to false)
                .limit(pageSize, offset)
                .map { event ->
                    events.add(constructEventFromResult(event))
                }
        }

        return events
    }

    fun findAll(pageSize: Int = 30,
                page: Int = 1,
                start: DateTime?,
                end: DateTime?,
                text: String?,
                published: Boolean = true,
                sort: String?,
                publisherId: String?,
                dataSourceId: String?,
                locationId: String?,
                keyword: String?,
                bbox: List<Double>?
    ): ArrayList<Event> {

        val events = ArrayList<Event>()

        // Limit the results for pagination, pass 0 offset to get the first page
        val offset = if (page == 1) 0 else (page - 1) * pageSize

        val publicationStatus = when {
            published -> PublicationStatus.keys["public"] ?: 1
            else -> PublicationStatus.keys["draft"] ?: 2
        }

        transaction {
            Events
                .innerJoin(Places)
                .slice(getAllFieldsAndRelativeFields())
                .select {
                    getSelectExpressions(
                        textQuery = text, start = start, end = end, publicationStatus = publicationStatus,
                        publisherId = publisherId, dataSourceId = dataSourceId, locationId = locationId,
                        keyword = keyword
                    )
                }
                // Order first by start time then by created time to avoid missing
                // events that happen at the same time.
                .orderBy(getSortExpressions(sort))
                .limit(pageSize, offset)
                .map { event ->
                    events.add(constructEventFromResult(event))
                }
        }

        return events
    }

    fun update(eventId: String, event: EventSave) {
        transaction {
            update({ Events.id eq eventId }) {
                it[name] = event.name.fi ?: ""
                it[nameFi] = event.name.fi
                it[nameSv] = event.name.sv
                it[nameEn] = event.name.en

                it[originId] = event.originId
                it[createdTime] = event.createdTime
                it[lastModifiedTime] = DateTime.now()

                it[description] = event.description.fi ?: ""
                it[descriptionFi] = event.description.fi ?: ""
                it[descriptionSv] = event.description.sv ?: ""
                it[descriptionEn] = event.description.en ?: ""

                it[shortDescription] = event.shortDescription.fi ?: ""
                it[shortDescriptionFi] = event.shortDescription.fi ?: ""
                it[shortDescriptionSv] = event.shortDescription.sv ?: ""
                it[shortDescriptionEn] = event.shortDescription.en ?: ""

                it[providerName] = event.providerName
                it[providerEmail] = event.providerEmail
                it[providerPhone] = event.providerPhone
                it[providerLink] = event.providerLink

                it[providerContactName] = event.providerContactName
                it[providerContactEmail] = event.providerContactEmail
                it[providerContactPhone] = event.providerContactPhone

                it[eventStatus] = EventStatus.keys[event.eventStatus] ?: 1

                it[locationExtraInfo] = event.locationExtraInfo?.fi
                it[locationExtraInfoFi] = event.locationExtraInfo?.fi
                it[locationExtraInfoSv] = event.locationExtraInfo?.sv
                it[locationExtraInfoEn] = event.locationExtraInfo?.en

                it[position] = event.position?.let { pos ->
                    when {
                        pos.lat == null || pos.lng == null -> null
                        else -> Point(pos.lat, pos.lng)
                    }
                }

                it[startTime] = event.startTime
                it[endTime] = event.endTime
                it[hasStartTime] = true
                it[hasEndTime] = event.endTime != null

                it[createdById] = event.createdById
                it[lastModifiedById] = event.lastModifiedById

                it[dataSourceId] = event.dataSourceId
                it[locationId] = event.locationId
                it[publisherId] = event.publisherId
                it[superEventId] = event.superEventId
                it[customData] = event.customData

                // New events are saved as draft
                it[publicationStatus] = event.publicationStatus ?: PublicationStatus.keys["draft"] ?: 2
                it[imageId] = event.imageId
                it[deleted] = false
            }
        }
    }

    fun publish(eventId: String) {
        val publicationStatus = PublicationStatus.keys["public"] ?: 1

        transaction {
            update({ Events.id eq eventId }) {
                it[Events.publicationStatus] = publicationStatus
                it[Events.datePublished] = DateTime.now()
            }
        }
    }


    fun delete(eventId: String, fullDelete: Boolean = false) {
        transaction {

            if (!fullDelete) {
                update({ Events.id eq eventId }) {
                    it[deleted] = true
                }
            } else {
                // TODO
            }
        }
    }

    private fun getSelectExpressions(
        textQuery: String?,
        start: DateTime?, end: DateTime?,
        publicationStatus: Int,
        publisherId: String?,
        dataSourceId: String?,
        locationId: String?,
        keyword: String?): Op<Boolean> {

        // Build WHERE clause based on parameters

        var opBuild = Op.build {
            (Events.publicationStatus eq publicationStatus) and
                (Events.deleted eq false)
        }

        locationId?.let {
            opBuild = opBuild.and(Expression.build {
                Places.id eq Events.locationId
            })
        }

        // Filter by dates

        when {
        // TODO Refactor constructing to Time zoned dates (in database, time = UTC format)
            start != null && end == null ->
                opBuild = opBuild.and(Expression.build {
                    (Events.startTime.between(
                        start.minusDays(1).withTime(21, 0, 0, 0),
                        start.withTime(20, 59, 59, 999)))
                })
            start != null && end != null ->
                opBuild = opBuild.and(Expression.build {
                    (Events.startTime.between(
                        start.minusDays(1).withTime(21, 0, 0, 0),
                        end.withTime(20, 59, 59, 999)))
                })
            start == null && end != null ->
                opBuild = opBuild.and(Expression.build {
                    (Events.endTime.between(
                        end.minusDays(1).withTime(21, 0, 0, 0),
                        end.withTime(20, 59, 59, 999)))
                })
            else -> {
                // Do nothing
            }
        }

        // Filter by publisher

        when {
            publisherId != null ->
                opBuild = opBuild.and(Expression.build {
                    (Events.publisherId eq publisherId)
                })
            else -> {
                // Do nothing
            }
        }

        // Filter by data source

        when {
            dataSourceId != null ->
                opBuild = opBuild.and(Expression.build {
                    (Events.dataSourceId eq dataSourceId)
                })
            else -> {
                // Do nothing
            }
        }

        // Filter by location
        when {
            locationId != null ->
                opBuild = opBuild.and(Expression.build {
                    (Events.locationId eq locationId)
                })
            else -> {
                // Do nothing
            }
        }

        when {
            keyword != null -> {
                val keywords = keyword.split(",")


                opBuild = opBuild.and(Expression.build {
                    (Events.id inList
                        (EventKeywords.select {
                            EventKeywords.keywordId eq keyword
                        }.map {
                            it[EventKeywords.eventId]
                        }.toList()))
                })
            }

            else -> {
                // Do nothing
            }
        }

        // Location search query

        when {
            textQuery != null -> {
                val textQueryLike = "%${textQuery.toUpperCase()}%"

                opBuild = opBuild.and(Expression.build {
                    (UpperCase(Events.nameFi) like textQueryLike) or
                        (UpperCase(Events.nameSv) like textQueryLike) or
                        (UpperCase(Events.nameEn) like textQueryLike) or
                        (UpperCase(Places.nameFi) like textQueryLike) or
                        (UpperCase(Places.nameSv) like textQueryLike) or
                        (UpperCase(Places.nameEn) like textQueryLike) or
                        (UpperCase(Events.locationExtraInfoFi) like textQueryLike) or
                        (UpperCase(Events.locationExtraInfoSv) like textQueryLike) or
                        (UpperCase(Events.locationExtraInfoEn) like textQueryLike)
                })
            }
            else -> {
                // Do nothing
            }
        }

        return opBuild
    }

    private fun getSortExpressions(sort: String?): Pair<Expression<*>, Boolean> {
        sort?.let {
            return when (it) {
                "date_published" -> datePublished to false
                "start_time" -> startTime to true
                "end_time" -> endTime to true
                else -> createdTime to false
            }
        }

        return createdTime to false
    }

    private fun getAllFieldsAndRelativeFields(): List<Expression<*>> {
        return listOf<Expression<*>>(
            Events.id, nameFi, nameSv, nameEn, originId, createdTime, lastModifiedTime, infoUrlFi, infoUrlSv,
            infoUrlEn, descriptionFi, descriptionSv, descriptionEn, shortDescriptionFi, shortDescriptionSv,
            shortDescriptionEn, datePublished, providerFi, providerSv, providerEn, providerPhone, providerEmail,
            providerName, providerLink, providerContactName, providerContactEmail, providerContactPhone, eventStatus,
            locationExtraInfoFi, locationExtraInfoSv, locationExtraInfoEn, startTime, endTime, createdById,
            dataSourceId, publisherId, superEventId, customData, publicationStatus, imageId, deleted, position,

            Places.id, Places.nameFi, Places.nameSv, Places.nameEn, Places.originId, Places.infoUrlFi,
            Places.infoUrlSv, Places.infoUrlEn, Places.descriptionFi, Places.descriptionSv, Places.descriptionEn,
            Places.streetAddressFi, Places.streetAddressSv, Places.streetAddressEn, Places.addressRegion,
            Places.postalCode, Places.postOfficeBoxNum, Places.addressCountry, Places.addressLocalityFi,
            Places.addressLocalitySv, Places.addressLocalityEn, Places.customData, Places.createdTime,
            Places.lastModifiedTime, Places.email, Places.contactType, Places.deleted, Places.nEvents,
            Places.dataSourceId, Places.imageId, Places.publisherId, Places.parentId, Places.replacedById,
            Places.position, Places.telephoneFi, Places.telephoneSv, Places.telephoneEn
        )
    }

    private fun constructEventFromResult(resultRow: ResultRow): Event {
        return Event(
            id = resultRow[Events.id],
            name = MultiLangValue(
                fi = resultRow[nameFi],
                sv = resultRow[nameSv],
                en = resultRow[nameEn]
            ),
            originId = resultRow[originId],
            createdTime = resultRow[createdTime],
            lastModifiedTime = resultRow[lastModifiedTime],
            infoUrl = MultiLangValue(
                fi = resultRow[infoUrlFi],
                sv = resultRow[infoUrlSv],
                en = resultRow[infoUrlEn]
            ),
            description = MultiLangValue(
                fi = resultRow[descriptionFi],
                sv = resultRow[descriptionSv],
                en = resultRow[descriptionEn]
            ),
            shortDescription = MultiLangValue(
                fi = resultRow[shortDescriptionFi],
                sv = resultRow[shortDescriptionSv],
                en = resultRow[shortDescriptionEn]
            ),
            datePublished = resultRow[datePublished],
            provider = MultiLangValue(
                fi = resultRow[providerFi],
                sv = resultRow[providerSv],
                en = resultRow[providerEn]
            ),

            providerName = resultRow[providerName],
            providerEmail = resultRow[providerEmail],
            providerPhone = resultRow[providerPhone],
            providerLink = resultRow[providerLink],

            providerContactName = resultRow[providerContactName],
            providerContactEmail = resultRow[providerContactEmail],
            providerContactPhone = resultRow[providerContactPhone],

            eventStatus = resultRow[eventStatus],
            locationExtraInfo = MultiLangValue(
                fi = resultRow[locationExtraInfoFi],
                sv = resultRow[locationExtraInfoSv],
                en = resultRow[locationExtraInfoEn]
            ),
            startTime = resultRow[startTime],
            endTime = resultRow[endTime],
            createdById = resultRow[createdById],
            dataSourceId = resultRow[dataSourceId],
            location = Place(
                id = resultRow[Places.id],
                name = MultiLangValue(
                    fi = resultRow[Places.nameFi],
                    sv = resultRow[Places.nameSv],
                    en = resultRow[Places.nameEn]
                ),
                infoUrl = MultiLangValue(
                    fi = resultRow[Places.infoUrlFi],
                    sv = resultRow[Places.infoUrlSv],
                    en = resultRow[Places.infoUrlEn]
                ),
                description = MultiLangValue(
                    fi = resultRow[Places.descriptionFi],
                    sv = resultRow[Places.descriptionSv],
                    en = resultRow[Places.descriptionEn]
                ),

                streetAddress = MultiLangValue(
                    fi = resultRow[Places.streetAddressFi],
                    sv = resultRow[Places.streetAddressSv],
                    en = resultRow[Places.streetAddressEn]
                ),
                addressRegion = resultRow[Places.addressRegion],
                postalCode = resultRow[Places.postalCode],
                postOfficeBoxNum = resultRow[Places.postOfficeBoxNum],
                addressCountry = resultRow[Places.addressCountry],
                addressLocality = MultiLangValue(
                    fi = resultRow[Places.addressLocalityFi],
                    sv = resultRow[Places.addressLocalitySv],
                    en = resultRow[Places.addressLocalityEn]
                ),

                divisions = ArrayList(),
                customData = resultRow[Places.customData],

                createdTime = resultRow[Places.createdTime],
                lastModifiedTime = resultRow[Places.lastModifiedTime],
                email = resultRow[Places.email],
                contactType = resultRow[Places.contactType],
                deleted = resultRow[Places.deleted],
                nEvents = resultRow[Places.nEvents],
                dataSource = resultRow[Places.dataSourceId],
                image = null,
                publisher = resultRow[Places.publisherId],
                parent = null,
                replacedBy = null,
                position = resultRow[Places.position],

                telephone = MultiLangValue(
                    fi = resultRow[Places.telephoneFi],
                    sv = resultRow[Places.telephoneSv],
                    en = resultRow[Places.telephoneEn]
                )
            ),
            publisherId = resultRow[publisherId],
            superEventId = resultRow[superEventId],
            customData = resultRow[customData],
            publicationStatus = resultRow[publicationStatus],
            imageId = resultRow[imageId],
            deleted = resultRow[deleted],
            position = resultRow[position]?.let { pos ->
                Position(
                    pos.x,
                    pos.y
                )
            }
        )
    }

    private fun generateId(dataSourceId: String): String {
        return "$dataSourceId:${RandomUtil.generateRandomString(10)}"
    }
}
