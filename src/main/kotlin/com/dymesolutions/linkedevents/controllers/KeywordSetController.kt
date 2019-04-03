package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.interfaces.Controller
import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.linkedevents.dao.KeywordSets
import com.dymesolutions.linkedevents.dao.Keywords
import com.dymesolutions.linkedevents.serializers.KeywordSetSerializer
import com.dymesolutions.linkedevents.utils.MetaObject
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import spark.Request
import spark.Response

class KeywordSetController : Controller {

    override fun getById(req: Request, res: Response, manager: Boolean): Any {
        val keywordSetId = req.params("keywordSetId")
        val includeParams = req.queryParams("include")

        keywordSetId?.let { id ->
            KeywordSets.findById(id)?.let {
                val keywords = Keywords.findAllByKeywordSetId(id)

                return CommonResponse.ok(KeywordSetSerializer.toJson(it, keywords, includeParams?.split(","))).handle(req, res)
            }

            return CommonResponse.notFound().handle(req, res)
        }

        return JsonObject()
    }

    override fun getAll(req: Request, res: Response, manager: Boolean): Any {
        val includeParams = req.queryParams("include")
        val page = req.queryParams("page")
        val pageSize = req.queryParams("page_size")

        KeywordSets.findAll(
            pageSize?.toInt() ?: 30,
            page?.toInt() ?: 1
        ).let { keywordSets ->
            val metaObject = MetaObject.build(
                KeywordSets.count(),
                "keyword_set",
                pageSize?.toInt() ?: 30,
                page?.toInt() ?: 1)

            val dataArray = JsonArray()

            keywordSets.forEach { keywordSet ->

                val keywords = Keywords.findAllByKeywordSetId(keywordSet.id)

                dataArray.add(KeywordSetSerializer.toJson(
                    keywordSet,
                    keywords,
                    includeParams = includeParams?.split(",")))
            }

            val response = JsonObject()
            response.add("meta", metaObject)
            response.add("data", dataArray)

            return CommonResponse.ok(response).handle(req, res)
        }
    }

    override fun add(req: Request, res: Response) {

    }

    override fun update(req: Request, res: Response, manager: Boolean) {

    }

    override fun delete(req: Request, res: Response, manager: Boolean) {

    }
}
