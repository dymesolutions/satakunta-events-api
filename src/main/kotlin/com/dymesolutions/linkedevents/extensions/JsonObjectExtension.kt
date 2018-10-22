package com.dymesolutions.linkedevents.extensions

import com.dymesolutions.linkedevents.App
import com.google.gson.JsonObject

object JsonObjectExtension {
    fun JsonObject.addJsonLD(resourcePath: String, resourceId: Any, type: String, onlyId: Boolean = false) {
        this.addProperty("@id", "${App.properties["server.hostName"]}${App.properties["server.apiPath"]}/$resourcePath/$resourceId/")

        if (!onlyId) {
            this.addProperty("@context", "http://schema.org")
            this.addProperty("@type", type)
        }
    }
}
