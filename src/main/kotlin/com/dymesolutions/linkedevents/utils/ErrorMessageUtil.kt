package com.dymesolutions.linkedevents.utils

import com.dymesolutions.common.plugins.PluginLoader
import com.dymesolutions.common.plugins.PluginType
import com.dymesolutions.common.plugins.SubjectMessage
import java.util.*

object ErrorMessageUtil {
    val topicPublishPlugin = PluginLoader.getPlugin(PluginType.IMAGE_UPLOAD)

    fun sendErrorMessage(message: String) {
        val errorMessage = """
            ERROR REPORTs
            Time: ${Date()}

            $message
        """.trimIndent()

        topicPublishPlugin?.input(SubjectMessage(
            subject = "Error occurred in Linked Events API",
            message = errorMessage
        ))
    }
}
