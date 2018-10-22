package com.dymesolutions.common.utils

import java.security.SecureRandom

object TokenUtil {

    private const val hex = "0123456789abcdef"

    private fun byteToHex(bytes: ByteArray): String {

        val hexBuilder = StringBuilder(2 * bytes.size)

        for (b in bytes) {
            hexBuilder
                .append(hex[((b.toInt() and 0xF0) shr 4)])
                .append(hex[(b.toInt() and 0x0F)])
        }

        return hexBuilder.toString()
    }

    /**
     * Generates a random hex string
     */
    fun generate(byteCount: Int = 20): String {
        val randomBytes = ByteArray(byteCount)
        SecureRandom().nextBytes(randomBytes)

        return byteToHex(randomBytes)
    }
}
