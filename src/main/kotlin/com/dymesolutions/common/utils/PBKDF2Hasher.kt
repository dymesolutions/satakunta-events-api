package com.dymesolutions.common.utils

import java.util.*
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.PBEKeySpec

data class PasswordComponents(
    val algorithm: String,
    val iterations: Int,
    val salt: String,
    val password: String
)

object PBKDF2Hasher {

    private const val algorithm = "PBKDF2WithHmacSHA256"
    private const val allowedCharsInSalt = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    /**
     * Takes a password in ByteArray (created by the hash() function) and returns it as Base64 encoded String
     */
    private fun encodePasswordToString(password: ByteArray) = String(Base64.getEncoder().encode(password))

    /**
     * Creates a hash of a password with given salt and iterations
     */
    private fun hash(password: String, salt: String, iterations: Int): ByteArray {
        val secretKeyFactory = SecretKeyFactory.getInstance(algorithm)
        val keySpec = PBEKeySpec(password.toCharArray(), salt.toByteArray(), iterations, 256)
        return secretKeyFactory
            .generateSecret(keySpec)
            .encoded
    }

    /**
     * Verifies that a clear text password matches with the hashed password
     */
    fun verify(password: String, hashedPassword: String): Boolean {
        val passwordComponentsArray = hashedPassword.split("$")
        val passwordComponents = PasswordComponents(
            algorithm = passwordComponentsArray[0],
            iterations = passwordComponentsArray[1].toInt(),
            salt = passwordComponentsArray[2],
            password = passwordComponentsArray[3]
        )

        val hashPass = encodePasswordToString(hash(password, passwordComponents.salt, passwordComponents.iterations))

        return hashPass == passwordComponents.password
    }

    /**
     * Generates hash with salt and algorithm included in the String. Ready for saving to database
     */
    fun generatePasswordHash(clearTextPassword: String): String {
        val iterations = 36000
        val salt = RandomUtil.generateRandomString(12)
        val encodedPassword = encodePasswordToString(hash(clearTextPassword, salt, iterations))

        val passwordBuilder = StringBuilder()

        // Password with algorithm, salt and hash together, separated by $
        passwordBuilder
            .append("pbkdf2_sha256\$")
            .append("$iterations\$")
            .append("$salt\$")
            .append(encodedPassword)

        return passwordBuilder.toString()
    }
}
