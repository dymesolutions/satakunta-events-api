package com.dymesolutions.linkedevents

import org.pac4j.sparkjava.SecurityFilter
import spark.Spark.*

class AppFilter {
    fun initFilters() {
        val config = AuthConfigFactory().build()

        // Enable CORS
        options("/*") { req, res ->
            val accessControlRequestHeaders = req.headers("Access-Control-Request-Headers")
            val accessControlRequestMethod = req.headers("Access-Control-Request-Method")

            accessControlRequestHeaders?.let {
                res.header("Access-Control-Allow-Headers", accessControlRequestHeaders)
            }

            accessControlRequestMethod?.let {
                res.header("Access-Control-Request-Method", accessControlRequestMethod)
            }

            ""
        }

        before("*") { _, res ->
            res.header("Access-Control-Allow-Origin", "*")
            res.header("Access-Control-Request-Methods", "POST, PUT, GET, OPTIONS, DELETE")
            res.header("Access-Control-Allow-Methods", "POST, PUT, GET, OPTIONS, DELETE")
            res.header("Access-Control-Allow-Headers", "Authorization, Content-Type, Accept, X-Requested-With")
        }

        // Roles are set in AuthConfigFactory

        // Admin routes are for managing everything (destructive)
        before("${App.properties["server.apiPath"]}/admin/*", SecurityFilter(config, "HeaderClient", "superUser", "allMethods"))

        // Manage routes are for managing and moderating
        before("${App.properties["server.apiPath"]}/manager/*", SecurityFilter(config, "HeaderClient", "manager", "allMethods"))

        // Basic routes (adding, editing own events)
        // stateAlteringMethods matcher will filter only PUT, POST, DELETE requests
        before("${App.properties["server.apiPath"]}/logout/", SecurityFilter(config, "HeaderClient", "basic", "allMethods"))
        before("${App.properties["server.apiPath"]}/event/*", SecurityFilter(config, "HeaderClient", "basic", "stateAlteringMethods"))
        before("${App.properties["server.apiPath"]}/keyword/*", SecurityFilter(config, "HeaderClient", "basic", "stateAlteringMethods"))
        before("${App.properties["server.apiPath"]}/image/*", SecurityFilter(config, "HeaderClient", "basic", "stateAlteringMethods"))

        before("${App.properties["server.apiPath"]}/basic/*", SecurityFilter(config, "HeaderClient", "basic", "allMethods"))

        // Add server header to hide server version info
        after("/*") { _, response -> response.header("Server", "Linked Events") }
    }
}
