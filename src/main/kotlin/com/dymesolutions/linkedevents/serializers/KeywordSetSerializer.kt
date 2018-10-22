package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.common.utils.DateUtil.jsonDateFormat
import com.dymesolutions.linkedevents.extensions.JsonObjectExtension.addJsonLD
import com.dymesolutions.linkedevents.models.Keyword
import com.dymesolutions.linkedevents.models.KeywordSet
import com.dymesolutions.common.utils.JsonBuilders.gson
import com.google.gson.JsonArray
import com.google.gson.JsonObject

object KeywordSetSerializer {
    fun toJson(keywordSet: KeywordSet, keywords: List<Keyword>, includeParams: List<String>?): JsonObject {
        val json = JsonObject()

        json.addJsonLD("keyword_set", keywordSet.id, "KeywordSet")

        json.addProperty("id", keywordSet.id)
        json.add("name", gson.toJsonTree(keywordSet.name))
        json.addProperty("usage", keywordSet.usage)
        json.addProperty("created_time", keywordSet.createdTime?.toString(jsonDateFormat))
        json.addProperty("last_modified_time", keywordSet.lastModifiedTime?.toString(jsonDateFormat))
        json.addProperty("data_source", keywordSet.dataSourceId)
        json.addProperty("image", keywordSet.image)
        json.addProperty("organization", keywordSet.organization)

        val keywordArray = JsonArray()

        keywords.forEach { keyword ->
            keywordArray.add(KeywordSerializer.toJson(keyword, includeParams?.contains("keywords") ?: false))
        }

        json.add("keywords", keywordArray)

        return json
    }
}
