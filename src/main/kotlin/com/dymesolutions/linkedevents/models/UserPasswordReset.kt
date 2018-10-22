package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class UserPasswordReset(
    val id: Int,
    val userId: Int,
    val resetKey: String,
    val dateExpires: DateTime
)

data class UserPasswordResetSave(
    val userId: Int,
    val resetKey: String,
    val dateExpires: DateTime
)
