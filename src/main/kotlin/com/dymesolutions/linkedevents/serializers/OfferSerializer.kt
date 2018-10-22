package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.linkedevents.models.MultiLangValue
import com.dymesolutions.linkedevents.models.Offer
import com.dymesolutions.linkedevents.models.OfferSave
import com.dymesolutions.common.utils.JsonBuilders
import com.google.gson.JsonObject

object OfferSerializer {

    fun fromJson(json: JsonObject, eventId: String): OfferSave {
        val description = json.get("description")?.let {
            if (!it.isJsonNull) {
                it.asJsonObject
            } else {
                null
            }
        }

        val infoUrl = json.get("info_url")?.let {
            if (!it.isJsonNull) {
                it.asJsonObject
            } else {
                null
            }
        }

        val price = json.get("price")?.let {
            if (!it.isJsonNull) {
                it.asJsonObject
            } else {
                null
            }
        }

        return OfferSave(
            price = MultiLangValue(
                fi = price?.get("fi")?.asString,
                sv = price?.get("sb")?.asString,
                en = price?.get("en")?.asString
            ),
            description = MultiLangValue(
                fi = description?.get("fi")?.asString,
                sv = description?.get("sv")?.asString,
                en = description?.get("en")?.asString
            ),
            infoUrl = MultiLangValue(
                fi = infoUrl?.get("fi")?.asString,
                sv = infoUrl?.get("sv")?.asString,
                en = infoUrl?.get("en")?.asString
            ),
            isFree = json.get("is_free").asBoolean,
            eventId = eventId
        )
    }

    fun toJson(offer: Offer): JsonObject {
        val json = JsonObject()

        json.addProperty("is_free", offer.isFree)
        json.add("description", JsonBuilders.toJsonTree(MultiLangValue(
            fi = offer.description.fi,
            sv = offer.description.sv,
            en = offer.description.en
        )))
        json.add("info_url", JsonBuilders.toJsonTree(MultiLangValue(
            fi = offer.infoUrl.fi,
            sv = offer.infoUrl.sv,
            en = offer.infoUrl.en
        )))
        json.add("price", JsonBuilders.toJsonTree(MultiLangValue(
            fi = offer.price.fi,
            sv = offer.price.sv,
            en = offer.price.en
        )))

        return json
    }
}
