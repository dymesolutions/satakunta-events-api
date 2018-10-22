package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.interfaces.Controller
import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.linkedevents.dao.Organizations
import com.dymesolutions.linkedevents.serializers.OrganizationSerializer
import com.dymesolutions.linkedevents.utils.MetaObject
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import spark.Request
import spark.Response

class OrganizationController : Controller {
    private val jsonParser = JsonParser()

    override fun getById(req: Request, res: Response, manager: Boolean): Any {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun getAll(req: Request, res: Response, manager: Boolean): Any {

        val pageSize = req.queryParams("page_size")?.toInt() ?: 30
        val page = req.queryParams("page")?.toInt() ?: 1

        Organizations.findAll(pageSize, page).let { organizations ->
            val data = JsonArray()

            organizations.forEach { organization ->
                data.add(OrganizationSerializer.toJson(organization, true))
            }

            return try {
                val meta = MetaObject.build(
                    Organizations.count(),
                    "organization",
                    pageSize,
                    page)

                val response = JsonObject()

                response.add("meta", meta)
                response.add("data", data)

                CommonResponse.ok(response).handle(req, res)
            } catch (e: Exception) {
                e.printStackTrace()
                return CommonResponse.badRequest("Parameters are not integers").handle(req, res)
            }
        }
    }

    override fun add(req: Request, res: Response): Any {
        val requestBodyJson = jsonParser.parse(req.body()) as JsonObject
        TODO("not implemented")
    }

    override fun update(req: Request, res: Response, manager: Boolean): Any {
        val requestBodyJson = jsonParser.parse(req.body()) as JsonObject
        TODO("not implemented")
    }

    override fun delete(req: Request, res: Response, manager: Boolean): Any {
        TODO("not implemented")
    }
}
