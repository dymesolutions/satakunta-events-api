package com.dymesolutions.linkedevents.dao

import com.dymesolutions.common.utils.PBKDF2Hasher
import com.dymesolutions.common.utils.PasswordComponents
import com.dymesolutions.linkedevents.models.*
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import org.joda.time.DateTime
import java.util.*
import kotlin.collections.ArrayList

/*infix fun ExpressionWithColumnType<*>.concat(expr: Expression<*>): Op<Boolean> = ConcatOp(this, expr)

private class ConcatOp(expr: Expression<*>, expr2: Expression<*>) : Op<Boolean>() {
    override fun toSQL(queryBuilder: QueryBuilder) = "CONCAT(${expr.toSQL(queryBuilder)},${expr2.toSQL(queryBuilder)})"
}*/

object Users : Table(name = "helevents_user") {
    val id = integer("id").autoIncrement().primaryKey()
    val password = varchar("password", length = 128)
    val username = varchar("username", length = 150).uniqueIndex()
    val firstName = varchar("first_name", length = 30)
    val lastName = varchar("last_name", length = 30)
    val email = varchar("email", length = 254).uniqueIndex()
    val dateJoined = datetime("date_joined")
    val lastLogin = datetime("last_login").nullable()
    val uuid = uuid("uuid")

    // Control values
    val isSuperUser = bool("is_superuser")
    val isStaff = bool("is_staff")
    val isActive = bool("is_active")

    fun countAll(): Int {
        return transaction {
            selectAll().count()
        }
    }

    fun add(user: UserSave): Int? {
        return transaction {
            insert { users ->
                users[firstName] = user.firstName ?: ""
                users[lastName] = user.lastName ?: ""
                users[username] = user.username
                users[email] = user.email
                users[password] = PBKDF2Hasher.generatePasswordHash(user.password)
                users[isStaff] = user.isStaff
                users[isSuperUser] = user.isSuperUser
                users[isActive] = user.isActive
                users[dateJoined] = DateTime.now()
                users[uuid] = UUID.randomUUID()
            }.generatedKey?.toInt()
        }
    }

    fun findAll(textQuery: String?): ArrayList<User> {
        val users = ArrayList<User>()

        transaction {
            (Users innerJoin OrganizationRegularUsers innerJoin Organizations)
                .select {
                    getSelectExpressions(textQuery)
                }.orderBy(dateJoined to false)
                .map { user ->
                    users.add(User(
                        id = user[Users.id],
                        username = user[username],
                        email = user[email],
                        password = user[password],
                        firstName = user[firstName],
                        lastName = user[lastName],
                        isStaff = user[isStaff],
                        isSuperUser = user[isSuperUser],
                        isActive = user[isActive],
                        dateJoined = user[dateJoined],
                        lastLogin = user[lastLogin],
                        uuid = user[uuid],
                        organization = Organization(
                            id = user[Organizations.id],
                            originId = user[Organizations.originId],
                            name = user[Organizations.name],
                            foundingDate = user[Organizations.foundingDate],
                            dissolutionDate = user[Organizations.dissolutionDate],
                            createdTime = user[Organizations.createdTime],
                            lastModifiedTime = user[Organizations.lastModifiedTime],
                            classificationId = user[Organizations.classificationId],
                            createdById = user[Organizations.lastModifiedById],
                            dataSourceId = user[Organizations.dataSourceId],
                            lastModifiedById = user[Organizations.lastModifiedById],
                            parentId = user[Organizations.parentId],
                            replacedById = user[Organizations.replacedById],
                            internalType = user[Organizations.internalType]
                        )
                    ))
                }
        }

        return users
    }

    fun findUsernameExists(username: String): Boolean {
        return transaction {
            select {
                Users.username eq username
            }.map { users ->
                users[Users.username]
            }.let { usernames ->
                // If list is empty, username does not exist
                !usernames.isEmpty()
            }
        }

    }

    fun findEmailExists(email: String): Boolean {
        return transaction {
            select {
                Users.email eq email
            }.map { emails ->
                emails[Users.email]
            }.let { emails ->
                // If list is empty, username does not exist
                !emails.isEmpty()
            }
        }
    }

    fun findByEmail(email: String): LoginUser? {
        return transaction {
            select {
                Users.email eq email
            }.map { user ->
                LoginUser(
                    id = user[id],
                    username = user[Users.username],
                    password = user[password])
            }.let { users ->
                if (users.isNotEmpty()) {
                    users.first()
                } else {
                    null
                }
            }
        }
    }

    fun findById(id: Int, relativeFields: Boolean = false): User? {
        return transaction {
            select {
                Users.id eq id
            }.map { user ->
                User(id = user[Users.id],
                    username = user[username],
                    email = user[email],
                    password = user[password],
                    firstName = user[firstName],
                    lastName = user[lastName],
                    isStaff = user[isStaff],
                    isSuperUser = user[isSuperUser],
                    isActive = user[isActive],
                    dateJoined = user[dateJoined],
                    lastLogin = user[lastLogin],
                    uuid = user[uuid],
                    organization = null)
            }.let { users ->
                if (users.isNotEmpty()) {
                    users.first()
                } else {
                    null
                }
            }
        }
    }

    /**
     * Return just the user details needed for login
     */
    fun findByUsername(username: String): LoginUser? {
        return transaction {
            select {
                Users.username eq username
            }.map {
                LoginUser(
                    id = it[id],
                    username = it[Users.username],
                    password = it[password])
            }.let { users ->
                if (users.isNotEmpty()) {
                    users.first()
                } else {
                    null
                }
            }
        }
    }

    fun findByToken(token: String): User? {
        return transaction {
            (Tokens innerJoin Users)
                .slice(
                    id, username, email, firstName, lastName, isStaff, isSuperUser, isActive, dateJoined, lastLogin,
                    uuid)
                .select {
                    (Tokens.key eq token) and (Users.id eq Tokens.userId)
                }
                .map { user ->
                    User(id = user[id],
                        username = user[username],
                        email = user[email],
                        password = "",
                        firstName = user[firstName],
                        lastName = user[lastName],
                        isStaff = user[isStaff],
                        isSuperUser = user[isSuperUser],
                        isActive = user[isActive],
                        dateJoined = user[dateJoined],
                        lastLogin = user[lastLogin],
                        uuid = user[uuid],
                        organization = null)
                }.let { users ->
                    if (users.isNotEmpty()) {
                        users.first()
                    } else {
                        null
                    }
                }
        }
    }

    fun setActive(userId: Int, active: Boolean = true) {
        transaction {
            update({
                Users.id eq userId
            }) {
                it[Users.isActive] = active
            }
        }
    }

    fun update(user: UserUpdate) {
        transaction {
            update({
                Users.id eq user.id
            }) {
                it[isStaff] = user.isStaff
                it[isActive] = user.isActive
                it[firstName] = user.firstName ?: ""
                it[lastName] = user.lastName ?: ""
            }
        }
    }

    fun updatePassword(userId: Int, password: String) {
        transaction {
            update({
                Users.id eq userId
            }) {
                it[Users.password] = PBKDF2Hasher.generatePasswordHash(password)
            }
        }
    }

    fun updateLastLogin(userId: Int) {
        transaction {
            update({
                Users.id eq userId
            }) {
                it[Users.lastLogin] = DateTime()
            }
        }
    }

    fun delete() {

    }

    private fun getSelectExpressions(textQuery: String?): Op<Boolean> {
        // Build WHERE clause based on parameters

        var opBuild = Op.build {
            ((Organizations.id eq OrganizationRegularUsers.organizationId) and
                (Users.id eq OrganizationRegularUsers.userId))
        }

        when {
            textQuery != null -> {
                val textQueryLike = "%${textQuery.toUpperCase()}%"
                opBuild = opBuild.and(Expression.build {
                    (Trim(UpperCase(Users.username)) like textQueryLike) or
                        (Trim(UpperCase(Users.firstName)) like textQueryLike) or
                        (Trim(UpperCase(Users.lastName)) like textQueryLike)
                })
            }
        }

        return opBuild
    }
}
