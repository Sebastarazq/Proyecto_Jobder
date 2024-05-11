import express from 'express';
import matchController from '../../controllers/matchController.js';


const router = express.Router();

/**
 * @swagger
 * /api/v1/match/ubicacion:
 *   post:
 *     summary: Obtener usuarios cercanos.
 *     description: Obtiene una lista de usuarios cercanos a un usuario dado su ID.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               usuario_id:
 *                 type: string
 *                 description: ID del usuario.
 *     responses:
 *       '200':
 *         description: Operación exitosa. Devuelve una lista de usuarios cercanos.
 *       '400':
 *         description: Error en los datos proporcionados.
 *       '500':
 *         description: Error interno del servidor.
 */
router.post('/ubicacion', matchController.getUsuariosCercanos); // obtener usuarios cercanos

/**
 * @swagger
 * /api/v1/match/categorias:
 *   post:
 *     summary: Obtener usuarios por categorías.
 *     description: Obtiene una lista de usuarios por categorías a las que pertenece un usuario dado su ID.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               usuario_id:
 *                 type: string
 *                 description: ID del usuario.
 *     responses:
 *       '200':
 *         description: Operación exitosa. Devuelve una lista de usuarios por categorías.
 *       '400':
 *         description: Error en los datos proporcionados.
 *       '500':
 *         description: Error interno del servidor.
 */
router.post('/categorias', matchController.getUsuariosCategorias); // obtener usuarios cercanos

/**
 * @swagger
 * /api/v1/match/matches:
 *   post:
 *     summary: Obtener matches de un usuario.
 *     description: Obtiene una lista de matches de un usuario dado su ID.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               token:
 *                 type: string
 *                 description: Token de autenticación del usuario.
 *               usuario_id:
 *                 type: string
 *                 description: ID del usuario.
 *     responses:
 *       '200':
 *         description: Operación exitosa. Devuelve una lista de matches.
 *       '400':
 *         description: Error en los datos proporcionados.
 *       '401':
 *         description: No autorizado, token inválido o expirado.
 *       '404':
 *         description: No se encontraron matches para el usuario.
 *       '500':
 *         description: Error interno del servidor.
 */
router.post('/matches', matchController.getMatches); // obtener matches de un usuario

/**
 * @swagger
 * /api/v1/match/matches-completados:
 *   post:
 *     summary: Obtener matches completados de un usuario.
 *     description: Obtiene una lista de matches completados de un usuario dado su ID.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               usuario_id:
 *                 type: string
 *                 description: ID del usuario.
 *     responses:
 *       '200':
 *         description: Operación exitosa. Devuelve una lista de matches completados.
 *       '400':
 *         description: Error en los datos proporcionados.
 *       '404':
 *         description: No se encontraron matches completados para el usuario.
 *       '500':
 *         description: Error interno del servidor.
 */
router.post('/matches-completados', matchController.getMatchesCompletados); // obtener matches completados de un usuario

/**
 * @swagger
 * /api/v1/match/crear-match:
 *   post:
 *     summary: Crear un match.
 *     description: Crea un nuevo match entre dos usuarios dados sus IDs.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               usuarioId1:
 *                 type: string
 *                 description: ID del primer usuario.
 *               usuarioId2:
 *                 type: string
 *                 description: ID del segundo usuario.
 *               visto1:
 *                 type: boolean
 *                 description: Estado de visibilidad del match para el primer usuario.
 *     responses:
 *       '201':
 *         description: Operación exitosa. El match se creó correctamente.
 *       '400':
 *         description: Error en los datos proporcionados.
 *       '404':
 *         description: Uno o ambos usuarios no existen.
 *       '500':
 *         description: Error interno del servidor.
 */
router.post('/crear-match', matchController.crearMatch); // crear un match

/**
 * @swagger
 * /api/v1/match/aprobar-match:
 *   post:
 *     summary: Aprobar un match.
 *     description: Aprueba un match existente dado su ID.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               match_id:
 *                 type: string
 *                 description: ID del match.
 *     responses:
 *       '200':
 *         description: Operación exitosa. El match se aprobó correctamente.
 *       '400':
 *         description: Error en los datos proporcionados.
 *       '404':
 *         description: El match no existe.
 *       '500':
 *         description: Error interno del servidor.
 */
router.post('/aprobar-match', matchController.aprobarMatch); // Aprobar un match

/**
 * @swagger
 * /api/v1/match/denegar-match:
 *   post:
 *     summary: Denegar un match.
 *     description: Deniega un match existente dado su ID.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               match_id:
 *                 type: string
 *                 description: ID del match.
 *     responses:
 *       '200':
 *         description: Operación exitosa. El match se denegó correctamente.
 *       '400':
 *         description: Error en los datos proporcionados.
 *       '404':
 *         description: El match no existe.
 *       '500':
 *         description: Error interno del servidor.
 */
router.post('/denegar-match', matchController.denegarMatch); // Denegar un match






export default router;