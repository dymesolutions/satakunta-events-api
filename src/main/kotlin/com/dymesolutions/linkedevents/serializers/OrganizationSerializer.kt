package com.dymesolutions.linkedevents.serializers

import com.dymesolutions.common.utils.DateUtil.jsonDateFormat
import com.dymesolutions.linkedevents.extensions.JsonObjectExtension.addJsonLD
import com.dymesolutions.linkedevents.models.Organization
import com.google.gson.JsonArray
import com.google.gson.JsonNull
import com.google.gson.JsonObject

object OrganizationSerializer {

    fun toJson(organization: Organization, includeFull: Boolean = false): JsonObject {
        val json = JsonObject()

        if (includeFull) {
            json.addJsonLD("organization", organization.id, "Organization")

            json.addProperty("id", organization.id)
            json.addProperty("data_source", organization.dataSourceId)
            json.add("classification", JsonNull.INSTANCE)
            json.addProperty("name", organization.name)
            json.addProperty("founding_date", organization.foundingDate?.toString(jsonDateFormat))
            json.addProperty("dissolution_date", organization.dissolutionDate?.toString(jsonDateFormat))
            json.add("parent_organization", JsonNull.INSTANCE)
            json.add("sub_organizations", JsonArray())
            json.add("affiliated_organizations", JsonArray())
            json.addProperty("created_time", organization.createdTime.toString(jsonDateFormat))
            json.addProperty("last_modified_time", organization.lastModifiedTime.toString(jsonDateFormat))
            json.addProperty("is_affiliated", false)
            json.add("replaced_by", JsonNull.INSTANCE)

        } else {
            json.addJsonLD("organization", organization.id, "Organization", true)
        }

        return json
    }

}
