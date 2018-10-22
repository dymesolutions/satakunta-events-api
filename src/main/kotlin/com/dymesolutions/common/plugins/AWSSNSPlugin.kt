package com.dymesolutions.common.plugins

import com.amazonaws.regions.Regions
import com.amazonaws.services.sns.AmazonSNS
import com.amazonaws.services.sns.AmazonSNSClientBuilder
import com.amazonaws.services.sns.model.PublishRequest

/**
 * Plugin is configured in /src/main/resources/plugins/aws-sns.json
 */
class AWSSNSPlugin : Plugin {
    override val type = PluginType.NOTIFICATION_PUBLISH
    override var configured = false

    companion object {
        private lateinit var sns: AmazonSNS
        private lateinit var topicArn: String
    }

    override fun setup(configuration: PluginConfiguration) {
        // Set Region
        configuration.properties?.get("region")?.let { regionProp ->
            val region = when (regionProp.asString) {
                "eu-west-1" -> Regions.EU_WEST_1
                "eu-central-1" -> Regions.EU_CENTRAL_1
                else -> Regions.EU_WEST_1
            }

            sns = AmazonSNSClientBuilder
                .standard()
                .withRegion(region)
                .build()
        }

        configuration.properties?.get("topicArn")?.let { topicArn ->
            AWSSNSPlugin.topicArn = topicArn.asString
            configured = true
        }
    }

    override fun input(values: Any): PluginResponse? {
        return if(values is SubjectMessage) {
            return if (configured) {
                return PluginResponse(
                    data = publishToSNS(values)
                )
            } else {
                null
            }
        } else {
            null
        }
    }

    override fun output(): Any {
        TODO("not implemented")
    }

    private fun publishToSNS(subjectMessage: SubjectMessage): String {
        val request = PublishRequest(topicArn, subjectMessage.message, subjectMessage.subject)
        sns.publish(request)

        return "DONE"
    }
}
