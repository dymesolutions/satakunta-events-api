package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.responses.CommonResponse
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import com.google.gson.JsonSyntaxException
import spark.Request
import spark.Response

/**
 * Handles JSON requests (POST or PUT)
 */
object JsonRequestHandler {

    private val jsonParser = JsonParser()

    /**
     * Handle checks if request body is present and whether it can be processed as JSON. Then passes the request body
     * to the callback function.
     */
    fun handle(req: Request, res: Response, process: (req: Request, res: Response, requestBodyJson: JsonObject) -> Any): Any {
        val requestBody: String? = req.body()

        if (requestBody.isNullOrBlank()) {
            return CommonResponse.badRequest("Request body is empty").handle(req, res)
        }

        return try {
            val requestBodyJson = jsonParser.parse(requestBody) as JsonObject
            process(req, res, requestBodyJson)
        } catch (e: JsonSyntaxException) {
            CommonResponse.badRequest("Request body was malformed").handle(req, res)
        } catch (e: Exception) {
            e.printStackTrace()
            CommonResponse.badRequest("Unknown error").handle(req, res)
        }
    }
}
