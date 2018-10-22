package com.dymesolutions.linkedevents.models

data class SocialApp(
    val id: Int,
    val provider: String,
    val name: String,
    val clientId: String,
    val secret: String,
    val key: String
)
