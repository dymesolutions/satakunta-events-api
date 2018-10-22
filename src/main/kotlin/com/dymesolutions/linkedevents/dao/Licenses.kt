package com.dymesolutions.linkedevents.dao

import org.jetbrains.exposed.sql.Table

object Licenses: Table("events_license") {
    val id = varchar("id", 50).primaryKey()
    val name = varchar("name", 255)
    val nameFi = varchar("name_fi", 255).nullable()
    val nameSv = varchar("name_sv", 255).nullable()
    val nameEn = varchar("name_en", 255).nullable()
    val url = varchar("url", 200)
}

