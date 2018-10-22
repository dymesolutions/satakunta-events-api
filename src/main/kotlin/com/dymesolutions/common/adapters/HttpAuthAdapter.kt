package com.dymesolutions.common.adapters

import org.pac4j.core.context.HttpConstants
import org.pac4j.core.http.HttpActionAdapter
import org.pac4j.sparkjava.SparkWebContext
import spark.Spark

class HttpAuthAdapter : HttpActionAdapter<Any, SparkWebContext> {
	override fun adapt(code: Int, context: SparkWebContext): Any? {
		when (code) {
			HttpConstants.UNAUTHORIZED -> stop(HttpConstants.UNAUTHORIZED, "User was not authenticated")
			HttpConstants.FORBIDDEN -> stop(HttpConstants.FORBIDDEN, "User does not have necessary permissions")
			HttpConstants.OK -> stop(HttpConstants.OK, "Unauthorized")
			HttpConstants.TEMP_REDIRECT -> stop(HttpConstants.TEMP_REDIRECT, "Unauthorized")
		}

		return null
	}

	private fun stop(code: Int, body: String) {
		Spark.halt(code, body)
	}
}
