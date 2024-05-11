import express from "express";
import habilidadController from "../../controllers/habilidadController.js";


const router = express.Router();

/**
 * @swagger
 * /api/v1/habilidades/all:
 *   get:
 *     summary: Obtener todas las habilidades.
 *     description: Obtiene la lista de todas las habilidades disponibles.
 *     responses:
 *       '200':
 *         description: Habilidades obtenidas correctamente.
 *       '500':
 *         description: Error interno del servidor.
 */
router.get('/all', habilidadController.getAllHabilidades); // Ruta para obtener todas las habilidades



export default router;