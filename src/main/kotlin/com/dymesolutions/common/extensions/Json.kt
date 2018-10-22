package com.dymesolutions.common.extensions

import com.google.gson.JsonElement

object Json {
    fun JsonElement.checkForNull(process: (obj: JsonElement?) -> Any?): Any? {
        return if (!this.isJsonNull) {
            process(this)
        } else {
            process(null)
        }
    }
}
