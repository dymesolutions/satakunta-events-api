package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.common.utils.PBKDF2Hasher
import com.dymesolutions.common.utils.RandomUtil
import com.dymesolutions.common.utils.TokenUtil
import com.dymesolutions.common.utils.UserUtil
import com.dymesolutions.common.validators.Validator
import com.dymesolutions.linkedevents.common.utils.MailUtil
import com.dymesolutions.linkedevents.dao.*
import com.dymesolutions.linkedevents.models.Token
import com.dymesolutions.linkedevents.models.UserSave
import com.dymesolutions.common.utils.JsonBuilders
import com.dymesolutions.linkedevents.models.UserPasswordReset
import com.dymesolutions.linkedevents.models.UserPasswordResetSave
import com.google.gson.JsonObject
import org.joda.time.DateTime
import org.slf4j.LoggerFactory
import spark.Request
import spark.Response

/**
 * Basic login functionality
 */
class LoginController {

    companion object {
        private val log = LoggerFactory.getLogger(LoginController::class.java)
    }

    fun login(req: Request, res: Response): Any {
        return JsonRequestHandler.handle(req, res) { request, response, requestBodyJson ->
            logMeIn(request, response, requestBodyJson)
        }
    }

    fun logout(req: Request, res: Response): Any {
        val profile = UserUtil.getUserProfile(req, res)
        profile.get().let { userProfile ->
            userProfile.getAttribute("userId")?.let { userId ->
                Tokens.deleteByUserID(userId as Int)
            }
        }

        return CommonResponse.ok().handle(req, res)
    }

    fun register(req: Request, res: Response): Any {
        return JsonRequestHandler.handle(req, res) { request, response, requestBodyJson ->
            registerNewUser(request, response, requestBodyJson)
        }
    }

    fun verifyEmail(req: Request, res: Response): Any {
        JsonBuilders.parseToObject(req.body())?.let { requestBodyJson ->
            requestBodyJson.get("key")?.let {
                val key = it.asString

                // Verify e-mail and set the user active

                EmailAddresses.findByConfirmationKey(key)?.let { emailAddress ->
                    EmailAddresses.verifyById(emailAddress.id)
                    Users.setActive(emailAddress.userId, true)
                    // Remove the confirmation so the link can't be used again to activate the user
                    EmailConfirmations.delete(emailAddress.id)
                    return CommonResponse.ok().handle(req, res)
                }

                return CommonResponse.notFound("User not found").handle(req, res)
            }

            return CommonResponse.badRequest("Property <key> missing from request").handle(req, res)
        }

        return CommonResponse.badRequest("No request body or request body not JSON").handle(req, res)
    }

    /**
     * Verifies that reset key is found and is not expired
     */
    fun verifyResetKey(req: Request, res: Response): Any {
        JsonBuilders.parseToObject(req.body())?.let { requestBodyJson ->

            requestBodyJson.get("reset_key")?.let { resetKey ->
                UserPasswordResets.findByResetKey(resetKey.asString)?.let { userPasswordReset ->
                    return when {
                        !userPasswordReset.dateExpires.isBeforeNow -> CommonResponse.ok().handle(req, res)

                        else -> CommonResponse.badRequest("Reset key expired").handle(req, res)
                    }

                }
                return CommonResponse.notFound("Reset key not found").handle(req, res)
            }

            return CommonResponse.badRequest("Property <reset_key> missing").handle(req, res)
        }

        return CommonResponse.badRequest("No request body or request body not JSON").handle(req, res)
    }

    fun resetPassword(req: Request, res: Response): Any {
        JsonBuilders.parseToObject(req.body())?.let { requestBodyJson ->
            requestBodyJson.get("email")?.let { email ->

                Users.findByEmail(email.asString)?.let { user ->

                    val userPasswordReset = UserPasswordResetSave(
                        userId = user.id,
                        resetKey = RandomUtil.generateRandomString(64),
                        dateExpires = DateTime.now().plusHours(1)
                    )

                    UserPasswordResets.add(userPasswordReset)

                    MailUtil.sendPasswordResetEmail(userPasswordReset.resetKey, email.asString)

                    return CommonResponse.ok().handle(req, res)
                }

                return CommonResponse.notFound("User not found").handle(req, res)
            }

            return CommonResponse.badRequest("Property <email> missing from request").handle(req, res)
        }

        return CommonResponse.badRequest("No request body or request body not JSON").handle(req, res)
    }

    fun changePasswordWithResetKey(req: Request, res: Response): Any {
        JsonBuilders.parseToObject(req.body())?.let { requestBodyJson ->
            val password1 = requestBodyJson.get("password1")
            val password2 = requestBodyJson.get("password2")

            // First check if passwords match before doing any DB operations
            when {
                password1.asString.isBlank() ->
                    return CommonResponse.badRequest("Password is blank").handle(req, res)
                password1.asString != password2.asString ->
                    return CommonResponse.badRequest("Passwords do not match").handle(req, res)
                password1.asString.length < 6 ->
                    return CommonResponse.badRequest("Password too short (min. 6 characters)").handle(req, res)
            }


            requestBodyJson.get("reset_key")?.let { resetKey ->
                UserPasswordResets.findByResetKey(resetKey.asString)?.let { userPasswordReset ->
                    return when {
                        !userPasswordReset.dateExpires.isBeforeNow -> {
                            // Not expired, change password -> delete reset key -> OK
                            Users.updatePassword(userId = userPasswordReset.userId, password = password1.asString)
                            UserPasswordResets.deleteByUserId(userPasswordReset.userId)
                            CommonResponse.ok().handle(req, res)
                        }
                        else -> {
                            // Reset key has expired, remove all user's reset keys and don't allow change
                            UserPasswordResets.deleteByUserId(userPasswordReset.userId)
                            CommonResponse.unauthorized("Reset key expired").handle(req, res)
                        }
                    }
                }

                return CommonResponse.unauthorized("Reset key not found").handle(req, res)
            }
        }

        return CommonResponse.badRequest("No request body or request body not JSON").handle(req, res)
    }

    /**
     * Find user, then verify their password matched the hash in the database,
     * find their token or generate new one and log them in.
     */
    private fun logMeIn(req: Request, res: Response, requestBodyJson: JsonObject): Any {
        if (requestBodyJson.get("username") == null || requestBodyJson.get("password") == null) {
            return CommonResponse.badRequest("No username or password given").handle(req, res)
        }

        val username = requestBodyJson.get("username").asString
        val password = requestBodyJson.get("password").asString

        Users.findByUsername(username)?.let {user ->
            when (PBKDF2Hasher.verify(password, user.password)) {
                true -> {
                    res.type("application/json")
                    val tokenResponseJson = JsonObject()

                    Tokens.findByUserId(user.id)?.let { key ->
                        tokenResponseJson.addProperty("key", key)

                        return tokenResponseJson
                    }

                    // Token is not found, create a new one, save it to database and return it to client

                    val tokenKey = TokenUtil.generate()

                    Tokens.add(Token(
                        key = tokenKey,
                        dateCreated = DateTime(),
                        userId = user.id
                    ))

                    // Update date on last login
                    Users.updateLastLogin(user.id)

                    tokenResponseJson.addProperty("key", tokenKey)

                    return tokenResponseJson
                }
                false -> {
                    return CommonResponse.unauthenticated().handle(req, res)
                }
            }
        }

        return CommonResponse.unauthenticated().handle(req, res)
    }

    /**
     * Validate request parameters, check if username/email exists and finally register user
     */
    private fun registerNewUser(req: Request, res: Response, requestBodyJson: JsonObject): Any {
        log.info(req.host() + req.uri())

        // val username = requestBodyJson.get("username")
        val email = requestBodyJson.get("email")
        val password = requestBodyJson.get("password1")
        val passwordAgain = requestBodyJson.get("password2")
        val firstName = requestBodyJson.get("first_name")
        val lastName = requestBodyJson.get("last_name")

        if (email == null) {
            return CommonResponse.badRequest("<email> property missing").handle(req, res)
        }

        if (password == null) {
            return CommonResponse.badRequest("<password> property missing").handle(req, res)
        }

        if (passwordAgain == null) {
            return CommonResponse.badRequest("<passwordAgain> property missing").handle(req, res)
        }

        // Check that username and email do not exist
        if (Users.findEmailExists(email.asString)) {
            return CommonResponse.badRequest("E-mail exists already").handle(req, res)
        }

        Validator.email(email.asString).let {
            if (!it.valid) {
                return CommonResponse.badRequest(it.message).handle(req, res)
            }
        }

        Validator.password(password.asString, passwordAgain.asString).let {
            if (!it.valid) {
                return CommonResponse.badRequest(it.message).handle(req, res)
            }
        }

        // Add new user to the organization "Others"

        Users.add(UserSave(
            username = email.asString,
            email = email.asString,
            password = password.asString,
            isSuperUser = false,
            isStaff = false,
            isActive = false,
            firstName = firstName?.asString,
            lastName = lastName?.asString
        ))?.let { userId ->
            OrganizationRegularUsers.add(
                userId = userId,
                organizationId = "system:others" // TODO make configurable
            )

            // Add e-mail address and send verification e-mail
            EmailAddresses.add(email.asString, userId)?.let { emailAddressId ->
                val key = RandomUtil.generateRandomString(32)
                EmailConfirmations.add(key, emailAddressId).let {
                    MailUtil.sendRegistrationConfirmation(email.asString, key)
                }
            }

            return CommonResponse.okCreated().handle(req, res)
        }

        return CommonResponse.badRequest("Can't save").handle(req, res)
    }
}
