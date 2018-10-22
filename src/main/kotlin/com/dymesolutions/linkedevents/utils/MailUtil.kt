package com.dymesolutions.linkedevents.common.utils

import com.dymesolutions.linkedevents.App.properties
import com.dymesolutions.linkedevents.models.EventSave
import com.dymesolutions.linkedevents.models.User
import com.dymesolutions.linkedevents.models.UserPasswordReset
import org.apache.commons.mail.DefaultAuthenticator
import org.apache.commons.mail.HtmlEmail
import org.apache.commons.mail.SimpleEmail
import org.slf4j.LoggerFactory

object MailUtil {
    private val sender = properties["mail.user"].toString()
    private val password = properties["mail.password"].toString()
    private val port = properties["mail.port"].toString().toInt()
    private val host = properties["mail.host"].toString()

    private val log = LoggerFactory.getLogger(MailUtil::class.java)

    private fun configureEmail(subject: String): SimpleEmail {
        val email = SimpleEmail()

        email.hostName = host
        email.setSmtpPort(port)
        email.setAuthenticator(DefaultAuthenticator(sender, password))
        email.isSSLOnConnect = true
        email.setFrom(sender)
        email.subject = subject
        email.setFrom(sender, "Satakunta Events")
        email.setCharset("UTF-8")

        return email
    }

    fun sendPasswordResetEmail(resetKey: String, email: String) {
        val simpleMail = configureEmail("Satakunta Events - palauta salasanasi")
        val passwordResetLink = "${properties["server.uiUrl"]}/reset/password/$resetKey"
        val emailMessage = "Olet pyytänyt salasanan palautusta. Vieraile linkissä: $passwordResetLink vaihtaaksesi salasanasi. Linkki vanhenee 60 minuutin kuluessa. /Satakunta Events"

        simpleMail.setMsg(emailMessage)
        simpleMail.addTo(email)
        simpleMail.send()
    }

    fun sendEventPublishedNotification(event: EventSave, user: User) {
        val uiLink = "${properties["server.uiUrl"]}/event/{$event.id}"
        val email = HtmlEmail()

        email.hostName = host
        email.setSmtpPort(port)
        email.setAuthenticator(DefaultAuthenticator(sender, password))
        email.isSSLOnConnect = true
        email.setFrom(sender)
        email.subject = "Satakunta Events - Tapahtumatiedon lisäys/muutos"
        email.addTo(user.email)
        email.setTextMsg("")
        email.send()
    }

    fun sendNewEventNotification(event: EventSave, user: User, edited: Boolean = false) {
        val uiLink = "${properties["server.uiUrl"]}/manage"

        val name = when {
            !user.firstName.isBlank() && !user.lastName.isBlank() -> "${user.firstName} ${user.lastName}"
            !user.firstName.isBlank() && user.lastName.isBlank() -> user.firstName
            !user.username.isBlank() -> user.username
            else -> user.email
        }

        val emailBuilder = StringBuilder()

        emailBuilder
            .append("Hei, $name on ")
            .append(when {
                edited -> "muokannut tapahtumaa "
                else -> "luonut uuden tapahtuman "
            })
            .append("'${event.name.fi}'. ")
            .append("Ole hyvä ja tarkista tiedot osoitteessa $uiLink ja hyväksy/hylkää tapahtuma.")

        val email = SimpleEmail()
        email.hostName = host
        email.setSmtpPort(port)
        email.setAuthenticator(DefaultAuthenticator(sender, password))
        email.isSSLOnConnect = true
        email.setFrom(sender)

        email.subject = "Satakunta Events - Tapahtumatiedon lisäys/muutos"

        email.setCharset("UTF-8")
        email.setMsg(emailBuilder.toString())

        properties["app.moderatorEmails"]
            .toString()
            .split(",")
            .filter {
                it.isNotEmpty()
            }
            .forEach { emailAddress ->
                email.addTo(emailAddress.trim())
            }

        if(email.toAddresses.isNotEmpty()) {
            email.send()
        } else {
            log.info("No moderator e-mails configured, not sending e-mail!")
        }
    }

    fun sendRegistrationConfirmation(emailAddress: String, confirmationKey: String) {
        val confirmationLink = "${properties["server.uiUrl"]}/verify/email/$confirmationKey"
        val emailMessage = "Hei,<br/><br/>Kiitos rekisteröitymisestäsi Satakunta Events palveluun. Vieraile linkissä: <a href='$confirmationLink' target='_blank'>$confirmationLink</a> aktivoidaksesi tunnuksesi.<br/><br/>Satakunta Events"
        val email = HtmlEmail()

        email.hostName = host
        email.setSmtpPort(port)
        email.setAuthenticator(DefaultAuthenticator(sender, password))
        email.isSSLOnConnect = true
        email.setFrom(sender)
        email.addTo(emailAddress)
        email.subject = "Satakunta Events - vahvista sähköpostiosoitteesi"
        email.setCharset("UTF-8")
        email.setHtmlMsg(emailMessage)
        email.send()
    }
}
