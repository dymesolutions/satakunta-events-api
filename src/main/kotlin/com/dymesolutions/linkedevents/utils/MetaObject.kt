package com.dymesolutions.linkedevents.utils

import com.dymesolutions.linkedevents.App
import com.google.gson.JsonElement
import com.google.gson.JsonNull
import com.google.gson.JsonObject

object MetaObject {
    fun build(count: Int, type: String, pageSize: Int = 30, page: Int = 1): JsonObject {
        val metaObject = JsonObject()

        // By API spec these links can be null
        var next: String? = null
        var previous: String? = null

        if (count > pageSize * page) {
            next = "${App.properties["server.hostName"]}${App.properties["server.apiPath"]}/$type/?page=${page + 1}&page_size=$pageSize"
        }

        if (page > 1) {
            previous = "${App.properties["server.hostName"]}${App.properties["server.apiPath"]}/$type/?page=${page - 1}&page_size=$pageSize"
        }

        metaObject.addProperty("count", count)

        when (next) {
            null -> metaObject.add("next", JsonNull.INSTANCE)
            else -> metaObject.addProperty("next", next)
        }

        when (previous) {
            null -> metaObject.add("previous", JsonNull.INSTANCE)
            else -> metaObject.addProperty("previous", previous)
        }

        return metaObject
    }
}
