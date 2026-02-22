import {Router} from 'express'
import { createTask, addSteps, getTaskForChild} from '../controllers/taskController'

const router = Router()

router.post('/', createTask)

router.post('/:taskId/steps', addSteps)

router.get('/:childUid', getTaskForChild)

export default router
