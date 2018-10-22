package com.dymesolutions.linkedevents.models

// Event price offer
data class Offer(
    val id: Int,
    val price: MultiLangValue,
    val infoUrl: MultiLangValue,
    val description: MultiLangValue,
    val isFree: Boolean,
    val eventId: String
)

data class OfferSave(
    val price: MultiLangValue,
    val infoUrl: MultiLangValue,
    val description: MultiLangValue,
    val isFree: Boolean,
    val eventId: String
)
