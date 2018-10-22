package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class KeywordSet(
    val id: String,
    val name: MultiLangValue,
    val usage: Int,
    val origin: String?,
    val createdTime: DateTime?,
    val lastModifiedTime: DateTime?,
    val dataSourceId: String,
    val image: Int?,
    val organization: String?
)

data class KeywordSetSave(
    val name: MultiLangValue,
    val usage: Int,
    val origin: String?,
    val dataSourceId: String,
    val image: Int?,
    val organization: String?
)
