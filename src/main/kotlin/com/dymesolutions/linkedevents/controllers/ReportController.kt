package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.common.utils.DateUtil.onlyDateFormat
import com.dymesolutions.linkedevents.dao.Events
import com.dymesolutions.linkedevents.dao.Keywords
import com.dymesolutions.linkedevents.dao.Places
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import org.joda.time.DateTime
import spark.Request
import spark.Response

class ReportController {

    fun getEventsCount(req: Request, res: Response): Any {
        val response = JsonObject()
        val createdTime = req.queryParams("created_time")

        Events.countAllForReport(
            published = true,
            createdTime = createdTime?.let { DateTime.parse(it, onlyDateFormat) }
        ).let { eventCount ->
            response.addProperty("published_count", eventCount)
        }

        Events.countAllForReport(
            published = false,
            createdTime = createdTime?.let { DateTime.parse(it, onlyDateFormat) }
        ).let { eventCount ->
            response.addProperty("unpublished_count", eventCount)
        }

        return CommonResponse.ok(response).handle(req, res)
    }

    fun getKeywordUsageCount(req: Request, res: Response): Any {
        val keywordSetId = req.queryParams("keyword_set")

        Keywords.countUsageOfKeywords(
            keywordSetId = keywordSetId
        ).let { keywordUsageReports ->
            val response = JsonObject()
            val data = JsonArray()

            keywordUsageReports.forEach { keywordUsageReport ->
                val reportJson = JsonObject()
                reportJson.addProperty("id", keywordUsageReport.keywordId)
                reportJson.addProperty("name", keywordUsageReport.name)
                reportJson.addProperty("count", keywordUsageReport.count)

                data.add(reportJson)
            }

            response.add("data", data)

            return CommonResponse.ok(response).handle(req, res)
        }
    }

    fun getPlaceUsageCount(req: Request, res: Response): Any {
        val dataSource = req.queryParams("data_source")

        Places.countUsageOfAll(dataSource).let { usageReports ->
            val response = JsonObject()
            val data = JsonArray()

            usageReports.forEach { usageReport ->
                val reportJson = JsonObject()
                reportJson.addProperty("id", usageReport.keywordId)
                reportJson.addProperty("name", usageReport.name)
                reportJson.addProperty("count", usageReport.count)

                data.add(reportJson)
            }

            response.add("data", data)

            return CommonResponse.ok(response).handle(req, res)
        }
    }


    fun getAddedEventsCount(req: Request, res: Response): Any {
        val createdTime = req.queryParams("created_time")

        Events.countAllForReport(
            createdTime = createdTime?.let { DateTime.parse(it, onlyDateFormat) }
        ).let { eventCount ->
            val response = JsonObject()

            response.addProperty("event_count", eventCount)
            return CommonResponse.ok(response).handle(req, res)
        }
    }
}
