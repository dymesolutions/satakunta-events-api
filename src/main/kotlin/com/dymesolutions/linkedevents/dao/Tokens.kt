package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.Token
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.select
import org.jetbrains.exposed.sql.transactions.transaction

/**
 * Authorization token
 */
object Tokens : Table(name = "authtoken_token") {
    val key = varchar("key", 40)
    val dateCreated = datetime("created")
    val userId = integer("user_id") references Users.id

    fun add(token: Token) {
        transaction {
            insert {
                it[userId] = token.userId
                it[dateCreated] = token.dateCreated
                it[key] = token.key
            }
        }
    }

    fun findByUserId(userId: Int): String? {
        return transaction {
            select {
                Tokens.userId eq userId
            }.map {
                it[key]
            }.let {
                if (it.isNotEmpty()) {
                    it.first()
                } else {
                    null
                }
            }
        }
    }

    // No need for update
    // fun update() {}

    fun deleteByUserID(userId: Int) {
        transaction {
            deleteWhere {
                Tokens.userId eq userId
            }
        }
    }
}
