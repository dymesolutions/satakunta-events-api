package com.dymesolutions.common.plugins

import java.io.InputStream

data class UploadFile(
    val name: String,
    val contentType: String,
    val inputStream: InputStream,
    val size: Long
)
