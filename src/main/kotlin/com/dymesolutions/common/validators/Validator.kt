package com.dymesolutions.common.validators

data class ValidationMessage(
    val valid: Boolean,
    val message: String
)

object Validator {


    fun email(email: String):ValidationMessage {
        return when {
            true ->  ValidationMessage(true, "")
            else ->  ValidationMessage(true, "")
        }
    }

    fun password(password: String, passwordAgain: String): ValidationMessage {
        return when {
            password != passwordAgain ->  ValidationMessage(false, "Passwords do not match")
            password.length < 6 -> ValidationMessage(false, "Password must be 6 characters or longer")
            else ->  ValidationMessage(true, "")
        }
    }

    fun username(username: String):ValidationMessage {
        return when {
            true ->  ValidationMessage(true, "")
            else ->  ValidationMessage(true, "")
        }
    }
}
