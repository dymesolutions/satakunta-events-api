package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.SocialToken
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.transactions.transaction

object SocialTokens : Table("socialaccount_socialtoken") {
    val id = integer("id").autoIncrement().primaryKey()
    val token = text("token")
    val tokenSecret = text("token_secret")
    val dateExpires = datetime("expires_at")
    val accountId = integer("account_id") references SocialAccounts.id
    val appId = integer("app_id") references SocialApps.id

    fun add(socialToken: SocialToken) {
        transaction {
            insert {
                it[token] = socialToken.token
                it[tokenSecret] = socialToken.tokenSecret
                it[dateExpires] = socialToken.dateExpires
                it[accountId] = socialToken.accountId
                it[appId] = socialToken.appId
            }
        }
    }
}
