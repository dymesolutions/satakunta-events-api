package com.dymesolutions.linkedevents

import com.dymesolutions.common.adapters.HttpAuthAdapter
import com.dymesolutions.linkedevents.dao.SocialApps
import com.dymesolutions.linkedevents.dao.Users
import org.pac4j.core.authorization.authorizer.RequireAnyRoleAuthorizer
import org.pac4j.core.client.Clients
import org.pac4j.core.config.Config
import org.pac4j.core.config.ConfigFactory
import org.pac4j.core.context.HttpConstants
import org.pac4j.core.credentials.TokenCredentials
import org.pac4j.core.matching.HttpMethodMatcher
import org.pac4j.core.profile.CommonProfile
import org.pac4j.core.util.CommonHelper
import org.pac4j.http.client.direct.HeaderClient
import org.pac4j.oauth.client.Google2Client

/**
 * Config factory for pac4j authentication and authorization.
 */
class AuthConfigFactory : ConfigFactory {

    override fun build(vararg args: Any): Config? {
        val config = Config(setupClients())

        config.addAuthorizer("superUser", RequireAnyRoleAuthorizer<CommonProfile>("SUPER_USER"))
        config.addAuthorizer("manager", RequireAnyRoleAuthorizer<CommonProfile>("SUPER_USER", "MANAGER"))
        config.addAuthorizer("basic", RequireAnyRoleAuthorizer<CommonProfile>("SUPER_USER", "MANAGER", "BASIC"))
        config.httpActionAdapter = HttpAuthAdapter()

        val stateAlteringMethodsMatcher = HttpMethodMatcher()
        val optionsMatcher = HttpMethodMatcher()

        stateAlteringMethodsMatcher.methods = setOf(
            HttpConstants.HTTP_METHOD.POST,
            HttpConstants.HTTP_METHOD.DELETE,
            HttpConstants.HTTP_METHOD.PUT
        )

        // Exclude OPTIONS from filtered methods to allow preflight calls
        optionsMatcher.methods = setOf(
            HttpConstants.HTTP_METHOD.GET,
            HttpConstants.HTTP_METHOD.POST,
            HttpConstants.HTTP_METHOD.DELETE,
            HttpConstants.HTTP_METHOD.PUT
        )

        config.addMatcher("allMethods", optionsMatcher)
        config.addMatcher("stateAlteringMethods", stateAlteringMethodsMatcher)

        return config
    }

    private fun setupClients(): Clients {
        val clients = Clients()

        // Auth token client
        val headerClient = HeaderClient("Authorization", "Token ", { credentials, _ ->
            val token = (credentials as TokenCredentials).token

            if (CommonHelper.isNotBlank(token)) {
                Users.findByToken(token)?.let { user ->
                    when {
                        user.isActive -> {
                            val profile = CommonProfile()
                            profile.setId(token)
                            profile.addAttribute("userId", user.id)

                            if(user.isSuperUser) {
                                profile.addRole("SUPER_USER")
                            }

                            if(user.isStaff) {
                                profile.addRole("MANAGER")
                            }

                            if(!user.isSuperUser && !user.isStaff) {
                                profile.addRole("BASIC")
                            }

                            credentials.setUserProfile(profile)
                        }
                    }
                }
            }
        })

        // Find social apps

        // Google client
        SocialApps.findByProvider("google")?.let {
            val googleClient = Google2Client(
                it.clientId,
                it.secret
            )

            googleClient.callbackUrl = "/api/v2/auth/google/callback/"
        }

        clients.setClients(headerClient)

        return clients
    }

    private fun addUserRoles() {

    }
}
