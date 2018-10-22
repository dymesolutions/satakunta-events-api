package com.dymesolutions.common.plugins

import com.google.gson.JsonObject

data class PluginInterface(
    val className: String,
    val packageName: String
)

/**
 * Populated with a PluginLoader from JSON configuration
 */
data class PluginConfiguration(
    val id: String,
    val name: String,
    val description: String,
    val properties: JsonObject?,
    val pluginInterface: PluginInterface
)
