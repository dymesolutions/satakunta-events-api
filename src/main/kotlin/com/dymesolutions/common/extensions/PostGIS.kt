package com.dymesolutions.common.extensions

import org.jetbrains.exposed.sql.Column
import org.jetbrains.exposed.sql.Table
import org.postgis.Point

object PostGIS {
    fun Table.point(name: String, srid: Int = 3067): Column<Point> = registerColumn(name, PointColumnType())
}
