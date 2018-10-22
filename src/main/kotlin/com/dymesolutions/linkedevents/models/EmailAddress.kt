package com.dymesolutions.linkedevents.models

data class EmailAddress(
    val id: Int,
    val email: String,
    val verified: Boolean,
    val userId: Int
)
