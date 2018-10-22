package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.SocialApp
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.select
import org.jetbrains.exposed.sql.transactions.transaction

object SocialApps : Table("socialaccount_socialapp") {
    val id = integer("id").autoIncrement().primaryKey()
    val provider = varchar("provider", 30)
    val name = varchar("name", 40)
    val clientId = varchar("client_id", 191)
    val secret = varchar("secret", 191)
    val key = varchar("key", 191)

    fun findByName(_name: String): SocialApp? {
        return transaction {
            select {
                SocialApps.name eq _name
            }.map {
                SocialApp(
                    id = it[id],
                    provider = it[provider],
                    name = it[name],
                    clientId = it[clientId],
                    secret = it[secret],
                    key = it[key]
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

    fun findByProvider(_provider: String): SocialApp? {
        return transaction {
            select {
                SocialApps.name eq _provider
            }.map {
                SocialApp(
                    id = it[id],
                    provider = it[provider],
                    name = it[name],
                    clientId = it[clientId],
                    secret = it[secret],
                    key = it[key]
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
}
