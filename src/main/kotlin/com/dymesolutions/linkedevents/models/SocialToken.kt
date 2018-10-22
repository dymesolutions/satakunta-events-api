package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class SocialToken(
    val token: String,
    val tokenSecret: String,
    val dateExpires: DateTime,
    val accountId: Int,
    val appId: Int
)
