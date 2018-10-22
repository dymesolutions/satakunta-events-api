package com.dymesolutions.common.plugins

interface Plugin {
    // Plugin is called by it's type (e.g. IMAGE_UPLOAD)
    val type: PluginType

    // Before calling plugin, configured -property can be used to check if plugin was properly configured
    var configured: Boolean

    // Setup is called from PluginLoader, plugins can use the passed configuration for further config
    fun setup(configuration: PluginConfiguration)

    // input() takes data and does something with it
    fun input(values: Any): PluginResponse?

    // output() outputs data
    fun output(): Any
}
