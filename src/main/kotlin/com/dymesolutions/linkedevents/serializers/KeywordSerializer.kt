package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.common.utils.DateUtil.jsonDateFormat
import com.dymesolutions.linkedevents.extensions.JsonObjectExtension.addJsonLD
import com.dymesolutions.common.utils.JsonBuilders
import com.dymesolutions.linkedevents.models.*
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import org.joda.time.DateTime

object KeywordSerializer {

    fun toJson(keyword: Keyword, includeFull: Boolean = false): JsonObject {
        val json = JsonObject()

        if (includeFull) {
            json.addJsonLD("keyword", keyword.id, "Keyword")

            json.addProperty("id", keyword.id)
            json.add("alt_labels", JsonArray())
            json.addProperty("createdTime", keyword.createdTime?.toString(jsonDateFormat))
            json.addProperty("last_modified_time", keyword.lastModifiedTime?.toString(jsonDateFormat))
            json.addProperty("aggregate", keyword.aggregate)
            json.addProperty("deprecated", keyword.deprecated)
            json.addProperty("n_events", keyword.nEvents)
            json.addProperty("data_source", keyword.dataSource)
            json.addProperty("image", keyword.image)
            json.addProperty("publisher", keyword.publisher)
            json.add("name", JsonBuilders.gson.toJsonTree(keyword.name))
        } else {
            json.addJsonLD("keyword", keyword.id, "Keyword", true)
        }

        return json
    }

    fun fromJson(json: JsonObject, keywordSet: KeywordSet, userId: Int): KeywordSave {
        val id = json.get("id").asString
        val name = json.get("name").asString

        return KeywordSave(
            id = id,
            name = MultiLangValue(
                fi = name,
                sv = "",
                en = ""
            ),
            originId = "",
            createdTime = DateTime.now(),
            lastModifiedTime = DateTime.now(),
            aggregate = false,
            createdById = userId,
            dataSourceId = keywordSet.dataSourceId,
            lastModifiedById = userId,
            imageId = null,
            deprecated = false,
            nEvents = 0,
            nEventsChanged = false,
            publisherId = keywordSet.organization
        )
    }
}
