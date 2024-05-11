import express from 'express';
import redesSocialesController from '../../controllers/redesSocialesController.js';

const router = express.Router();

router.get('/all', redesSocialesController.getAllRedesSociales); // Ruta para obtener todas las redes sociales
router.post('/asociar', redesSocialesController.asociarRedesSociales); // Ruta para asociar una red social a un usuario
router.get('/:usuarioId', redesSocialesController.getRedesSocialesUsuario); // Ruta para obtener las redes sociales de un usuario específico
router.post('/vinculadas/:usuarioId', redesSocialesController.obtenerTodasLasRedesUsuarioRedes); // Ruta para obtener todas las redes sociales de un usuario específico
router.delete('/desvincular/:redId', redesSocialesController.eliminarRedSocial); // Ruta para eliminar una red social por su ID



export default router;
