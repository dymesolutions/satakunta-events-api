package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.interfaces.Controller
import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.linkedevents.dao.Places
import com.dymesolutions.linkedevents.serializers.PlaceSerializer
import com.dymesolutions.linkedevents.utils.MetaObject
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import spark.Request
import spark.Response

class PlaceController : Controller {

    override fun getById(req: Request, res: Response, manager: Boolean): JsonObject {
        return JsonObject()
    }

    override fun getAll(req: Request, res: Response, manager: Boolean): Any {
        val sort = req.queryParams("sort")
        val showAllPlaces = req.queryParams("show_all_places")
        val pageSize = req.queryParams("page_size")
        val page = req.queryParams("page")
        val dataSource = req.queryParams("data_source")
        val text = req.queryParams("text")

        Places.findAll(
            pageSize = pageSize?.toInt() ?: 10,
            page = page?.toInt() ?: 1,
            dataSourceId = dataSource,
            text = text).let { places ->

            val dataArray = JsonArray()

            places.forEach { place ->
                dataArray.add(PlaceSerializer.toJson(place, true))
            }

            val response = JsonObject()
            response.add("meta", MetaObject.build(
                Places.count(dataSourceId = dataSource, text = text),
                type = "place",
                pageSize = pageSize?.toInt() ?: 10,
                page = page?.toInt() ?: 1))
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
