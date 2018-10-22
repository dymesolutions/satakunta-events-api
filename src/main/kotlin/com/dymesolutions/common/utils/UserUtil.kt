package com.dymesolutions.common.utils

import org.pac4j.core.context.WebContext
import org.pac4j.core.profile.CommonProfile
import org.pac4j.core.profile.ProfileManager
import org.pac4j.sparkjava.SparkWebContext
import spark.Request
import spark.Response
import java.util.*

object UserUtil {
    fun getUserProfile(req: Request, res: Response): Optional<CommonProfile> {
        return ProfileManager<CommonProfile>(SparkWebContext(req, res) as WebContext).get(true)
    }
}
