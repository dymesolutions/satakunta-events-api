package com.dymesolutions.common.responses

import com.dymesolutions.common.utils.JsonBuilders
import com.google.gson.JsonObject
import spark.Route

data class SimpleMessage(
    val message: String
)

object CommonResponse {
    fun badRequest(message: String = "Input format was not correct, eg. mandatory field was missing or JSON was malformed"): Route {
        return Route({ req, res ->
            res.status(400)


            buildSingleRowJsonResponse(SimpleMessage(message))
                .handle(req, res)
        })
    }

    fun notFound(message: String = "Not Found"): Route {
        return Route({ req, res ->
            res.status(404)

            buildSingleRowJsonResponse(SimpleMessage(message))
                .handle(req, res)
        })
    }

    fun notImplemented(message: String = "Not implemented"): Route {
        return Route({ req, res ->
            res.status(501)

            buildSingleRowJsonResponse(SimpleMessage(message))
                .handle(req, res)
        })
    }

    fun ok(message: String = "OK"): Route {
        return Route({ req, res ->
            res.status(200)

            buildSingleRowJsonResponse(SimpleMessage(message))
                .handle(req, res)
        })
    }

    fun ok(json: JsonObject): Route {
        return Route({ req, res ->
            res.status(200)
            res.type("application/json")
            buildSingleRowJsonResponse(json)
                .handle(req, res)
        })
    }

    fun okCreated(message: String = "OK Created"): Route {
        return Route({ req, res ->
            res.status(201)

            buildSingleRowJsonResponse(SimpleMessage(message))
                .handle(req, res)
        })
    }

    fun okCreated(json: JsonObject): Route {
        return Route({ req, res ->
            res.status(201)
            res.type("application/json")
            buildSingleRowJsonResponse(json)
                .handle(req, res)
        })
    }

    fun unauthenticated(message: String = "User was not authenticated"): Route {
        return Route({ req, res ->
            res.status(401)

            buildSingleRowJsonResponse(SimpleMessage(message))
                .handle(req, res)
        })
    }

    fun unauthorized(message: String = "User does not have necessary permissions"): Route {
        return Route({ req, res ->
            res.status(403)

            buildSingleRowJsonResponse(SimpleMessage(message))
                .handle(req, res)
        })
    }

    private fun buildSingleRowJsonResponse(rowObject: Any): Route {
        return Route({ _, res ->
            res.type("application/json")
            JsonBuilders.gson.toJsonTree(rowObject).asJsonObject
        })
    }
}
