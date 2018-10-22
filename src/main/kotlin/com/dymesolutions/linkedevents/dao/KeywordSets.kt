package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.KeywordSet
import com.dymesolutions.linkedevents.models.KeywordSetSave
import com.dymesolutions.linkedevents.models.MultiLangValue
import com.dymesolutions.linkedevents.utils.KeywordSetUsage
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import org.joda.time.DateTime

object KeywordSets : Table("events_keywordset") {
    val id = varchar("id", 50).primaryKey()
    val name = varchar("name", 255)
    val nameFi = varchar("name_fi", 255).nullable()
    val nameSv = varchar("name_sv", 255).nullable()
    val nameEn = varchar("name_en", 255).nullable()
    val originId = varchar("origin_id", 50).nullable()
    val createdTime = datetime("created_time").nullable()
    val lastModifiedTime = datetime("last_modified_time").nullable()
    val usage = integer("usage")
    val createdById = integer("created_by_id").nullable()
    val dataSourceId = varchar("data_source_id", 100)
    val lastModifiedById = integer("last_modified_by_id").nullable()
    val organizationId = varchar("organization_id", 255).nullable()
    val imageId = integer("image_id").nullable()

    fun count(): Int {
        return transaction {
            slice(id)
                .selectAll()
                .count()
        }
    }

    fun add(keywordSet: KeywordSetSave) {
        transaction {
            insert {
                it[id] = "${keywordSet.dataSourceId}:${keywordSet.origin}"
                it[name] = keywordSet.name.fi ?: ""
                it[nameFi] = keywordSet.name.fi
                it[nameSv] = keywordSet.name.sv
                it[nameEn] = keywordSet.name.en
                it[originId] = keywordSet.origin
                it[createdTime] = DateTime()
                it[lastModifiedTime] = DateTime()
                it[usage] = keywordSet.usage
                it[createdById] = null
                it[dataSourceId] = keywordSet.dataSourceId
                it[lastModifiedById] = null
                it[organizationId] = keywordSet.organization
                it[imageId] = keywordSet.image
            }
        }
    }

    fun findById(id: String): KeywordSet? {
        return transaction {
            select {
                KeywordSets.id eq id
            }.map { keywordSet ->
                KeywordSet(
                    id = keywordSet[KeywordSets.id],
                    name = MultiLangValue(
                        fi = keywordSet[nameFi],
                        sv = keywordSet[nameSv],
                        en = keywordSet[nameEn]
                    ),
                    usage = keywordSet[usage],
                    origin = keywordSet[originId],
                    createdTime = keywordSet[createdTime],
                    lastModifiedTime = keywordSet[lastModifiedTime],
                    dataSourceId = keywordSet[dataSourceId],
                    image = keywordSet[imageId],
                    organization = keywordSet[organizationId]
                )
            }.let {
                if (!it.isEmpty()) {
                    it.first()
                } else {
                    null
                }
            }
        }
    }

    fun findAll(pageSize: Int = 30,
                page: Int = 1
    ): ArrayList<KeywordSet> {
        val keywordSets = ArrayList<KeywordSet>()
        val offset = if (page == 1) 0 else (page - 1) * pageSize

        transaction {
            selectAll()
                .limit(pageSize, offset)
                .map { keywordSet ->
                    keywordSets.add(KeywordSet(
                        id = keywordSet[id],
                        name = MultiLangValue(
                            fi = keywordSet[nameFi],
                            sv = keywordSet[nameSv],
                            en = keywordSet[nameEn]
                        ),
                        usage = keywordSet[usage],
                        origin = keywordSet[originId],
                        createdTime = keywordSet[createdTime],
                        lastModifiedTime = keywordSet[lastModifiedTime],
                        dataSourceId = keywordSet[dataSourceId],
                        image = keywordSet[imageId],
                        organization = keywordSet[organizationId]
                    ))
                }
        }

        return keywordSets
    }
}
