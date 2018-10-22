package com.dymesolutions.linkedevents

import com.dymesolutions.linkedevents.controllers.*
import com.google.gson.JsonObject
import spark.ModelAndView
import spark.Spark.*
import spark.template.thymeleaf.ThymeleafTemplateEngine

class AppRoute {
    private val eventController = EventController()
    private val imageController = ImageController()
    private val keywordController = KeywordController()
    private val keywordSetController = KeywordSetController()
    private val loginController = LoginController()
    private val monitorController = MonitorController()
    private val organizationController = OrganizationController()
    private val placeController = PlaceController()
    private val socialAppController = SocialAppController()
    private val userController = UserController()
    private val reportController = ReportController()

    /**
     * Inits all routes, following CRUD operations
     */
    fun initRoutes() {
        notFound { _, res ->
            res.type("application/json")

            val response = JsonObject()
            response.addProperty("message", "not found")
            response
        }

        get("/") { _, res ->
            res.redirect("${App.properties["server.apiPath"]}/")
        }

        path(App.properties["server.apiPath"].toString()) {

            // Add forwarding slash
            get("") { _, res ->
                res.redirect("/")
            }

            get("/") { _, _ ->
                val model = HashMap<String, String>()

                model["app.title"] = "Linked Events API"

                ThymeleafTemplateEngine().render(ModelAndView(model, "api/index"))
            }

            path("/event") {
                get("") { _, res -> res.redirect("/") }
                get("/") { req, res -> eventController.getAll(req, res) }
                get("/:eventId/") { req, res -> eventController.getById(req, res) }
                post("/") { req, res -> eventController.add(req, res) }
                put("/:eventId/") { req, res -> eventController.update(req, res) }
            }

            path("/keyword_set") {
                get("/") { req, res -> keywordSetController.getAll(req, res) }
                get("/:keywordSetId/") { req, res -> keywordSetController.getById(req, res) }
            }

            path("/keyword") {
                get("") { _, res -> res.redirect("/") }
                get("/") { req, res -> keywordController.getAll(req, res) }
                get("/exists/") { req, res -> keywordController.getExists(req, res) }
                get("/:keywordId/") { req, res -> keywordController.getById(req, res) }
                post("/") { req, res -> keywordController.add(req, res) }
            }

            path("/organization") {
                get("") { _, res -> res.redirect("/") }
                get("/") { req, res -> organizationController.getAll(req, res) }
            }

            path("/place") {
                get("") { _, res -> res.redirect("/") }
                get("/") { req, res -> placeController.getAll(req, res) }
            }

            path("/image") {
                get("") { _, res -> res.redirect("/") }
                get("/") { req, res -> imageController.getAll(req, res) }
                post("/") { req, res -> imageController.add(req, res) }
                post("/upload/") { req, res -> imageController.uploadImage(req, res) }
            }

            // Pass username and e-mail as query parameters to these routes:
            path("/user") {
                get("") { _, res -> res.redirect("/") }
                get("/exists/") { req, res -> userController.getExists(req, res) }
            }

            // Pass details as JSON to these routes:
            post("/login/") { req, res -> loginController.login(req, res) }
            post("/logout/") { req, res -> loginController.logout(req, res) }
            post("/register/") { req, res -> loginController.register(req, res) }
            post("/verify-email/") { req, res -> loginController.verifyEmail(req, res) }
            post("/reset-password/") { req, res -> loginController.resetPassword(req, res) }
            post("/verify-reset-key/") { req, res -> loginController.verifyResetKey(req, res) }
            post("/change-password/") { req, res -> loginController.changePasswordWithResetKey(req, res) }

            // Social accounts
            path("/auth") {
                // Google
                get("/google/callback/") { req, res -> socialAppController.loginWithGoogle(req, res) }
            }

            // Can be used for example in AWS for monitoring
            path("/health") {
                get("") { _, res -> res.redirect("/") }
                get("/") { _, res ->
                    res.status(200)
                    res.type("text/plain")
                    "OK"
                }
            }

            // **** PROTECTED ROUTES (note that also POST & PUT methods above are protected) ****


            // Protected SUPER USER routes (AppFilter):
            path("/admin") {
                path("/keyword_set/") {
                    get("/") { req, res -> keywordController.getAll(req, res, true) }
                }

                path("/keyword/") {
                    get("/") { req, res -> keywordController.getAll(req, res, true) }
                }
                path("/user") {
                    get("/") { req, res -> userController.getAll(req, res, false, true) }
                    put("/") { req, res -> userController.update(req, res) }
                }
            }

            // Protected ADMIN routes (AppFilter):
            path("/manager") {
                path("/event") {
                    get("/") { req, res -> eventController.getAll(req, res, true) }
                    get("/:eventId/") { req, res -> eventController.getByIdForEdit(req, res, true) }
                    put("/publish/") { req, res -> eventController.publish(req, res, true) }
                    put("/") { req, res -> eventController.update(req, res, true) }
                    delete("/:eventId/") { req, res -> eventController.delete(req, res, true) }
                }
            }

            // Protected BASIC routes (AppFilter):
            path("/basic") {
                path("/event") {
                    get("/") { req, res -> eventController.getAllByLoggedInUser(req, res) }
                    get("/:eventId/") { req, res -> eventController.getByIdForEdit(req, res) }
                    post("/") { req, res -> eventController.add(req, res) }
                    put("/:eventId/") { req, res -> eventController.update(req, res) }
                    delete("/:eventId/") { req, res -> eventController.delete(req, res) }
                }

                // Images
                post("/image/") { req, res -> imageController.add(req, res) }

                // Get your own info
                get("/user/") { req, res -> userController.getLoggedInUser(req, res) }
            }

            // Reporting
            path("/report") {
                get("/event/count/") { req, res -> reportController.getEventsCount(req, res) }
                get("/keyword/usage/count/") { req, res -> reportController.getKeywordUsageCount(req, res) }
                get("/place/usage/count/") { req, res -> reportController.getPlaceUsageCount(req, res) }
            }

            // Monitoring endpoint for UI
            path("/monitor") {
                post("/ui/") { req, res -> monitorController.saveLog(req, res) }
            }
        }
    }
}
