package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class Keyword(
    val id: String,
    val name: MultiLangValue,
    val createdTime: DateTime?,
    val lastModifiedTime: DateTime?,
    val aggregate: Boolean,
    val deprecated: Boolean,
    val nEvents: Int,
    val dataSource: String,
    val image: Int?,
    val publisher: String?
)

data class KeywordSave(
    val id: String,
    val name: MultiLangValue,
    val originId: String?,
    val createdTime: DateTime?,
    val lastModifiedTime: DateTime?,
    val aggregate: Boolean,
    val createdById: Int?,
    val dataSourceId: String,
    val lastModifiedById: Int?,
    val imageId: Int?,
    val deprecated: Boolean,
    val nEvents: Int,
    val nEventsChanged: Boolean,
    val publisherId: String?
)
