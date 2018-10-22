package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class SocialAccount(
    val id: Int,
    val provider: String,
    val dateLastLogin: DateTime,
    val dateJoined: DateTime,
    val userId: Int
)
