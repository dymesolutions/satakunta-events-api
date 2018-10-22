package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.common.utils.DateUtil.jsonDateFormat
import com.dymesolutions.linkedevents.App
import com.dymesolutions.linkedevents.models.Image
import com.dymesolutions.linkedevents.models.ImageSave
import com.dymesolutions.linkedevents.models.Organization
import com.dymesolutions.linkedevents.models.User
import com.google.gson.JsonObject
import org.joda.time.DateTime

object ImageSerializer {
    fun fromJson(json: JsonObject, user: User, organization: Organization?): ImageSave {

        val url = json.get("url").asString
        val name = json.get("name").asString
        val photographerName = json.get("photographer_name").asString
        val license = json.get("license").asString

        return ImageSave(
            createdTime = DateTime.now(),
            lastModifiedTime = DateTime.now(),
            image = "",
            url = url,
            cropping = "",
            createdById = user.id,
            lastModifiedById = user.id,
            publisherId = organization?.id ?: "porianon:anonymous",
            name = name,
            licenseId = license,
            photographerName = photographerName,
            dataSourceId = organization?.dataSourceId ?: "porianon"
        )

    }

    fun toJson(image: Image): JsonObject {
        val json = JsonObject()

        json.addProperty("id", image.id)
        json.addProperty("license", image.licenseId)
        json.addProperty("name", image.name)
        json.addProperty("created_time", image.createdTime.toString(jsonDateFormat))
        json.addProperty("last_modified_time", image.lastModifiedTime.toString(jsonDateFormat))
        json.addProperty("url", image.url)
        json.addProperty("cropping", image.cropping)
        json.addProperty("photographer_name", image.photographerName)
        json.addProperty("data_source", image.dataSourceId)
        json.addProperty("publisher", image.publisherId)

        json.addProperty("@id", "${App.properties["server.hostName"]}${App.properties["server.apiPath"]}/image/${image.id}/")
        json.addProperty("@context", "http://schema.org")
        json.addProperty("@type", "ImageObject")

        return json
    }
}
