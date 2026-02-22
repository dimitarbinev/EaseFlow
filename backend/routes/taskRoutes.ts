import {Router} from 'express'
import { createTask, addSteps, getTasks} from '../controllers/taskController'
import {verifyToken} from '../middleware/middleware'

const router = Router()

router.post('/', verifyToken, createTask)

router.post('/:taskId/steps', addSteps)

router.get('/child/:childUid', verifyToken, getTasks)

export default router
