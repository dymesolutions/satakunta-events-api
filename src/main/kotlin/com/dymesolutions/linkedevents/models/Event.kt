package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

/**
 * Data class for fetching
 */
data class Event(
    val id: String,

    val name: MultiLangValue,
    val originId: String?,

    val createdTime: DateTime?,
    val lastModifiedTime: DateTime?,
    val datePublished: DateTime?,
    val startTime: DateTime?,
    val endTime: DateTime?,

    val infoUrl: MultiLangValue?,
    val description: MultiLangValue,
    val shortDescription: MultiLangValue,

    val provider: MultiLangValue?,

    val providerName: String?,
    val providerEmail: String?,
    val providerPhone: String?,
    val providerLink: String?,
    val providerContactName: String?,
    val providerContactEmail: String?,
    val providerContactPhone: String?,

    val eventStatus: Int,
    val locationExtraInfo: MultiLangValue?,
    val createdById: Int?,
    val dataSourceId: String,
    val location: Place,
    val publisherId: String,
    val superEventId: String?,
    val customData: String?,
    val publicationStatus: Int,
    val imageId: Int?,
    val deleted: Boolean,

    val position: Position?
)

/**
 * Data class for saving
 */
data class EventSave(
    val name: MultiLangValue,
    val originId: String?,
    val createdTime: DateTime?,
    val lastModifiedTime: DateTime?,
    val datePublished: DateTime?,
    val startTime: DateTime?,
    val endTime: DateTime?,

    val infoUrl: MultiLangValue?,
    val description: MultiLangValue,
    val shortDescription: MultiLangValue,

    val provider: MultiLangValue?,

    val providerName: String?,
    val providerEmail: String?,
    val providerPhone: String?,
    val providerLink: String?,
    val providerContactName: String?,
    val providerContactEmail: String?,
    val providerContactPhone: String?,

    val eventStatus: String,
    val locationExtraInfo: MultiLangValue?,
    val createdById: Int?,
    val lastModifiedById: Int?,
    val dataSourceId: String,
    val locationId: String,
    val publisherId: String,
    val superEventId: String?,
    val customData: String?,
    val publicationStatus: Int?,
    val imageId: Int?,
    val position: Position?
)
