import express from 'express';
import matchController from '../../controllers/matchController.js';


const router = express.Router();

router.post('/ubicacion', matchController.getUsuariosCercanos); // obtener usuarios cercanos
router.post('/matches', matchController.getMatches); // obtener matches de un usuario




export default router;