package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.common.utils.DateUtil.jsonDateFormat
import com.dymesolutions.linkedevents.extensions.JsonObjectExtension.addJsonLD
import com.dymesolutions.linkedevents.models.MultiLangValue
import com.dymesolutions.linkedevents.models.Place
import com.dymesolutions.common.utils.JsonBuilders.gson
import com.google.gson.JsonArray
import com.google.gson.JsonObject

object PlaceSerializer {
    fun fromJson(json: JsonObject): Place {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    fun toJson(place: Place, includeFull: Boolean = false): JsonObject {
        val json = JsonObject()

        if (includeFull) {
            json.addJsonLD("place", place.id, "Place")

            json.addProperty("id", place.id)
            json.add("divisions", JsonArray())
            json.addProperty("custom_data", place.customData)
            json.addProperty("created_time", place.createdTime?.toString(jsonDateFormat))
            json.addProperty("last_modified_time", place.lastModifiedTime?.toString(jsonDateFormat))
            json.addProperty("email", place.email)
            json.addProperty("contact_type", place.contactType)
            json.addProperty("address_region", place.addressRegion)
            json.addProperty("postal_code", place.postalCode)
            json.addProperty("post_office_box_num", place.postOfficeBoxNum)
            json.addProperty("address_country", place.addressCountry)
            json.addProperty("deleted", place.deleted)
            json.addProperty("n_events", place.nEvents)
            json.addProperty("data_source", place.dataSource)
            json.addProperty("image", place.image)
            json.addProperty("publisher", place.publisher)
            json.add("parent", gson.toJsonTree(place.parent))
            json.add("replaced_by", gson.toJsonTree(place.replacedBy))
            json.add("position", gson.toJsonTree(place.position))
            json.add("street_address", gson.toJsonTree(MultiLangValue(
                fi = place.streetAddress.fi,
                sv = place.streetAddress.sv,
                en = place.streetAddress.en
            )))
            json.add("telephone", gson.toJsonTree(MultiLangValue(
                fi = place.telephone.fi,
                sv = place.telephone.sv,
                en = place.telephone.en
            )))
            json.add("address_locality", gson.toJsonTree(MultiLangValue(
                fi = place.addressLocality.fi,
                sv = place.addressLocality.sv,
                en = place.addressLocality.en
            )))
            json.add("description", gson.toJsonTree(MultiLangValue(
                fi = place.description.fi,
                sv = place.description.sv,
                en = place.description.en
            )))
            json.add("name", gson.toJsonTree(MultiLangValue(
                fi = place.name.fi,
                sv = place.name.sv,
                en = place.name.en
            )))
            json.add("info_url", gson.toJsonTree(MultiLangValue(
                fi = place.infoUrl.fi,
                sv = place.infoUrl.sv,
                en = place.infoUrl.en
            )))
        } else {
            json.addJsonLD("place", place.id, "Place", true)
        }

        return json
    }
}
