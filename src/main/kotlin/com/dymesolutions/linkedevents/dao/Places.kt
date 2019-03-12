package com.dymesolutions.linkedevents.dao

import com.dymesolutions.common.extensions.PostGIS.point
import com.dymesolutions.linkedevents.models.MultiLangValue
import com.dymesolutions.linkedevents.models.Place
import com.dymesolutions.linkedevents.models.PlaceSave
import com.dymesolutions.linkedevents.models.UsageReport
import com.dymesolutions.linkedevents.utils.PublicationStatus
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import org.joda.time.DateTime

object Places : Table(name = "events_place") {
    val id = varchar("id", 50).primaryKey()
    val name = varchar("name", 255)
    val nameFi = varchar("name_fi", 255).nullable()
    val nameSv = varchar("name_sv", 255).nullable()
    val nameEn = varchar("name_en", 255).nullable()
    val originId = varchar("origin_id", 50)
    val createdTime = datetime("created_time").nullable()
    val lastModifiedTime = datetime("last_modified_time").nullable()

    val infoUrl = varchar("info_url", 1000)
    val infoUrlFi = varchar("info_url_fi", 1000).nullable()
    val infoUrlSv = varchar("info_url_sv", 1000).nullable()
    val infoUrlEn = varchar("info_url_en", 1000).nullable()

    val description = text("description").nullable()
    val descriptionFi = text("description_fi").nullable()
    val descriptionSv = text("description_sv").nullable()
    val descriptionEn = text("description_en").nullable()

    val position = point("position").nullable()
    val email = varchar("email", 254).nullable()

    val telephone = varchar("telephone", 128).nullable()
    val telephoneFi = varchar("telephone_fi", 128).nullable()
    val telephoneSv = varchar("telephone_sv", 128).nullable()
    val telephoneEn = varchar("telephone_en", 128).nullable()

    val contactType = varchar("contact_type", 255).nullable()

    val streetAddress = varchar("street_address", 255).nullable()
    val streetAddressFi = varchar("street_address_fi", 255).nullable()
    val streetAddressSv = varchar("street_address_sv", 255).nullable()
    val streetAddressEn = varchar("street_address_en", 255).nullable()

    val addressLocality = varchar("address_locality", 255).nullable()
    val addressLocalityFi = varchar("address_locality_fi", 255).nullable()
    val addressLocalitySv = varchar("address_locality_sv", 255).nullable()
    val addressLocalityEn = varchar("address_locality_en", 255).nullable()

    val addressRegion = varchar("address_region", 255).nullable()

    val postalCode = varchar("postal_code", 128).nullable()
    val postOfficeBoxNum = varchar("post_office_box_num", 128).nullable()

    val addressCountry = varchar("address_country", 2)

    val deleted = bool("deleted")

    val createdById = integer("created_by_id").nullable()

    val dataSourceId = varchar("data_source_id", 100)
    val lastModifiedById = integer("last_modified_by_id").nullable()

    val parentId = varchar("parent_id", 50).nullable()
    val publisherId = varchar("publisher_id", 255) references Organizations.id

    val customData = text("custom_data").nullable()

    val imageId = integer("image_id").nullable()

    val nEvents = integer("n_events")
    val nEventsChanged = integer("n_events_changed")

    val replacedById = varchar("replaced_by_id", 50)

    fun count(dataSourceId: String?, text: String?): Int {
        return transaction {
            slice(id)
                .select {
                    dataSourceId?.let {
                        Places.dataSourceId eq dataSourceId
                    }?.and((Places.deleted eq false)) ?: (Places.deleted eq false)
                }
                .count()
        }
    }

    fun countUsageOfAll(dataSourceId: String?): List<UsageReport> {
        val usageList = ArrayList<UsageReport>()

        transaction {
            Events
                .leftJoin(Places)
                .slice(Places.name, Places.id, Events.id.count())
                .select {
                    (Events.locationId eq Places.id) and
                        (Events.publicationStatus eq 1) and
                        (Events.deleted eq false) and (dataSourceId?.let {
                        Places.dataSourceId eq dataSourceId
                    }?.and((Places.deleted eq false)) ?: (Places.deleted eq false))

                }
                .groupBy(Places.id)
                .orderBy(Events.id.count(), false)
                .map {
                    usageList.add(UsageReport(
                        it[Places.id],
                        it[Places.name],
                        it[Events.id.count()]
                    ))
                }
        }

        return usageList
    }

    fun add(place: PlaceSave) {
        transaction {
            insert {
                it[id] = place.id
                it[name] = place.name.fi ?: ""
                it[nameFi] = place.name.fi
                it[nameSv] = place.name.sv
                it[nameEn] = place.name.en
                it[originId] = place.originId
                it[createdTime] = DateTime()
                it[lastModifiedTime] = place.lastModifiedTime ?: DateTime()
            }
        }
    }

    fun findById(placeId: String): Place? {
        return transaction {
            Places.select {
                id eq placeId
            }.map { place ->
                Place(
                    id = place[Places.id],
                    name = MultiLangValue(
                        fi = place[nameFi],
                        sv = place[nameSv],
                        en = place[nameEn]
                    ),
                    infoUrl = MultiLangValue(
                        fi = place[infoUrlFi],
                        sv = place[infoUrlSv],
                        en = place[infoUrlEn]
                    ),
                    description = MultiLangValue(
                        fi = place[descriptionFi],
                        sv = place[descriptionSv],
                        en = place[descriptionEn]
                    ),

                    streetAddress = MultiLangValue(
                        fi = place[Places.streetAddressFi],
                        sv = place[Places.streetAddressSv],
                        en = place[Places.streetAddressEn]
                    ),
                    addressRegion = place[Places.addressRegion],
                    postalCode = place[Places.postalCode],
                    postOfficeBoxNum = place[Places.postOfficeBoxNum],
                    addressCountry = place[Places.addressCountry],
                    addressLocality = MultiLangValue(
                        fi = place[Places.addressLocalityFi],
                        sv = place[Places.addressLocalitySv],
                        en = place[Places.addressLocalityEn]
                    ),

                    divisions = ArrayList(),
                    customData = place[Places.customData],

                    createdTime = place[Places.createdTime],
                    lastModifiedTime = place[Places.lastModifiedTime],
                    email = place[Places.email],
                    contactType = place[Places.contactType],
                    deleted = place[Places.deleted],
                    nEvents = place[Places.nEvents],
                    dataSource = place[Places.dataSourceId],
                    image = null,
                    publisher = place[Places.publisherId],
                    parent = place[Places.parentId],
                    replacedBy = null,
                    position = place[position],

                    telephone = MultiLangValue(
                        fi = place[Places.telephoneFi],
                        sv = place[Places.telephoneSv],
                        en = place[Places.telephoneEn]
                    )
                )
            }.let { if (it.isEmpty()) null else it.first() }
        }
    }

    fun findAll(
        pageSize: Int = 10,
        page: Int = 1,
        dataSourceId: String?,
        text: String?,
        sort: String = "name"): ArrayList<Place> {
        val places = ArrayList<Place>()

        // Limit the results for pagination, pass 0 offset to get the first page
        val offset = if (page == 1) 0 else (page - 1) * pageSize

        transaction {
            select {
                dataSourceId?.let {
                    Places.dataSourceId eq dataSourceId
                }?.and((Places.deleted eq false)) ?: (Places.deleted eq false)
            }
                .orderBy(name to true)
                .limit(pageSize, offset)
                .map { place ->
                    places.add(Place(
                        id = place[Places.id],
                        name = MultiLangValue(
                            fi = place[nameFi],
                            sv = place[nameSv],
                            en = place[nameEn]
                        ),
                        infoUrl = MultiLangValue(
                            fi = place[infoUrlFi],
                            sv = place[infoUrlSv],
                            en = place[infoUrlEn]
                        ),
                        description = MultiLangValue(
                            fi = place[descriptionFi],
                            sv = place[descriptionSv],
                            en = place[descriptionEn]
                        ),

                        streetAddress = MultiLangValue(
                            fi = place[Places.streetAddressFi],
                            sv = place[Places.streetAddressSv],
                            en = place[Places.streetAddressEn]
                        ),
                        addressRegion = place[Places.addressRegion],
                        postalCode = place[Places.postalCode],
                        postOfficeBoxNum = place[Places.postOfficeBoxNum],
                        addressCountry = place[Places.addressCountry],
                        addressLocality = MultiLangValue(
                            fi = place[Places.addressLocalityFi],
                            sv = place[Places.addressLocalitySv],
                            en = place[Places.addressLocalityEn]
                        ),

                        divisions = ArrayList(),
                        customData = place[Places.customData],

                        createdTime = place[Places.createdTime],
                        lastModifiedTime = place[Places.lastModifiedTime],
                        email = place[Places.email],
                        contactType = place[Places.contactType],
                        deleted = place[Places.deleted],
                        nEvents = place[Places.nEvents],
                        dataSource = place[Places.dataSourceId],
                        image = null,
                        publisher = place[Places.publisherId],
                        parent = place[Places.parentId],
                        replacedBy = null,
                        position = place[position],

                        telephone = MultiLangValue(
                            fi = place[Places.telephoneFi],
                            sv = place[Places.telephoneSv],
                            en = place[Places.telephoneEn]
                        )
                    ))
                }
        }

        return places
    }
}
