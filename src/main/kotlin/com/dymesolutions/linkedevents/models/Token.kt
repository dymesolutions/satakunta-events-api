package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class Token(
    val key: String,
    val dateCreated: DateTime,
    val userId: Int
)
