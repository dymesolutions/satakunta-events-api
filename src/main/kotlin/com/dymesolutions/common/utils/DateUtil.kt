package com.dymesolutions.common.utils

import org.joda.time.format.DateTimeFormat
import org.joda.time.format.DateTimeFormatterBuilder

object DateUtil {
    val jsonDateFormat = DateTimeFormat.forPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    val onlyDateFormat = DateTimeFormat.forPattern("yyyy-MM-dd")
    val sqlDateTimeFormat = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss")
    val formats =  arrayOf(onlyDateFormat.parser, jsonDateFormat.parser)
    val formatter = DateTimeFormatterBuilder().append(null, formats).toFormatter()
}
