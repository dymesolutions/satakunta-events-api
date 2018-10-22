package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.*
import com.dymesolutions.linkedevents.utils.PublicationStatus
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction

object EventAudiences : Table("events_event_audience") {
    val id = integer("id").primaryKey().autoIncrement()
    val eventId = varchar("event_id", 50) references Events.id
    val keywordId = varchar("keyword_id", 50) references Keywords.id

    fun findAllAudienceIdsByEventId(eventId: String): ArrayList<String> {
        val audienceIds = ArrayList<String>()

        transaction {
            select {
                EventAudiences.eventId eq eventId
            }.map {
                audienceIds.add(it[EventAudiences.keywordId])
            }
        }

        return audienceIds
    }

    fun add(eventId: String, audienceId: String): Int? {
        return transaction {
            insert {
                it[EventAudiences.eventId] = eventId
                it[EventAudiences.keywordId] = audienceId
            }.generatedKey?.toInt()
        }
    }


    fun deleteAllByEventId(eventId: String) {
        transaction {
            deleteWhere {
                EventAudiences.eventId eq eventId
            }
        }
    }

    fun delete(eventId: String, audienceId: String) {
        transaction {
            deleteWhere {
                EventAudiences.eventId eq eventId and
                    (EventAudiences.keywordId eq keywordId)
            }
        }
    }
}

object EventKeywords : Table("events_event_keywords") {
    val id = integer("id").primaryKey().autoIncrement()
    val eventId = varchar("event_id", 50) references Events.id
    val keywordId = varchar("keyword_id", 50) references Keywords.id

    fun findAllKeywordIdsByEventId(eventId: String): ArrayList<String> {
        val keywordIds = ArrayList<String>()

        transaction {
            select {
                EventKeywords.eventId eq eventId
            }.map {
                keywordIds.add(it[EventKeywords.keywordId])
            }
        }

        return keywordIds
    }

    fun add(eventId: String, keywordId: String): Int? {
        return transaction {
            insert {
                it[EventKeywords.eventId] = eventId
                it[EventKeywords.keywordId] = keywordId
            }.generatedKey?.toInt()
        }
    }

    fun deleteAllByEventId(eventId: String) {
        transaction {
            deleteWhere {
                EventKeywords.eventId eq eventId
            }
        }
    }

    fun delete(eventId: String, keywordId: String) {
        transaction {
            deleteWhere {
                EventKeywords.eventId eq eventId and
                    (EventKeywords.keywordId eq keywordId)
            }
        }
    }
}

object KeywordSetKeywords : Table("events_keywordset_keywords") {
    val id = integer("id").primaryKey().autoIncrement()
    val keywordSetId = varchar("keywordset_id", 50) references KeywordSets.id
    val keywordId = varchar("keyword_id", 50) references Keywords.id

    fun add(keywordSetId: String, keywordId: String) {
        transaction {
            insert {
                it[KeywordSetKeywords.keywordSetId] = keywordSetId
                it[KeywordSetKeywords.keywordId] = keywordId
            }
        }
    }
}

object Keywords : Table("events_keyword") {
    val id = varchar("id", 50).primaryKey()
    val name = varchar("name", 255)
    val nameFi = varchar("name_fi", 255).nullable()
    val nameSv = varchar("name_sv", 255).nullable()
    val nameEn = varchar("name_en", 255).nullable()
    val originId = varchar("origin_id", 50).nullable()
    val createdTime = datetime("created_time").nullable()
    val lastModifiedTime = datetime("last_modified_time").nullable()
    val aggregate = bool("aggregate")
    val createdById = integer("created_by_id").nullable()
    val dataSourceId = varchar("data_source_id", 100)
    val lastModifiedById = integer("last_modified_by_id").nullable()
    val imageId = integer("image_id").nullable()
    val deprecated = bool("deprecated")
    val nEvents = integer("n_events")
    val nEventsChanged = bool("n_events_changed")
    val publisherId = varchar("publisher_id", 255).nullable()

    fun count(keywordSetId: String?): Int {
        return transaction {
            Keywords
                .innerJoin(KeywordSetKeywords)
                .slice(id)
                .select {
                    keywordSetId?.let {
                        // Find by keyword set ID
                        (KeywordSetKeywords.keywordSetId eq (keywordSetId)) and
                            (KeywordSetKeywords.keywordId eq Keywords.id)
                    } ?: Keywords.id.isNotNull() // Else return this Op
                }.count()
        }
    }

    fun countUsageOfKeywords(keywordSetId: String?): List<UsageReport> {

        // TODO Update query to include keywordsetid
        val reports = ArrayList<UsageReport>()

        when (keywordSetId) {
            "pori:audiences" -> {
                transaction {
                    // logger.addLogger(StdOutSqlLogger)

                    EventAudiences
                        .leftJoin(Keywords)
                        .leftJoin(Events)
                        .slice(Keywords.name, EventAudiences.keywordId, EventAudiences.id.count())
                        .select {
                            Keywords.id eq EventAudiences.keywordId and
                                (Events.id eq EventAudiences.eventId) and
                                (Events.deleted eq false) and
                                (Events.publicationStatus eq 1)
                        }
                        .groupBy(Keywords.name, EventAudiences.keywordId)
                        .orderBy(EventAudiences.id.count(), false)
                        .map {
                            reports.add(UsageReport(
                                it[EventAudiences.keywordId],
                                it[Keywords.name],
                                it[EventAudiences.id.count()]
                            ))
                        }
                }
            }
            "pori:topics" -> {
                transaction {
                    // logger.addLogger(StdOutSqlLogger)

                    EventKeywords
                        .leftJoin(Keywords)
                        .leftJoin(Events)
                        .slice(Keywords.name, EventKeywords.keywordId, EventKeywords.id.count())
                        .select {
                            Keywords.id eq EventKeywords.keywordId and
                                (Events.deleted eq false) and
                                (Events.publicationStatus eq 1)
                        }
                        .groupBy(Keywords.name, EventKeywords.keywordId)
                        .orderBy(EventKeywords.id.count(), false)
                        .map {
                            reports.add(UsageReport(
                                it[EventKeywords.keywordId],
                                it[Keywords.name],
                                it[EventKeywords.id.count()]
                            ))
                        }
                }
            }
        }
        return reports
    }

    fun add(keyword: KeywordSave) {
        transaction {
            insert {
                it[id] = keyword.id
                it[name] = keyword.name.fi ?: ""
                it[nameFi] = keyword.name.fi
                it[nameSv] = keyword.name.fi
                it[nameEn] = keyword.name.fi
                it[originId] = keyword.name.fi
                it[createdTime] = keyword.createdTime
                it[lastModifiedTime] = keyword.lastModifiedTime
                it[aggregate] = keyword.aggregate

                it[dataSourceId] = keyword.dataSourceId

                it[imageId] = keyword.imageId
                it[deprecated] = keyword.deprecated
                it[nEvents] = 0
                it[nEventsChanged] = false
                it[publisherId] = keyword.publisherId
            }
        }
    }

    fun findAll(page: Int = 1, pageSize: Int = 30, keywordSetId: String?): ArrayList<Keyword> {
        val keywords = ArrayList<Keyword>()

        val offset = if (page == 1) 0 else (page - 1) * pageSize

        transaction {
            Keywords
                .innerJoin(KeywordSetKeywords)
                .select {
                    keywordSetId?.let {
                        // Find by keyword set ID
                        (KeywordSetKeywords.keywordSetId eq (keywordSetId)) and
                            (KeywordSetKeywords.keywordId eq Keywords.id)
                    } ?: Keywords.id.isNotNull() // Else return this Op
                }
                .limit(pageSize, offset)
                .map {
                    keywords.add(Keyword(
                        id = it[Keywords.id],
                        name = MultiLangValue(
                            fi = it[nameFi],
                            sv = it[nameSv],
                            en = it[nameEn]
                        ),
                        createdTime = it[Keywords.createdTime],
                        lastModifiedTime = it[Keywords.lastModifiedTime],
                        aggregate = it[Keywords.aggregate],
                        deprecated = it[Keywords.deprecated],
                        nEvents = it[Keywords.nEvents],
                        dataSource = it[Keywords.dataSourceId],
                        image = it[Keywords.imageId],
                        publisher = it[Keywords.publisherId]
                    ))
                }
        }

        return keywords
    }

    fun findAllByKeywordSetId(keywordSetId: String): ArrayList<Keyword> {
        val keywords = ArrayList<Keyword>()

        transaction {
            (KeywordSetKeywords innerJoin Keywords)
                .slice(
                    id, createdTime, lastModifiedTime, aggregate, deprecated, nEvents, dataSourceId, imageId,
                    publisherId, name, nameFi, nameSv, nameEn)
                .select {
                    (KeywordSetKeywords.keywordSetId eq keywordSetId) and
                        (Keywords.id eq KeywordSetKeywords.keywordId)
                }.map { keyword ->
                    keywords.add(constructKeywordFromResult(keyword))
                }
        }

        return keywords
    }

    fun findAllAudiencesByEventId(eventId: String): ArrayList<Keyword> {
        val audiences = ArrayList<Keyword>()

        transaction {
            (EventAudiences innerJoin Keywords)
                .slice(
                    id, createdTime, lastModifiedTime, aggregate, deprecated, nEvents, dataSourceId, imageId,
                    publisherId, name, nameFi, nameSv, nameEn)
                .select {
                    (EventAudiences.eventId eq eventId) and (Keywords.id eq EventAudiences.keywordId)
                }.map { keyword ->
                    audiences.add(constructKeywordFromResult(keyword))
                }
        }

        return audiences
    }

    fun findAllTopicsByEventId(eventId: String): ArrayList<Keyword> {
        val keywords = ArrayList<Keyword>()

        transaction {
            (EventKeywords innerJoin Keywords)
                .slice(
                    id, createdTime, lastModifiedTime, aggregate, deprecated, nEvents, dataSourceId, imageId,
                    publisherId, name, nameFi, nameSv, nameEn)
                .select {
                    (EventKeywords.eventId eq eventId) and (Keywords.id eq EventKeywords.keywordId)
                }.map { keyword ->
                    keywords.add(constructKeywordFromResult(keyword))
                }
        }

        return keywords
    }

    fun findById(id: String): Keyword? {
        return transaction {
            select {
                Keywords.id eq id
            }.map {
                constructKeywordFromResult(it)
            }.let {
                if (!it.isEmpty()) {
                    it.first()
                } else {
                    null
                }
            }
        }
    }

    fun findIdExists(id: String): Boolean {
        return transaction {
            select {
                Keywords.id eq id
            }.count() > 0
        }
    }

    fun findNameExists(name: String): Boolean {
        return transaction {
            select {
                Keywords.name eq name
            }.count() > 0
        }
    }

    private fun constructKeywordFromResult(result: ResultRow): Keyword {
        return Keyword(
            id = result[id],
            createdTime = result[createdTime],
            lastModifiedTime = result[lastModifiedTime],
            aggregate = result[aggregate],
            deprecated = result[deprecated],
            nEvents = result[nEvents],
            dataSource = result[dataSourceId],
            image = result[imageId],
            publisher = result[publisherId],
            name = MultiLangValue(
                fi = result[nameFi],
                sv = result[nameSv],
                en = result[nameEn]
            )
        )
    }
}
