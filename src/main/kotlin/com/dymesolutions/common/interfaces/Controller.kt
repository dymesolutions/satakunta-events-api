package com.dymesolutions.common.interfaces

import spark.Request
import spark.Response

interface Controller {
    fun getById(req: Request, res: Response, manager: Boolean = false): Any
    fun getAll(req: Request, res: Response, manager: Boolean = false): Any
    fun add(req: Request, res: Response): Any
    fun update(req: Request, res: Response, manager: Boolean = false): Any
    fun delete(req: Request, res: Response, manager: Boolean = false): Any
}
