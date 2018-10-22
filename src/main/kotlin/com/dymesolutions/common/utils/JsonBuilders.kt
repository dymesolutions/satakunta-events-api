package com.dymesolutions.common.utils

import com.google.gson.*
import org.joda.time.format.DateTimeFormat

/**
 * Reusable builders
 */
object JsonBuilders {

    val jsonParser = JsonParser()
    private val gsonBuilder = GsonBuilder().serializeNulls()
    val gson = gsonBuilder.create()
    private val dateFormat = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")

    fun parseToObject(json: String): JsonObject? {
        return try {
            jsonParser.parse(json).asJsonObject
        } catch (e: Exception) {
            null
        }
    }

    fun parseToArray(json: String): JsonArray? {
        return try {
            jsonParser.parse(json).asJsonArray
        } catch (e: Exception) {
            null
        }
    }

    fun toJsonTree(src: Any?): JsonElement {
        return gson.toJsonTree(src)
    }
}
