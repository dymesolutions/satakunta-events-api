package com.dymesolutions.common.plugins

import com.amazonaws.regions.Regions
import com.amazonaws.services.s3.AmazonS3
import com.amazonaws.services.s3.AmazonS3ClientBuilder
import com.amazonaws.services.s3.model.CannedAccessControlList
import com.amazonaws.services.s3.model.ObjectMetadata
import com.amazonaws.services.s3.model.PutObjectRequest
import com.dymesolutions.common.utils.RandomUtil

/**
 * Plugin is configured in /src/main/resources/plugins/aws-s3.json
 */
class AWSS3Plugin : Plugin {

    override val type = PluginType.IMAGE_UPLOAD
    override var configured = false

    companion object {
        private lateinit var s3: AmazonS3
        private lateinit var bucketName: String
    }

    override fun setup(configuration: PluginConfiguration) {

        // Set Region
        configuration.properties?.get("region")?.let { regionProp ->

            val region = when (regionProp.asString) {
                "eu-west-1" -> Regions.EU_WEST_1
                "eu-central-1" -> Regions.EU_CENTRAL_1
                else -> Regions.EU_WEST_1
            }

            s3 = AmazonS3ClientBuilder
                .standard()
                .withRegion(Regions.EU_WEST_1)
                .build()
        }

        // Set Bucket name
        configuration.properties?.get("bucketName")?.let { bName ->
            if (s3.doesBucketExistV2(bName.asString)) {
                bucketName = bName.asString
                configured = true
            } else {
                configured = false
            }
        }
    }

    /**
     * @return Uploaded file URL as String or null
     */
    override fun input(values: Any): PluginResponse? {
        return if (values is UploadFile) {
            return if (configured) {
                PluginResponse(
                    data = upload(values)
                )
            } else {
                null
            }
        } else {
            null
        }
    }

    override fun output() {

    }

    private fun upload(uploadFile: UploadFile): String? {
        // Add random string to filename to avoid duplicate names (like image.png) and replace all spaces with hyphens
        val randomString = RandomUtil.generateRandomString(8)
        val fileName = uploadFile.name.replace(" ", "-")
        val objectKey = "$randomString-$fileName"
        val objectMetadata = ObjectMetadata()

        objectMetadata.contentType = uploadFile.contentType
        objectMetadata.contentLength = uploadFile.size

        val putRequest = PutObjectRequest(bucketName, objectKey, uploadFile.inputStream, objectMetadata)
            .withCannedAcl(CannedAccessControlList.PublicRead)


        val result = s3.putObject(putRequest)

        uploadFile.inputStream.close()

        result?.let {
            return s3.getUrl(bucketName, objectKey).toString()
        }

        return null
    }
}
