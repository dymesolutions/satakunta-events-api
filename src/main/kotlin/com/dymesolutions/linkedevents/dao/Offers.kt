package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.MultiLangValue
import com.dymesolutions.linkedevents.models.Offer
import com.dymesolutions.linkedevents.models.OfferSave
import org.jetbrains.exposed.sql.Table
import org.jetbrains.exposed.sql.insert
import org.jetbrains.exposed.sql.select
import org.jetbrains.exposed.sql.transactions.transaction

object Offers : Table("events_offer") {
    val id = integer("id").primaryKey().autoIncrement()
    val price = varchar("price", 1000)
    val priceFi = varchar("price_fi", 1000).nullable()
    val priceSv = varchar("price_sv", 1000).nullable()
    val priceEn = varchar("price_en", 1000).nullable()

    val infoUrl = varchar("info_url", 1000)
    val infoUrlFi = varchar("info_url_fi", 1000).nullable()
    val infoUrlSv = varchar("info_url_sv", 1000).nullable()
    val infoUrlEn = varchar("info_url_en", 1000).nullable()

    val description = varchar("description", 1000)
    val descriptionFi = varchar("description_fi", 1000).nullable()
    val descriptionSv = varchar("description_sv", 1000).nullable()
    val descriptionEn = varchar("description_en", 1000).nullable()

    val isFree = bool("is_free")
    val eventId = varchar("event_id", 50) references Events.id

    fun add(offer: OfferSave): Int? {
        return transaction {
            insert {
                it[price] = offer.price.fi ?: ""
                it[priceFi] = offer.price.fi
                it[priceSv] = offer.price.sv
                it[priceEn] = offer.price.en

                it[infoUrl] = offer.infoUrl.fi ?: ""
                it[infoUrlFi] = offer.infoUrl.fi
                it[infoUrlSv] = offer.infoUrl.sv
                it[infoUrlEn] = offer.infoUrl.en

                it[description] = offer.description.fi ?: ""
                it[descriptionFi] = offer.description.fi
                it[descriptionSv] = offer.description.sv
                it[descriptionEn] = offer.description.en

                it[isFree] = offer.isFree
                it[eventId] = offer.eventId

            }.generatedKey?.toInt()
        }
    }

    fun findAllByEventId(eventId: String): ArrayList<Offer> {
        val offers = ArrayList<Offer>()

        transaction {
            select {
                Offers.eventId eq eventId
            }.map { offer ->
                offers.add(Offer(
                    id = offer[id],
                    price = MultiLangValue(
                        fi = offer[priceFi],
                        sv = offer[priceSv],
                        en = offer[priceEn]
                    ),
                    infoUrl = MultiLangValue(
                        fi = offer[infoUrlFi],
                        sv = offer[infoUrlSv],
                        en = offer[infoUrlEn]
                    ),
                    description = MultiLangValue(
                        fi = offer[descriptionFi],
                        sv = offer[descriptionSv],
                        en = offer[descriptionEn]
                    ),
                    isFree = offer[isFree],
                    eventId = offer[Offers.eventId]
                ))
            }
        }

        return offers
    }
}
