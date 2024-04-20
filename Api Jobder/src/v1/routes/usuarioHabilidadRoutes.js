// Importa los módulos necesarios
import express from 'express';
import usuarioHabilidadController from '../../controllers/usuarioHabilidadController.js';

// Crea una instancia del enrutador de Express
const router = express.Router();

// Ruta para asociar habilidades a un usuario
router.post('/asociar', usuarioHabilidadController.asociarHabilidadesUsuario);

// Exporta el router
export default router;
