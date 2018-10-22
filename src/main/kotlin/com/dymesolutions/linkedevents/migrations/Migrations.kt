package com.dymesolutions.linkedevents.migrations

import com.dymesolutions.common.utils.Readers
import com.dymesolutions.linkedevents.App
import com.dymesolutions.linkedevents.dao.*
import com.dymesolutions.linkedevents.models.*
import com.google.gson.JsonArray
import com.google.gson.JsonParser
import org.jetbrains.exposed.sql.transactions.transaction
import org.joda.time.DateTime
import org.slf4j.LoggerFactory
import java.io.File

class Migrations {
    companion object {
        private val jsonParser = JsonParser()
        private val log = LoggerFactory.getLogger(App::class.java)
        private val tableNames = listOf("events_event", "helevents_user", "django_orghierarchy_organization", "events_datasource")
        private val migrationsPath = "${File.separator}migrations${File.separator}"
    }

    private fun checkTableExists(tableName: String): Boolean {
        return transaction {
            val query =
                """
                SELECT EXISTS(
                    SELECT 1
                    FROM   information_schema.tables
                    WHERE  table_schema = 'public'
                    AND    table_name = '$tableName'
                );""".trimIndent()

            exec(query) {
                it.next()
                it.getBoolean(1)
            } ?: false

        }
    }

    fun checkSchemaAndMigrateData(): Boolean {
        log.info("Checking database schema...")

        // First check that required tables exist
        tableNames.forEach {
            if (!checkTableExists(it)) {
                log.error("Required table '$it' doesn't exist!")
                return false
            }
        }

        migrateDataSources()
        migrateOrganizations()
        migrateUsers()
        migrateKeywordSets()
        migrateKeywords()

        return true
    }

    private fun migrateUsers() {
        parseJsonArrayFromResource("${migrationsPath}users.json") { array ->
            array.map {
                val user = it.asJsonObject
                UserSave(
                    username = user["username"].asString,
                    email = user["email"].asString,
                    password = user["password"].asString,
                    firstName = user["firstName"].asString,
                    lastName = user["lastName"].asString,
                    isStaff = user["isStaff"].asBoolean,
                    isSuperUser = user["isSuperUser"].asBoolean,
                    isActive = user["isActive"].asBoolean
                )
            }.forEach { userToSave ->
                if (Users.findByUsername(userToSave.username) == null) {
                    log.info("Saving user with username '${userToSave.username}'")
                    Users.add(userToSave)?.let { userId ->
                        // Add user to system admins
                        OrganizationRegularUsers.add(userId, "system:admins")
                        EmailAddresses.add(email = userToSave.email, userId = userId)
                    }?.let { emailAddressId ->
                        EmailAddresses.verifyById(emailAddressId)
                    }
                } else {
                    log.warn("User with username '${userToSave.email}' already exists!")
                }
            }
        }
    }

    private fun migrateDataSources() {
        parseJsonArrayFromResource("${migrationsPath}datasources.json") { array ->
            array.map {
                val dataSource = it.asJsonObject
                DataSourceSave(
                    id = dataSource["id"].asString,
                    name = dataSource["name"].asString,
                    apiKey = dataSource["apiKey"].asString,
                    ownerId = dataSource["ownerId"].let { ownerId -> if (ownerId.isJsonNull) null else ownerId.asString },
                    userEditable = dataSource["userEditable"].asBoolean
                )
            }.forEach { dataSourceToSave ->
                if (DataSources.findById(dataSourceToSave.id) == null) {
                    log.info("Saving datasource with ID '${dataSourceToSave.id}'")
                    DataSources.add(dataSourceToSave)
                } else {
                    log.warn("Data Source with ID ${dataSourceToSave.id} already exists!")
                }
            }
        }
    }

    private fun migrateOrganizations() {
        parseJsonArrayFromResource("${migrationsPath}organizations.json") { array ->
            array.map {
                val organization = it.asJsonObject
                OrganizationSave(
                    originId = organization["originId"].asString,
                    name = organization["name"].asString,
                    dataSourceId = organization["dataSourceId"].asString,
                    foundingDate = null,
                    dissolutionDate = null,
                    classificationId = null,
                    createdById = null,
                    lastModifiedById = null,
                    parentId = null,
                    replacedById = null,
                    internalType = ""
                )
            }.forEach { organizationToSave ->
                val organizationId = "${organizationToSave.dataSourceId}:${organizationToSave.originId}"
                if (Organizations.findById(organizationId) == null) {
                    log.info("Saving organization with ID '$organizationId'")
                    Organizations.add(organizationToSave)
                } else {
                    log.warn("Organization with ID $organizationId already exists!")
                }
            }
        }
    }

    private fun migratePlaces() {
        parseJsonArrayFromResource("${migrationsPath}places.json") { array ->
            array.map {
                val place = it.asJsonObject
            }
        }
    }

    private fun migrateKeywordSets() {
        parseJsonArrayFromResource("${migrationsPath}keyword-sets.json") { array ->
            array.map {
                val keywordSet = it.asJsonObject
                KeywordSetSave(
                    name = MultiLangValue(
                        fi = keywordSet["name"].asString,
                        sv = null,
                        en = null
                    ),
                    usage = keywordSet["usage"].asInt,
                    origin = keywordSet["originId"].asString,
                    dataSourceId = keywordSet["dataSourceId"].asString,
                    image = keywordSet["image"].let { image -> if (image.isJsonNull) null else image.asInt },
                    organization = keywordSet["organization"].asString
                )
            }.forEach { keywordSetToSave ->
                val keywordSetId = "${keywordSetToSave.dataSourceId}:${keywordSetToSave.origin}"
                if (KeywordSets.findById(keywordSetId) == null) {
                    log.info("Saving keyword set with ID '$keywordSetId'")
                    KeywordSets.add(keywordSetToSave)
                } else {
                    log.warn("Keyword set with ID $keywordSetId already exists!")
                }
            }
        }
    }

    private fun migrateKeywords() {
        parseJsonArrayFromResource("${migrationsPath}keywords.json") { array ->
            array.map {
                val keyword = it.asJsonObject

                KeywordSave(
                    id = keyword["id"].asString,
                    name = MultiLangValue(
                        fi = keyword["name"].asString,
                        sv = null,
                        en = null
                    ),
                    originId = keyword["originId"].asString,
                    createdTime = DateTime(),
                    lastModifiedTime = DateTime(),
                    aggregate = false,
                    createdById = null,
                    dataSourceId = keyword["dataSourceId"].asString,
                    lastModifiedById = null,
                    imageId = null,
                    deprecated = false,
                    nEvents = 0,
                    nEventsChanged = false,
                    publisherId = keyword["publisherId"].asString
                )
            }.forEach { keywordToSave ->
                val keywordSetId = "${keywordToSave.dataSourceId}:${keywordToSave.originId}"
                val keywordId = "$keywordSetId:${keywordToSave.id}"

                if (Keywords.findById(keywordId) == null) {
                    log.info("Saving keyword with ID '$keywordId'")
                    Keywords.add(keywordToSave)

                    KeywordSetKeywords.add(
                        keywordSetId,
                        keywordId
                    )
                } else {
                    log.warn("Keyword with ID $keywordId already exists!")
                }
            }
        }
    }


    private fun parseJsonArrayFromResource(resourceName: String, process: (JsonArray) -> Unit) {
        val jsonArray = javaClass.getResourceAsStream(resourceName)?.let { inputStream ->
            inputStream.use {
                jsonParser.parse(Readers.readInputStream(it)).asJsonArray
            }
        }

        process(jsonArray ?: JsonArray())
    }
}
