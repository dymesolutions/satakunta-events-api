package com.dymesolutions.common.utils

import java.security.SecureRandom

object RandomUtil {
    private const val allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    fun generateRandomString(length: Int = 20): String {
        val buffer = StringBuilder(length)

        for (i in 0 until length - 1) {
            val index = SecureRandom().nextInt(allowedChars.length - 1)
            buffer.append(allowedChars[index])
        }

        return buffer.toString()
    }
}
