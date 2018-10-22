package com.dymesolutions.common.utils

import java.io.BufferedReader
import java.io.InputStream
import java.io.InputStreamReader

object Readers {
    fun readInputStream(inputStream: InputStream): String? {
        val resultStringBuilder = StringBuilder()
        try {
            val br = BufferedReader(InputStreamReader(inputStream))
            var line: String?

            line = br.readLine()

            while (line != null) {
                resultStringBuilder.append(line).append("\n")
                line = br.readLine()
            }

            return resultStringBuilder.toString()
        } catch (e: Exception) {

            e.printStackTrace()
        }

        return null
    }
}
