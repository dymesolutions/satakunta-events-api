package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.linkedevents.models.User
import com.dymesolutions.linkedevents.models.UserUpdate
import com.google.gson.JsonObject

object UserSerializer {

    fun toJson(user: User, includeFull: Boolean = false): JsonObject {
        val json = JsonObject()

        json.addProperty("id", user.id)
        json.addProperty("first_name", user.firstName)
        json.addProperty("last_name", user.lastName)
        json.addProperty("username", user.username)
        json.addProperty("email", user.email)
        json.addProperty("is_staff", user.isStaff)
        json.addProperty("is_superuser", user.isSuperUser)
        json.addProperty("is_active", user.isActive)
        json.addProperty("email", user.email)

        user.organization?.let {
            json.add("organization", OrganizationSerializer.toJson(it, true))
        }

        //json.add()

        return json
    }

    fun fromJson(json: JsonObject, user: User): UserUpdate? {

        // val userId = json.get("id")?.asInt
        val firstName = json.get("first_name")?.asString
        val lastName = json.get("last_name")?.asString
        // val username = json.get("username")?.asString
        // val email = json.get("email")?.asString
        val isActive = json.get("is_active")?.asBoolean
        val isStaff = json.get("is_staff")?.asBoolean
        // val organization = json.get("organization")?.asJsonObject

        return UserUpdate(
            id = user.id,
            username = user.username,
            email = user.email,
            isStaff = isStaff ?: user.isStaff,
            isSuperUser = user.isSuperUser,
            isActive = isActive ?: user.isActive,
            firstName = firstName ?: user.firstName,
            lastName = lastName ?: user.lastName
        )
    }
}
