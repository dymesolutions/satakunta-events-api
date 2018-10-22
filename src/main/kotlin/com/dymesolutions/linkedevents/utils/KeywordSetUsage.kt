package com.dymesolutions.linkedevents.utils

object KeywordSetUsage {
    val values = hashMapOf<Int, String>(
        1 to "any",
        2 to "keyword",
        3 to "audience"
    )

    val keys = hashMapOf<String, Int>(
        "any" to 1,
        "keyword" to 2,
        "audience" to 3
    )
}
