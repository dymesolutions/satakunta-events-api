package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.EmailAddress
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction


object EmailAddresses : Table("account_emailaddress") {
    val id = integer("id").primaryKey().autoIncrement()
    val email = varchar("email", 254).uniqueIndex()
    val verified = bool("verified")
    val primary = bool("primary")
    val userId = integer("user_id") references Users.id

    fun add(email: String, userId: Int): Int? {
        return transaction {
            insert {
                it[EmailAddresses.email] = email
                it[verified] = false
                it[primary] = true
                it[EmailAddresses.userId] = userId
            }.generatedKey?.toInt()
        }
    }

    fun verifyById(id: Int) {
        return transaction {
            update({
                (EmailAddresses.id eq id)
            }) {
                it[verified] = true
            }
        }
    }

    fun findByConfirmationKey(key: String): EmailAddress? {
        return transaction {
            (EmailConfirmations innerJoin EmailAddresses)
                .select {
                    (EmailAddresses.id eq EmailConfirmations.emailAddressId) and
                        (EmailConfirmations.key eq key)
                }.map {
                    EmailAddress(
                        id = it[id],
                        email = it[email],
                        verified = it[verified],
                        userId = it[userId]
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

    fun findUserIdByEmail(email: String): Int? {
        return transaction {
            select {
                (EmailAddresses.email eq email)
            }.map {
                it[userId]
            }.first()
        }
    }

    fun findUserIdByKey(key: String): Int? {
        return transaction {
            (EmailConfirmations innerJoin EmailAddresses)
            select {
                (EmailAddresses.email eq email) and
                    (EmailConfirmations.key eq key)
            }.map {
                it[userId]
            }.first()
        }
    }

    fun findByUserId(userId: Int) {
        transaction {
            select {
                id eq userId
            }
        }
    }
}
