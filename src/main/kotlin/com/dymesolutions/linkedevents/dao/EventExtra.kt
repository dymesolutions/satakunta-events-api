package com.dymesolutions.linkedevents.dao

import org.jetbrains.exposed.sql.Table

/**
 * Extra fields for hobbies
 */
object EventExtra : Table("event_extra") {
    val id = integer("id").primaryKey().autoIncrement()
    val eventId = varchar("event_id", 50) references Events.id

}
