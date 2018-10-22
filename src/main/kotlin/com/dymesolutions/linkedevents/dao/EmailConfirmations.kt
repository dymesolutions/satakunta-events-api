package com.dymesolutions.linkedevents.dao

import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.transactions.transaction
import org.joda.time.DateTime

object EmailConfirmations : Table("account_emailconfirmation") {
    val id = integer("id").autoIncrement().primaryKey()
    val dateCreated = datetime("created")
    val dateSent = datetime("sent").nullable()
    val key = varchar("key", 64)
    val emailAddressId = integer("email_address_id") references EmailAddresses.id

    fun add(key: String, emailAddressId: Int) {
        transaction {
            insert {
                it[dateCreated] = DateTime.now()
                it[dateSent] = DateTime.now()
                it[EmailConfirmations.key] = key
                it[EmailConfirmations.emailAddressId] = emailAddressId
            }
        }
    }

    fun delete(emailAddressId: Int) {
        transaction {
            deleteWhere {
                EmailConfirmations.emailAddressId eq emailAddressId
            }
        }
    }
}
