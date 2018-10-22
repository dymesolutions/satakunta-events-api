package com.dymesolutions.linkedevents.models

import org.joda.time.DateTime

data class Organization(
    val id: String,
    val originId: String,
    val name: String,
    val foundingDate: DateTime?,
    val dissolutionDate: DateTime?,
    val createdTime: DateTime,
    val lastModifiedTime: DateTime,
    val classificationId: String?,
    val createdById: Int?,
    val dataSourceId: String,
    val lastModifiedById: Int?,
    val parentId: String?,
    val replacedById: String?,
    val internalType: String
)

data class OrganizationSave(
    val originId: String,
    val name: String,
    val foundingDate: DateTime?,
    val dissolutionDate: DateTime?,
    val classificationId: String?,
    val createdById: Int?,
    val dataSourceId: String,
    val lastModifiedById: Int?,
    val parentId: String?,
    val replacedById: String?,
    val internalType: String
)
