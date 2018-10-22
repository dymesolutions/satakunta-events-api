package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.Image
import com.dymesolutions.linkedevents.models.ImageSave
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.select
import org.jetbrains.exposed.sql.transactions.transaction

object Images : Table("events_image") {
    val id = integer("id").primaryKey().autoIncrement()
    val createdTime = datetime("created_time")
    val lastModifiedTime = datetime("last_modified_time")
    val image = varchar("image", 100).nullable()
    val url = varchar("url", 400).nullable()
    val cropping = varchar("cropping", 255)
    val createdById = integer("created_by_id").nullable()
    val lastModifiedBy = integer("last_modified_by_id").nullable()
    val publisherId = varchar("publisher_id", 255) references Organizations.id
    val name = varchar("name", 255)
    val licenseId = varchar("license_id", 50) references Licenses.id
    val photographerName = varchar("photographer_name", 255).nullable()
    val dataSourceId = varchar("data_source_id", 100).nullable()

    fun add(image: ImageSave): Int? {
        return transaction {
            insert {
                it[createdTime] = image.createdTime
                it[lastModifiedTime] = image.lastModifiedTime
                it[Images.image] = image.image
                it[url] = image.url
                it[cropping] = image.cropping
                it[createdById] = image.createdById
                it[lastModifiedBy] = image.lastModifiedById
                it[publisherId] = image.publisherId
                it[name] = image.name
                it[licenseId] = image.licenseId
                it[photographerName] = image.photographerName
                it[dataSourceId] = image.dataSourceId
            }.generatedKey?.toInt()
        }
    }

    fun findById(id: Int): Image {
        return transaction {
            select {
                Images.id eq id
            }.map { image ->
                Image(
                    id = image[Images.id],
                    createdTime = image[createdTime],
                    lastModifiedTime = image[lastModifiedTime],
                    image = image[Images.image],
                    url = image[url],
                    cropping = image[cropping],
                    createdById = image[createdById],
                    lastModifiedById = image[lastModifiedBy],
                    publisherId = image[publisherId],
                    name = image[name],
                    licenseId = image[licenseId],
                    photographerName = image[photographerName],
                    dataSourceId = image[dataSourceId]
                )
            }.first()
        }
    }
}
