package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.interfaces.Controller
import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.common.utils.JsonBuilders
import com.dymesolutions.linkedevents.dao.OrganizationRegularUsers
import com.dymesolutions.linkedevents.dao.Organizations
import com.dymesolutions.linkedevents.dao.Users
import com.dymesolutions.linkedevents.models.User
import com.dymesolutions.linkedevents.models.UserUpdate
import com.dymesolutions.linkedevents.serializers.OrganizationSerializer
import com.dymesolutions.linkedevents.serializers.UserSerializer
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.stream.MalformedJsonException
import org.pac4j.core.context.WebContext
import org.pac4j.core.profile.CommonProfile
import org.pac4j.core.profile.ProfileManager
import org.pac4j.sparkjava.SparkWebContext
import spark.Request
import spark.Response

class UserController : Controller {

    override fun getById(req: Request, res: Response, manager: Boolean): JsonObject {
        return JsonObject()
    }

    override fun getAll(req: Request, res: Response, manager: Boolean): JsonObject {
        return JsonObject()
    }

    override fun add(req: Request, res: Response) {

    }

    override fun update(req: Request, res: Response, manager: Boolean): Any {
        try {
            val requestJson = JsonBuilders.jsonParser.parse(req.body()).asJsonObject

            Users.findById(requestJson.get("id").asInt)?.let { user ->
                UserSerializer.fromJson(requestJson, user)?.let { userUpdate ->
                    // First update user details
                    Users.update(userUpdate)

                    val organizationIdFromReq = requestJson.get("organization").asJsonObject["id"].asString

                    // Then find what organization the user belongs to
                    Organizations.findByUserId(user.id)?.let { organization ->
                        when {
                            organization.id != organizationIdFromReq -> {
                                // Change organization and delete the old reference
                                OrganizationRegularUsers.add(user.id, organizationIdFromReq)
                                OrganizationRegularUsers.delete(user.id, organization.id)
                            }
                            else -> {
                                // Do nothing
                            }
                        }
                    }

                    return CommonResponse.okCreated().handle(req, res)
                }
            }

            return CommonResponse.badRequest("Property <id> is missing!").handle(req, res)
        } catch (e: MalformedJsonException) {
            return CommonResponse.badRequest("Malformed JSON").handle(req, res)
        }
    }


    override fun delete(req: Request, res: Response, manager: Boolean) {

    }

    fun getAll(req: Request, res: Response, manager: Boolean, admin: Boolean = false): Any {

        val text = req.queryParams("text")

        Users.findAll(text).let { users ->
            val response = JsonObject()

            val userArray = JsonArray()

            users.forEach { user ->
                userArray.add(UserSerializer.toJson(user, true))
            }

            response.add("data", userArray)

            return CommonResponse.ok(response).handle(req, res)
        }
    }

    /**
     * Returns the logged in user details
     */
    fun getLoggedInUser(req: Request, res: Response): Any {
        val context = SparkWebContext(req, res) as WebContext
        val profileManager = ProfileManager<CommonProfile>(context)
        val profile = profileManager.get(true)

        profile?.get()?.id?.let { userId ->
            Users.findByToken(userId)?.let { user ->

                val response = JsonObject()

                response.addProperty("id", user.id)
                response.addProperty("first_name", user.firstName)
                response.addProperty("last_name", user.lastName)
                response.addProperty("username", user.username)
                response.addProperty("email", user.email)
                response.addProperty("is_superuser", user.isSuperUser)
                response.addProperty("is_staff", user.isStaff)

                return CommonResponse.ok(response).handle(req, res)
            }
        }

        return CommonResponse.unauthenticated().handle(req, res)
    }

    /**
     * Use in UI to determine if user exists, accepts parameters username or email
     */
    fun getExists(req: Request, res: Response): Any {
        val usernameParam = req.queryParams("username")
        val emailParam = req.queryParams("email")

        usernameParam?.let {
            val response = JsonObject()
            response.addProperty("exists", Users.findUsernameExists(it))

            return CommonResponse.ok(response).handle(req, res)
        }

        emailParam?.let {
            req.queryParams("email")?.let {
                val response = JsonObject()
                response.addProperty("exists", Users.findEmailExists(it))

                return CommonResponse.ok(response).handle(req, res)
            }
        }

        return CommonResponse.badRequest("Parameter missing").handle(req, res)
    }
}
