import express from 'express';
import matchController from '../../controllers/matchController.js';


const router = express.Router();

router.post('/ubicacion', matchController.getUsuariosCercanos);



export default router;