package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.interfaces.Controller
import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.common.utils.JsonBuilders.jsonParser
import com.dymesolutions.common.utils.UserUtil
import com.dymesolutions.linkedevents.dao.KeywordSets
import com.dymesolutions.linkedevents.dao.Keywords
import com.dymesolutions.linkedevents.serializers.KeywordSerializer
import com.dymesolutions.linkedevents.utils.MetaObject
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import org.jetbrains.exposed.sql.exists
import spark.Request
import spark.Response

class KeywordController : Controller {

    override fun getById(req: Request, res: Response, manager: Boolean): Any {
        val keywordId = req.params("keywordId")

        keywordId?.let { id ->
            Keywords.findById(id)?.let {
                return CommonResponse.ok(KeywordSerializer.toJson(it, true)).handle(req, res)
            }

            return CommonResponse.notFound().handle(req, res)
        }

        return CommonResponse.badRequest("Keyword ID is missing").handle(req, res)
    }

    override fun getAll(req: Request, res: Response, manager: Boolean): Any {

        val page = req.queryParams("page")
        val pageSize = req.queryParams("page_size")
        val keywordSet = req.queryParams("keyword_set")

        Keywords.findAll(
            page = page?.toInt() ?: 1,
            pageSize = pageSize?.toInt() ?: 30,
            keywordSetId = keywordSet
        ).let { keywords ->

            val meta = MetaObject.build(
                count = Keywords.count(keywordSet),
                type = "keyword",
                page = page?.toInt() ?: 1,
                pageSize = pageSize?.toInt() ?: 30)

            val data = JsonArray()

            keywords.forEach { keyword ->
                data.add(KeywordSerializer.toJson(keyword, true))
            }

            val response = JsonObject()

            response.add("meta", meta)
            response.add("data", data)

            return CommonResponse.ok(response).handle(req, res)
        }
    }

    // POST & PUT functions

    override fun add(req: Request, res: Response): Any {
        try {
            when {
                req.body().isNotBlank() -> {

                    val requestBodyJson = jsonParser.parse(req.body()) as JsonObject

                    val profile = UserUtil.getUserProfile(req, res)

                    profile.get().let { userProfile ->
                        val userId = userProfile.getAttribute("userId")

                        requestBodyJson.get("keyword_set_id")?.let { keywordSetId ->
                            KeywordSets.findById(keywordSetId.asString)?.let { keywordSet ->
                                KeywordSerializer.fromJson(requestBodyJson, keywordSet, userId as Int).let { keyword ->
                                    Keywords.add(keyword)
                                    return CommonResponse.okCreated().handle(req, res)
                                }
                            }
                        }
                    }
                }

                else -> {
                    return CommonResponse.badRequest("Request body is blank").handle(req, res)
                }
            }

        } catch (e: Exception) {
            e.printStackTrace()
            return CommonResponse.badRequest("Request body can't be parsed").handle(req, res)
        }

        return CommonResponse.notImplemented("Unknown error").handle(req, res)
    }

    override fun update(req: Request, res: Response, manager: Boolean) {

    }

    override fun delete(req: Request, res: Response, manager: Boolean) {

    }

    fun getExists(req: Request, res: Response): Any {
        req.queryParams("id")?.let { id ->
            val response = JsonObject()

            return when {
                Keywords.findIdExists(id) -> {
                    response.addProperty("exists", true)
                    CommonResponse.ok(response).handle(req, res)
                }

                else -> {
                    response.addProperty("exists", false)
                    CommonResponse.ok(response).handle(req, res)
                }
            }
        }

        req.queryParams("name")?.let { name ->
            val response = JsonObject()

            return when {
                Keywords.findNameExists(name) -> {
                    response.addProperty("exists", true)
                    CommonResponse.ok(response).handle(req, res)
                }
                else -> {
                    response.addProperty("exists", false)
                    CommonResponse.ok(response).handle(req, res)
                }
            }
        }

        return CommonResponse.badRequest("Parameters <id> or <name> missing").handle(req, res)
    }
}
