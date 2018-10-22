package com.dymesolutions.linkedevents.controllers

import com.dymesolutions.common.plugins.PluginLoader
import com.dymesolutions.common.plugins.PluginType
import com.dymesolutions.common.plugins.UploadFile
import com.dymesolutions.common.responses.CommonResponse
import com.dymesolutions.common.utils.UserUtil
import com.dymesolutions.linkedevents.dao.Images
import com.dymesolutions.linkedevents.dao.Organizations
import com.dymesolutions.linkedevents.dao.Users
import com.dymesolutions.linkedevents.extensions.JsonObjectExtension.addJsonLD
import com.dymesolutions.linkedevents.serializers.ImageSerializer
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import spark.Request
import spark.Response
import javax.servlet.MultipartConfigElement

class ImageController {
    companion object {
        val jsonParser = JsonParser()
        val uploadPlugin = PluginLoader.getPlugin(PluginType.IMAGE_UPLOAD)

        private const val location = "/tmp"
        private const val maxFileSize: Long = 128000000
        private const val maxRequestSize: Long = 128000000
        private const val fileSizeThreshold = 1024
    }


    fun uploadImage(req: Request, res: Response): Any {
        if (req.contentType().contains("multipart/form-data")) {
            val multipartConfigElement = MultipartConfigElement(location, maxFileSize, maxRequestSize, fileSizeThreshold)

            // Need to configure multipart for Jetty
            req.raw().setAttribute("org.eclipse.jetty.multipartConfig", multipartConfigElement)

            val allowedContentTypes = setOf(
                "image/jpeg",
                "image/jpg",
                "image/png"
            )

            req.raw().parts.forEach { part ->
                when (part.name) {
                    "image-file" -> {
                        // Process the file part
                        if (allowedContentTypes.contains(part.contentType)) {
                            val fileName = part.submittedFileName

                            // Use the upload plugin to handle the upload
                            uploadPlugin?.let { plugin ->

                                return if (plugin.configured) {

                                    // Upload plugin takes UploadFile as input and returns a PluginResponse with 'data'
                                    // object, in this case the uploaded image url.

                                    plugin.input(UploadFile(
                                        name = fileName,
                                        contentType = part.contentType,
                                        inputStream = part.inputStream,
                                        size = part.size
                                    ))?.data?.let { imageUrl ->
                                        val response = JsonObject()

                                        response.addProperty("image_url", imageUrl)

                                        return CommonResponse.okCreated(response).handle(req, res)
                                    }

                                    CommonResponse.notImplemented("Upload plugin not configured").handle(req, res)
                                } else {
                                    CommonResponse.notImplemented("Upload plugin not configured").handle(req, res)
                                }
                            }
                            return CommonResponse.badRequest("Image upload plugin has not been configured").handle(req, res)

                        } else {
                            return CommonResponse
                                .badRequest("Content type ${part.contentType} is not allowed.").handle(req, res)
                        }
                    }
                    else -> {
                        // Do nothing
                    }
                }
            }
            return CommonResponse.badRequest("No file").handle(req, res)
        } else {
            return CommonResponse.badRequest("Request is not a file").handle(req, res)
        }
    }

    fun getAll(req: Request, res: Response): Any {
        return CommonResponse.ok().handle(req, res)
    }

    fun add(req: Request, res: Response): Any {
        val requestBodyJson = jsonParser.parse(req.body()) as JsonObject

        val profile = UserUtil.getUserProfile(req, res)

        profile.get().let { userProfile ->
            userProfile.getAttribute("userId")?.let { profileUserId ->
                Users.findById(profileUserId as Int)?.let { user ->

                    val organization = Organizations.findByUserId(user.id)

                    Images.add(ImageSerializer.fromJson(requestBodyJson, user, organization))?.let { imageId ->
                        val response = JsonObject()

                        response.addJsonLD("image", imageId, "Image", true)

                        return CommonResponse.ok(response).handle(req, res)
                    }

                    return CommonResponse.badRequest("Image can't be saved").handle(req, res)
                }
            }
        }

        return CommonResponse.unauthenticated().handle(req, res)
    }
}
