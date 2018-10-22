package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.DataSource
import com.dymesolutions.linkedevents.models.DataSourceSave
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.select
import org.jetbrains.exposed.sql.transactions.transaction

object DataSources : Table("events_datasource") {
    val id = varchar("id", 100).primaryKey()
    val name = varchar("name", 255)
    val apiKey = varchar("api_key", 128)
    val ownerId = varchar("owner_id", 255).nullable()
    val userEditable = bool("user_editable")

    fun add(dataSource: DataSourceSave) {
        transaction {
            insert {
                it[id] = dataSource.id
                it[name] = dataSource.name
                it[apiKey] = dataSource.apiKey
                it[ownerId] = dataSource.ownerId
                it[userEditable] = dataSource.userEditable
            }
        }
    }

    fun findById(dataSourceId: String): DataSource? {
        return transaction {
            DataSources.select {
                id eq dataSourceId
            }.map {
                DataSource(
                    id = it[id],
                    name = it[name],
                    apiKey = it[apiKey],
                    ownerId = it[ownerId],
                    userEditable = it[userEditable]
                )
            }.let { if (it.isEmpty()) null else it.first() }
        }
    }
}
