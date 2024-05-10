import express from 'express';
import matchController from '../../controllers/matchController.js';


const router = express.Router();

router.post('/ubicacion', matchController.getUsuariosCercanos); // obtener usuarios cercanos
router.post('/categorias', matchController.getUsuariosCategorias); // obtener usuarios cercanos
router.post('/matches', matchController.getMatches); // obtener matches de un usuario
router.post('/matches-completados', matchController.getMatchesCompletados); // obtener matches completados de un usuario
router.post('/crear-match', matchController.crearMatch); // crear un match
router.post('/aprobar-match', matchController.aprobarMatch); // Aprobar un match
router.post('/denegar-match', matchController.denegarMatch); // Denegar un match






export default router;