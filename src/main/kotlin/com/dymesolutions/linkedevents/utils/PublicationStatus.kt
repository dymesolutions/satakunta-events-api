package com.dymesolutions.linkedevents.utils

object PublicationStatus {
    val values = hashMapOf<Int, String>(
        1 to "public",
        2 to "draft",
        3 to "ready"
    )

    val keys = hashMapOf<String, Int>(
        "public" to 1,
        "draft" to 2,
        "ready" to 3
    )
}
