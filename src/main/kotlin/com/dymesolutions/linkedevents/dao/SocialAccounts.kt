package com.dymesolutions.linkedevents.dao

import org.jetbrains.exposed.sql.Table

object SocialAccounts : Table("socialaccount_socialaccount") {
    val id = integer("id").autoIncrement().primaryKey()
    val provider = varchar("provider", 30)
    val uid = varchar("uid", 191)
    val dateLastLogin = datetime("last_login_date")
    val dateJoined = datetime("date_joined")
    val extraData = text("extra_data")
    val userId = integer("user_id") references Users.id
}
