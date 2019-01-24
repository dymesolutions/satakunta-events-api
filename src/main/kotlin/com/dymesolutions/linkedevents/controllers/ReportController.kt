package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.common.utils.DateUtil.onlyDateFormat
import com.dymesolutions.linkedevents.dao.*
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import org.joda.time.DateTime
import spark.Request
import spark.Response

class ReportController {

    fun getEventsCount(req: Request, res: Response): Any {
        val response = JsonObject()
        val createdTime = req.queryParams("created_time")

        val activeCount = Events.countAllActiveForReport()
        val publishedCount = Events.countAllPublishedForReport()
        val unpublishedCount = Events.countAllUnPublishedForReport()

        response.addProperty("active_count", activeCount)
        response.addProperty("published_count", publishedCount)

        response.addProperty("unpublished_count", unpublishedCount)

        Events.countAllEventsInPublishingQueue().let { eventCount ->
            response.addProperty("in_queue_count", eventCount)
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

    fun getUserCount(req: Request, res: Response): Any {
        val emailsCount = EmailAddresses.countAll()
        val verifiedEmailsCount = EmailAddresses.countVerified()

        val response = JsonObject()

        response.addProperty("users_registered_count", emailsCount)
        response.addProperty("users_verified_count", verifiedEmailsCount)

        return CommonResponse.ok(response).handle(req, res)
    }
}
