package com.dymesolutions.common.utils

import java.net.URLEncoder

object ParameterBuilder {

    /**
     * Build parameter string that can be appended to get request
     */
    fun buildString(vararg params: Pair<String, String>): String {
        val paramStringBuilder = StringBuilder()

        params.forEach {
            paramStringBuilder
                .append(URLEncoder.encode(it.first, "UTF-8"))
                .append("=")
                .append(URLEncoder.encode(it.second, "UTF-8"))
                .append("&")
        }

        return if (!params.isEmpty()) {
            paramStringBuilder.toString()
        } else {
            ""
        }
    }
}
