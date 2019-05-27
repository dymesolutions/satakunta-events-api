package com.dymesolutions.common.utils

import org.eclipse.jetty.server.AbstractNCSARequestLog
import org.eclipse.jetty.server.CustomRequestLog
import org.eclipse.jetty.server.RequestLogWriter
import org.eclipse.jetty.server.Server
import org.eclipse.jetty.util.thread.QueuedThreadPool
import org.eclipse.jetty.util.thread.ThreadPool
import org.slf4j.Logger
import spark.embeddedserver.EmbeddedServers
import spark.embeddedserver.jetty.EmbeddedJettyFactory
import spark.embeddedserver.jetty.JettyServerFactory

/**
 * @author Dyme Solutions
 */

// This is a Kotlin implementation of https://github.com/ygaller/spark-with-request-logger

object RequestLogUtils {
    fun createServerWithRequestLog(logger: Logger) {
        val requestLog: AbstractNCSARequestLog = RequestLogFactory(logger).create()
        val factory = EmbeddedJettyFactoryConstructor(requestLog).create()

        EmbeddedServers.add(EmbeddedServers.Identifiers.JETTY, factory)
    }
}

private class RequestLogFactory
constructor(private val logger: Logger) {
    fun create(): AbstractNCSARequestLog {
        val writer = RequestLogWriter()
        return object : AbstractNCSARequestLog(writer) {
            override fun isEnabled(): Boolean {
                return true
            }

            override fun write(requestEntry: String?) {
                logger.info(requestEntry)
            }
        }
    }
}

private class EmbeddedJettyServerFactory(private val embeddedJettyFactoryConstructor: EmbeddedJettyFactoryConstructor) : JettyServerFactory {

    override fun create(maxThreads: Int, minThreads: Int, threadTimeoutMillis: Int): Server {
        return when {
            maxThreads > 0 -> {
                val max = if (maxThreads > 0) maxThreads else 200
                val min = if (minThreads > 0) minThreads else 8
                val idleTimeout = if (threadTimeoutMillis > 0) threadTimeoutMillis else '\uea60'.toInt()
                Server(QueuedThreadPool(max, min, idleTimeout))
            }
            else -> Server()
        }.apply {
            requestLog = embeddedJettyFactoryConstructor.requestLog
        }
    }

    override fun create(threadPool: ThreadPool?): Server {
        return Server(threadPool)
    }
}


private class EmbeddedJettyFactoryConstructor
constructor(val requestLog: AbstractNCSARequestLog) {

    fun create(): EmbeddedJettyFactory {
        return EmbeddedJettyFactory(EmbeddedJettyServerFactory(this))
    }
}
