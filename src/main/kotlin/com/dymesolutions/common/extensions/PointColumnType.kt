package com.dymesolutions.common.extensions

import org.jetbrains.exposed.sql.ColumnType
import org.postgis.PGgeometry
import org.postgis.Point

class PointColumnType(val srid: Int = 3067) : ColumnType() {
    override fun sqlType(): String = "GEOMETRY(Point, $srid)"

    override fun valueFromDB(value: Any): Any = if (value is PGgeometry) value.geometry else value

    override fun notNullValueToDB(value: Any): Any {
        if (value is Point) {
            if (value.srid == Point.UNKNOWN_SRID) value.srid = srid
            return PGgeometry(value)
        }
        return value
    }
}

