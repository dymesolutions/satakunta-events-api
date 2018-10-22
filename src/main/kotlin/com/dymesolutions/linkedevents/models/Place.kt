package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime
import org.postgis.Point

data class Place(
    val id: String,
    val name: MultiLangValue,
    val telephone: MultiLangValue,
    val infoUrl: MultiLangValue,
    val description: MultiLangValue,

    val streetAddress: MultiLangValue,
    val addressRegion: String?,
    val postalCode: String?,
    val postOfficeBoxNum: String?,
    val addressCountry: String?,
    val addressLocality: MultiLangValue,

    val divisions: ArrayList<String>,
    val customData: String?,

    val createdTime: DateTime?,
    val lastModifiedTime: DateTime?,
    val email: String?,
    val contactType: String?,

    val deleted: Boolean,
    val nEvents: Int,
    val dataSource: String?,
    val image: String?,
    val publisher: String,
    val parent: Place?,
    val replacedBy: Place?,
    val position: Point?
) : LinkedEvent()

data class PlaceSave(
    val id: String,
    val name: MultiLangValue,
    val originId: String,
    val telephone: MultiLangValue,
    val infoUrl: MultiLangValue,
    val description: MultiLangValue,

    val streetAddress: MultiLangValue,
    val addressRegion: String?,
    val postalCode: String?,
    val postOfficeBoxNum: String?,
    val addressCountry: String?,
    val addressLocality: MultiLangValue,

    val divisions: ArrayList<String>,
    val customData: String?,

    val lastModifiedTime: DateTime?,
    val email: String?,
    val contactType: String?,

    val deleted: Boolean,
    val nEvents: Int,
    val dataSource: String?,
    val image: String?,
    val publisher: String,
    val parent: Place?,
    val replacedBy: Place?,
    val position: Point?
)
