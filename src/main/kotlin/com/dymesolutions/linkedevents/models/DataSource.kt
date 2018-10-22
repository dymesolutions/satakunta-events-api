package com.dymesolutions.linkedevents.models

data class DataSource(
    val id: String,
    val name: String,
    val apiKey: String,
    val ownerId: String?,
    val userEditable: Boolean
)

data class DataSourceSave(
    val id: String,
    val name: String,
    val apiKey: String,
    val ownerId: String?,
    val userEditable: Boolean
)
