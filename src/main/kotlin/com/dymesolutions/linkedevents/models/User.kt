package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime
import java.util.*

/**
 * Data class for User that can be returned via API (remember to exlude password)
 */
data class User(
    val id: Int,
    val username: String,
    val email: String,
    val password: String,
    val firstName: String,
    val lastName: String,
    val isStaff: Boolean,
    val isSuperUser: Boolean,
    val isActive: Boolean,
    val dateJoined: DateTime,
    val lastLogin: DateTime?,
    val uuid: UUID,
    val organization: Organization?
)


data class UserSave(
    val username: String,
    val email: String,
    val password: String,
    val isStaff: Boolean,
    val isSuperUser: Boolean,
    val isActive: Boolean,
    val firstName: String?,
    val lastName: String?
)

data class UserUpdate(
    val id: Int,
    val username: String,
    val email: String,
    val isStaff: Boolean,
    val isSuperUser: Boolean,
    val isActive: Boolean,
    val firstName: String?,
    val lastName: String?
)
