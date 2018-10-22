package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class Image(
    val id: Int,
    val createdTime: DateTime,
    val lastModifiedTime: DateTime,
    val image: String?,
    val url: String?,
    val cropping: String,
    val createdById: Int?,
    val lastModifiedById: Int?,
    val publisherId: String,
    val name: String,
    val licenseId: String,
    val photographerName: String?,
    val dataSourceId: String?
)

data class ImageSave(
    val createdTime: DateTime,
    val lastModifiedTime: DateTime,
    val image: String?,
    val url: String?,
    val cropping: String,
    val createdById: Int,
    val lastModifiedById: Int,
    val publisherId: String,
    val name: String,
    val licenseId: String,
    val photographerName: String?,
    val dataSourceId: String?
)
