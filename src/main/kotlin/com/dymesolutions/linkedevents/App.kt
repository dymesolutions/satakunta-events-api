package com.dymesolutions.linkedevents

import com.dymesolutions.common.plugins.PluginLoader
import com.dymesolutions.common.utils.RequestLogUtils
import com.dymesolutions.linkedevents.migrations.Migrations
import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import org.jetbrains.exposed.sql.Database
import org.slf4j.LoggerFactory
import spark.Spark.port
import spark.Spark.staticFiles
import java.util.*
import kotlin.collections.set

object App {

    private val log = LoggerFactory.getLogger(App::class.java)

    val properties = Properties()

    @JvmStatic
    fun main(args: Array<String>) {

        args.forEach {
            println("Arg $it")
        }

        initDatabaseConnection { ready ->
            when (ready) {
                true -> {
                    // Need to explicitly tell us to migrate the data
                    if (args.contains("migrate")) migrate()
                    initServer()
                }
                false -> log.info("Can't start server, could not initiate database connection")
            }
        }
    }

    private fun initDatabaseConnection(next: (ready: Boolean) -> Unit) {
        log.info("Initializing database connection")

        val databaseOk = retryDatabaseConnection()

        if (databaseOk) {
            next(true)
        } else {
            next(false)
        }
    }

    /**
     * Retry connection every 10 seconds for 10 times until connection is found
     */
    private fun retryDatabaseConnection(retries: Int = 10, timeBetweenRetries: Long = 10000): Boolean {
        for (i in 1..retries) {
            try {
                log.info("Trying database connection...")
                val dataSource = HikariDataSource(resolveHikariConfig())
                Database.connect(dataSource)
                return true
            } catch (e: Exception) {
                val message = "Can't connect to database, trying again in ${timeBetweenRetries / 1000} seconds."
                log.error(message)
                e.printStackTrace()

                // ErrorMessageUtil.sendErrorMessage(message)

                Thread.sleep(timeBetweenRetries)
            }
        }

        return false
    }

    private fun resolveHikariConfig(): HikariConfig {
        // If environmental variables are not set, use the properties file.
        // This can be used to have different database access when developing locally.

        return if (System.getenv("DATASOURCE_USER") != null) {
            log.info("Reading properties from environment variables")
            val props = Properties()

            props["dataSourceClassName"] = "org.postgresql.ds.PGSimpleDataSource"
            props["dataSource.user"] = System.getenv("DATASOURCE_USER")
            props["dataSource.password"] = System.getenv("DATASOURCE_PASSWORD")
            props["dataSource.databaseName"] = System.getenv("DATASOURCE_DATABASE")
            props["dataSource.portNumber"] = System.getenv("DATASOURCE_PORT")
            props["dataSource.serverName"] = System.getenv("DATASOURCE_HOST")

            HikariConfig(props)
        } else {
            log.info("Reading properties from file")
            HikariConfig("/hikari.properties")
        }
    }

    private fun readProperties() {
        val propFile = javaClass.getResource("/app.properties")
        properties.load(propFile.openStream())
    }

    private fun initServer() {
        /*
         * Setup everything, filters, routes, static files,
         * headers.
         */
        readProperties()
        PluginLoader.loadPlugins()

        log.info("Initializing server...")

        RequestLogUtils.createServerWithRequestLog(log)

        staticFiles.location("/static")

        port((properties["server.port"] as String).toInt())

        val filters = AppFilter()
        val routes = AppRoute()
        val headers = AppHeader()

        filters.initFilters()
        headers.initHeaders()
        routes.initRoutes()

        log.info("...server initialized.")
    }

    private fun migrate() {
        Migrations().checkSchemaAndMigrateData()
    }
}

