package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.linkedevents.dao.SocialApps
import com.dymesolutions.linkedevents.dao.SocialTokens
import com.dymesolutions.linkedevents.dao.Users
import com.dymesolutions.linkedevents.models.SocialApp
import com.dymesolutions.linkedevents.models.SocialToken
import com.dymesolutions.linkedevents.providers.GoogleProvider
import com.github.kittinunf.fuel.httpGet
import com.github.kittinunf.result.Result
import com.google.gson.Gson
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.joda.time.DateTime
import spark.Request
import spark.Response

data class UserProfile(
    val email: String,
    val firstName: String,
    val lastName: String
)

class SocialAppController {

    companion object {
        val jsonParser = JsonParser()
    }

    fun loginWithFacebook(req: Request, res: Response) {

    }

    fun loginWithGoogle(req: Request, res: Response): Any {
        val tokenUrl = "https://accounts.google.com/o/oauth2/token"

        val code = req.queryParams("code")

        SocialApps.findByProvider("google")?.let {
            val gProvider = GoogleProvider(code)
            val app = it

            gProvider.getAccessToken(app).let {
                it.responseString { _, _, result ->
                    when (result) {
                        is Result.Failure -> {
                            val ex = result.getException()

                            ex.printStackTrace()
                        }

                        is Result.Success -> {
                            val data = jsonParser.parse(result.get()).asJsonObject
                            getUserProfile(data.get("access_token").asString)

                            // return@responseString
                        }
                    }
                }
            }
        }

        return "OK"
    }

    private fun getUserProfile(accessToken: String) {
        val profileUrl = "https://www.googleapis.com/oauth2/v1/userinfo"

        val params = listOf(
            Pair("access_token", accessToken),
            Pair("alt", "json")
        )

        profileUrl.httpGet(params).responseString { _, _, result ->
            when (result) {
                is Result.Failure -> {
                    val ex = result.getException()

                    ex.printStackTrace()
                }

                is Result.Success -> {
                    val data = jsonParser.parse(result.get()).asJsonObject

                    Users.findByEmail(data.get("email").asString)?.let {

                    }
                }
            }
        }
    }

    private fun saveToken(data: JsonObject, socialApp: SocialApp) {
        SocialTokens.add(SocialToken(
            tokenSecret = "",
            token = data.get("access_token").asString,
            dateExpires = DateTime().plusSeconds(data.get("expires_in").asInt),
            accountId = 0,
            appId = socialApp.id
        ))
    }
}
