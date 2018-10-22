package com.dymesolutions.linkedevents.dao

import com.dymesolutions.linkedevents.models.Organization
import com.dymesolutions.linkedevents.models.OrganizationSave
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import org.joda.time.DateTime

object OrganizationAdminUsers : Table("django_orghierarchy_organization_admin_users") {
    val id = integer("id").primaryKey().autoIncrement()
    val organizationId = varchar("organization_id", 255) references Organizations.id
    val userId = integer("user_id") references Users.id
}

object OrganizationRegularUsers : Table("django_orghierarchy_organization_regular_users") {
    val id = integer("id").primaryKey().autoIncrement()
    val organizationId = varchar("organization_id", 255) references Organizations.id
    val userId = integer("user_id") references Users.id

    fun add(userId: Int, organizationId: String) {
        transaction {
            insert {
                it[OrganizationRegularUsers.organizationId] = organizationId
                it[OrganizationRegularUsers.userId] = userId
            }
        }
    }

    fun delete(userId: Int, organizationId: String) {
        transaction {
            deleteWhere {
                (OrganizationRegularUsers.userId eq userId) and
                    (OrganizationRegularUsers.organizationId eq organizationId)
            }
        }
    }
}

object Organizations : Table("django_orghierarchy_organization") {
    val id = varchar("id", 255).primaryKey()
    val originId = varchar("origin_id", 255)
    val name = varchar("name", 255)
    val foundingDate = datetime("founding_date").nullable()
    val dissolutionDate = datetime("dissolution_date").nullable()
    val createdTime = datetime("created_time")
    val lastModifiedTime = datetime("last_modified_time")
    val classificationId = varchar("classification_id", 255).nullable()
    val createdById = integer("created_by_id").nullable()
    val dataSourceId = varchar("data_source_id", 100)
    val lastModifiedById = integer("last_modified_by_id").nullable()
    val parentId = varchar("parent_id", 255).nullable()
    val replacedById = varchar("replaced_by_id", 255).nullable()
    val internalType = varchar("internal_type", 20)

    // TODO refactor to remove, needed here to stay consistent with db:
    val lft = integer("lft")
    val rght = integer("rght")
    val treeId = integer("tree_id")
    val level = integer("level")


    fun count(): Int {
        return transaction {
            slice(id)
                .selectAll()
                .count()
        }
    }

    fun add(organization: OrganizationSave) {
        transaction {
            insert {
                it[id] = "${organization.dataSourceId}:${organization.originId}"
                it[originId] = organization.originId
                it[name] = organization.name
                it[foundingDate] = organization.foundingDate
                it[dissolutionDate] = organization.dissolutionDate
                it[createdTime] = DateTime()
                it[lastModifiedTime] = DateTime()
                it[classificationId] = organization.classificationId
                it[createdById] = organization.createdById
                it[dataSourceId] = organization.dataSourceId
                it[lastModifiedById] = organization.lastModifiedById
                it[parentId] = organization.parentId
                it[replacedById] = organization.replacedById
                it[internalType] = organization.internalType
                it[lft] = 1
                it[rght] = 2
                it[treeId] = 1
                it[level] = 0
            }
        }
    }

    fun findAll(
        pageSize: Int = 30,
        page: Int = 1
    ): List<Organization> {

        val offset = if (page == 1) 0 else (page - 1) * pageSize

        return transaction {
            selectAll()
                .limit(pageSize, offset)
                .map { organization ->
                    Organization(
                        id = organization[id],
                        originId = organization[originId],
                        name = organization[name],
                        foundingDate = organization[foundingDate],
                        dissolutionDate = organization[dissolutionDate],
                        createdTime = organization[createdTime],
                        lastModifiedTime = organization[lastModifiedTime],
                        classificationId = organization[classificationId],
                        createdById = organization[lastModifiedById],
                        dataSourceId = organization[dataSourceId],
                        lastModifiedById = organization[lastModifiedById],
                        parentId = organization[parentId],
                        replacedById = organization[replacedById],
                        internalType = organization[internalType]
                    )
                }
        }
    }

    fun findById(id: String): Organization? {
        return transaction {
            Organizations.select {
                Organizations.id eq id
            }.map { organization ->
                Organization(
                    id = organization[Organizations.id],
                    originId = organization[originId],
                    name = organization[name],
                    foundingDate = organization[foundingDate],
                    dissolutionDate = organization[dissolutionDate],
                    createdTime = organization[createdTime],
                    lastModifiedTime = organization[lastModifiedTime],
                    classificationId = organization[classificationId],
                    createdById = organization[lastModifiedById],
                    dataSourceId = organization[dataSourceId],
                    lastModifiedById = organization[lastModifiedById],
                    parentId = organization[parentId],
                    replacedById = organization[replacedById],
                    internalType = organization[internalType]
                )
            }.let { if (it.isEmpty()) null else it.first() }
        }
    }

    fun findByUserId(userId: Int): Organization? {
        return findInRegularUsers(userId).let { orgsInRegularUsers ->
            if (orgsInRegularUsers.isEmpty()) {
                findInAdminUsers(userId).let { orgsInAdminUsers ->
                    if (!orgsInAdminUsers.isEmpty()) {
                        orgsInAdminUsers.first()
                    } else {
                        null
                    }
                }
            } else {
                orgsInRegularUsers.first()
            }
        }
    }

    private fun findInAdminUsers(userId: Int): List<Organization> {
        return transaction {
            (OrganizationAdminUsers innerJoin Organizations)
                .select {
                    (OrganizationAdminUsers.userId eq userId) and
                        (Organizations.id eq OrganizationAdminUsers.organizationId)
                }.map { organization ->
                    Organization(
                        id = organization[id],
                        originId = organization[originId],
                        name = organization[name],
                        foundingDate = organization[foundingDate],
                        dissolutionDate = organization[dissolutionDate],
                        createdTime = organization[createdTime],
                        lastModifiedTime = organization[lastModifiedTime],
                        classificationId = organization[classificationId],
                        createdById = organization[lastModifiedById],
                        dataSourceId = organization[dataSourceId],
                        lastModifiedById = organization[lastModifiedById],
                        parentId = organization[parentId],
                        replacedById = organization[replacedById],
                        internalType = organization[internalType]
                    )
                }
        }
    }

    private fun findInRegularUsers(userId: Int): List<Organization> {
        return transaction {
            (OrganizationRegularUsers innerJoin Organizations)
                .select {
                    (OrganizationRegularUsers.userId eq userId) and
                        (Organizations.id eq OrganizationRegularUsers.organizationId)
                }.map { organization ->
                    Organization(
                        id = organization[id],
                        originId = organization[originId],
                        name = organization[name],
                        foundingDate = organization[foundingDate],
                        dissolutionDate = organization[dissolutionDate],
                        createdTime = organization[createdTime],
                        lastModifiedTime = organization[lastModifiedTime],
                        classificationId = organization[classificationId],
                        createdById = organization[lastModifiedById],
                        dataSourceId = organization[dataSourceId],
                        lastModifiedById = organization[lastModifiedById],
                        parentId = organization[parentId],
                        replacedById = organization[replacedById],
                        internalType = organization[internalType]
                    )
                }
        }
    }
}
