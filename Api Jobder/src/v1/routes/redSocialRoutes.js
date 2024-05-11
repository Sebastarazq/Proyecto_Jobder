import express from 'express';
import redesSocialesController from '../../controllers/redesSocialesController.js';

const router = express.Router();

/**
 * @swagger
 * /api/v1/redes/all:
 *   get:
 *     summary: Obtener todas las redes sociales.
 *     description: Obtiene la lista de todas las redes sociales disponibles.
 *     responses:
 *       '200':
 *         description: Redes sociales obtenidas correctamente.
 *       '500':
 *         description: Error al obtener las redes sociales.
 */
router.get('/all', redesSocialesController.getAllRedesSociales); // Ruta para obtener todas las redes sociales

/**
 * @swagger
 * /api/v1/redes/asociar:
 *   post:
 *     summary: Asociar redes sociales a un usuario.
 *     description: Asocia las redes sociales proporcionadas al usuario.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: array
 *             items:
 *               type: object
 *               properties:
 *                 usuario_id:
 *                   type: string
 *                 red_id:
 *                   type: string
 *                 nombre_usuario_aplicacion:
 *                   type: string
 *     responses:
 *       '201':
 *         description: Redes sociales asociadas correctamente al usuario.
 *       '400':
 *         description: Datos incorrectos proporcionados.
 *       '500':
 *         description: Error al asociar redes sociales al usuario.
 */
router.post('/asociar', redesSocialesController.asociarRedesSociales); // Ruta para asociar una red social a un usuario

/**
 * @swagger
 * /api/v1/redes/{usuarioId}:
 *   get:
 *     summary: Obtener las redes sociales de un usuario específico.
 *     description: Obtiene la lista de redes sociales asociadas a un usuario.
 *     parameters:
 *       - in: path
 *         name: usuarioId
 *         required: true
 *         description: ID del usuario.
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: Redes sociales obtenidas correctamente.
 *       '500':
 *         description: Error al obtener las redes sociales del usuario.
 */
router.get('/:usuarioId', redesSocialesController.getRedesSocialesUsuario); // Ruta para obtener las redes sociales de un usuario específico

/**
 * @swagger
 * /api/v1/redes/vinculadas/{usuarioId}:
 *   post:
 *     summary: Obtener todas las redes sociales de un usuario específico.
 *     description: Obtiene todas las redes sociales vinculadas a un usuario.
 *     parameters:
 *       - in: path
 *         name: usuarioId
 *         required: true
 *         description: ID del usuario.
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: Redes sociales obtenidas correctamente.
 *       '404':
 *         description: Usuario no encontrado o sin redes sociales asociadas.
 *       '500':
 *         description: Error al obtener las redes sociales del usuario.
 */
router.post('/vinculadas/:usuarioId', redesSocialesController.obtenerTodasLasRedesUsuarioRedes); // Ruta para obtener todas las redes sociales de un usuario específico

/**
 * @swagger
 * /api/v1/redes/desvincular/{redId}:
 *   delete:
 *     summary: Eliminar una red social por su ID.
 *     description: Elimina una red social específica del sistema.
 *     parameters:
 *       - in: path
 *         name: redId
 *         required: true
 *         description: ID de la red social.
 *         schema:
 *           type: string
 *     responses:
 *       '200':
 *         description: Red social eliminada correctamente.
 *       '400':
 *         description: ID de red social no proporcionado.
 *       '404':
 *         description: La red social no existe.
 *       '500':
 *         description: Error al eliminar la red social.
 */
router.delete('/desvincular/:redId', redesSocialesController.eliminarRedSocial); // Ruta para eliminar una red social por su ID




export default router;
