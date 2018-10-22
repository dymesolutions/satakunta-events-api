package com.dymesolutions.linkedevents.models

data class RegisterUser(
    val username: String,
    val email: String,
    val password: String,
    val firstName: String,
    val lastName: String
)
