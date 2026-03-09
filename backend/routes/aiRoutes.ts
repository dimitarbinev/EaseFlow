import Router from 'express'
import { getAiResponse } from '../controllers/aiController'


const router = Router();

router.post('/response', getAiResponse);

export default router;