package com.dymesolutions.linkedevents.providers

import com.dymesolutions.linkedevents.models.SocialApp
import com.github.kittinunf.fuel.core.Request
import com.github.kittinunf.fuel.httpGet
import com.github.kittinunf.fuel.httpPost
import com.github.kittinunf.result.Result
import com.google.gson.JsonParser

class GoogleProvider {

    val code: String

    companion object {
        val tokenUrl = "https://accounts.google.com/o/oauth2/token"
        val profileUrl = "https://www.googleapis.com/oauth2/v1/userinfo"
        val jsonParser = JsonParser()
    }

    constructor(code: String) {
        this.code = code
    }

    fun getAccessToken(app: SocialApp): Request {
        return "$tokenUrl".httpPost(getTokenParameters(code, app))
    }

    private fun getUserProfile(accessToken: String): Request {
        return profileUrl
            .httpGet(getProfileParameters(accessToken))
            .responseString { _, _, result ->
                when (result) {
                    is Result.Failure -> {
                        val ex = result.getException()

                        ex.printStackTrace()
                    }

                    is Result.Success -> {
                        val data = jsonParser.parse(result.get()).asJsonObject
                    }
                }
            }
    }

    private fun getTokenParameters(code: String, app: SocialApp): List<Pair<String, String>> {
        return listOf(
            Pair("code", code),
            Pair("client_id", app.clientId),
            Pair("client_secret", app.secret),
            Pair("redirect_uri", "http://127.0.0.1:8080/api/v2/auth/google/callback/"),
            Pair("grant_type", "authorization_code")
        )
    }

    private fun getProfileParameters(accessToken: String): List<Pair<String, String>> {
        return listOf(
            Pair("access_token", accessToken),
            Pair("alt", "json")
        )
    }
}
