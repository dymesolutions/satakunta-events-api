package com.dymesolutions.common.plugins

import com.google.gson.JsonParser
import org.slf4j.LoggerFactory
import java.io.BufferedReader
import java.io.File
import java.io.InputStream
import java.io.InputStreamReader
import kotlin.reflect.full.createInstance


object PluginLoader {

    private val log = LoggerFactory.getLogger(PluginLoader::class.java)
    private val jsonParser = JsonParser()
    private val plugins = ArrayList<Plugin>()

    private fun readJarFileDirectory() {

    }

    private fun readInputStream(inputStream: InputStream): String? {
        inputStream.use {
            val resultStringBuilder = StringBuilder()
            try {
                val br = BufferedReader(InputStreamReader(it))
                var line: String?

                line = br.readLine()

                while (line != null) {
                    resultStringBuilder.append(line).append("\n")
                    line = br.readLine()
                }

                return resultStringBuilder.toString()
            } catch (e: Exception) {

                e.printStackTrace()
            }

            return null
        }
    }

    private fun loadPluginConfiguration(fileName: String): PluginConfiguration? {
        if (fileName.isNotBlank()) {
            javaClass.getResourceAsStream("${File.separator}plugins${File.separator}$fileName")?.let { inputStream ->
                val text = readInputStream(inputStream)

                val confJson = jsonParser.parse(text).asJsonObject
                val pluginInterface = confJson.get("interface").asJsonObject
                val pluginId = confJson.get("id").asString

                return PluginConfiguration(
                    id = pluginId,
                    name = confJson.get("name").asString,
                    description = confJson.get("description").asString,
                    properties = confJson.get("properties").asJsonObject,
                    pluginInterface = PluginInterface(
                        className = pluginInterface.get("className").asString,
                        packageName = pluginInterface.get("packageName").asString
                    )
                )
            }
        }

        return null
    }

    /**
     * Plugin configurations must reside in src/main/resources/plugins/
     * as JSON files and be listed in src/main/resources/plugins/plugin-list.txt
     */
    private fun loadPluginConfigurations(): List<PluginConfiguration> {
        val pluginConfigurations = ArrayList<PluginConfiguration>()
        javaClass.getResourceAsStream("${File.separator}plugins${File.separator}plugin-list.txt")?.let { inputStream ->
            readInputStream(inputStream)?.lines()?.forEach { pluginFileName ->
                loadPluginConfiguration(pluginFileName)?.let {
                    pluginConfigurations.add(it)
                }
            }
        }

        return pluginConfigurations
    }

    /**
     * Load class described in JSON, set it's configurations and set it up
     */
    private fun loadPluginClasses(pluginConfigurations: List<PluginConfiguration>) {
        pluginConfigurations.forEach { pluginConfiguration ->
            log.info("[${pluginConfiguration.id}] LOADING...")

            val className = "${pluginConfiguration.pluginInterface.packageName}.${pluginConfiguration.pluginInterface.className}"
            val pluginClass = Class.forName(className).kotlin
            val plugin = pluginClass.createInstance() as Plugin

            plugin.setup(pluginConfiguration)

            plugins.add(plugin)
            log.info("[${pluginConfiguration.id}] LOADED")
        }
    }

    fun loadPlugins() {
        log.info("Loading plugins...")
        loadPluginClasses(loadPluginConfigurations())
    }

    /**
     * Get plugin by type
     */
    fun getPlugin(pluginType: PluginType): Plugin? {
        for (plugin in plugins) {
            if (plugin.type == pluginType) {
                return plugin
            }
        }

        return null
    }
}
