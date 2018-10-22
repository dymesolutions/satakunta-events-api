package com.dymesolutions.linkedevents.utils

object EventStatus {
    val values = hashMapOf(
        1 to "EventScheduled",
        2 to "EventCancelled",
        3 to "EventPostponed",
        4 to "EventRescheduled"
    )

    val keys = hashMapOf(
        "EventScheduled" to 1,
        "EventCancelled" to 2,
        "EventPostponed" to 3,
        "EventRescheduled" to 4
    )
}
