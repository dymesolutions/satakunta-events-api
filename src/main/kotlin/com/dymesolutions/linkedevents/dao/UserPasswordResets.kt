package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.UserPasswordReset
import com.dymesolutions.linkedevents.models.UserPasswordResetSave
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.deleteWhere
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.select
import org.jetbrains.exposed.sql.transactions.transaction

object UserPasswordResets : Table("user_password_reset") {
    val id = integer("id").primaryKey().autoIncrement()
    val userId = integer("user_id") references Users.id
    val resetKey = varchar("reset_key", 64)
    val dateExpires = datetime("date_expires")

    fun add(userPasswordReset: UserPasswordResetSave): Int? {
        return transaction {
            insert {
                it[userId] = userPasswordReset.userId
                it[resetKey] = userPasswordReset.resetKey
                it[dateExpires] = userPasswordReset.dateExpires
            }
        }.generatedKey?.toInt()
    }

    fun findByResetKey(resetKey: String): UserPasswordReset? {
        return transaction {
            select {
                UserPasswordResets.resetKey eq resetKey
            }
                .orderBy(UserPasswordResets.dateExpires, false)
                .map {
                    UserPasswordReset(
                        id = it[UserPasswordResets.id],
                        userId = it[UserPasswordResets.userId],
                        resetKey = it[UserPasswordResets.resetKey],
                        dateExpires = it[UserPasswordResets.dateExpires]
                    )
                }.let {
                    when {
                        !it.isEmpty() -> it.first()
                        else -> null

                    }
                }

        }
    }

    fun delete(id: Int) {
        transaction {
            deleteWhere {
                UserPasswordResets.id eq id
            }
        }
    }

    fun deleteByUserId(userId: Int) {
        transaction {
            deleteWhere {
                UserPasswordResets.userId eq userId
            }
        }
    }
}
