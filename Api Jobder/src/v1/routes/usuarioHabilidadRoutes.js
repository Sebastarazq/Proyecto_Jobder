// Importa los módulos necesarios
import express from 'express';
import usuarioHabilidadController from '../../controllers/usuarioHabilidadController.js';

// Crea una instancia del enrutador de Express
const router = express.Router();

// Ruta para asociar habilidades a un usuario
/**
 * @swagger
 * /usuario-habilidad/asociar:
 *   post:
 *     summary: Asociar habilidades a un usuario.
 *     description: Asocia las habilidades proporcionadas al usuario autenticado mediante el token.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               token:
 *                 type: string
 *               habilidades:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       '201':
 *         description: Habilidades asociadas correctamente al usuario.
 *       '400':
 *         description: Token no proporcionado.
 *       '401':
 *         description: Token inválido.
 *       '500':
 *         description: Error al asociar habilidades al usuario.
 */
router.post('/asociar', usuarioHabilidadController.asociarHabilidadesUsuario);

// Nueva ruta para asociar habilidades a un usuario con usuario_id
/**
 * @swagger
 * /usuario-habilidad/asociar2:
 *   post:
 *     summary: Asociar habilidades a un usuario con usuario_id.
 *     description: Asocia las habilidades proporcionadas al usuario especificado por usuario_id.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               usuario_id:
 *                 type: string
 *               habilidades:
 *                 type: array
 *                 items:
 *                   type: string
 *     responses:
 *       '201':
 *         description: Habilidades asociadas correctamente al usuario.
 *       '500':
 *         description: Error al asociar habilidades al usuario.
 */
router.post('/asociar2', usuarioHabilidadController.asociarHabilidadesUsuario2); // Ruta para asociar habilidades a un usuario por usuario_id

// Ruta para obtener la información de Usuarios Habilidades
router.get('/:usuarioId', usuarioHabilidadController.getHabilidadesUsuario);

// Ruta para actualizar las habilidades del usuario
router.post('/actualizar', usuarioHabilidadController.actualizarHabilidadesUsuario);

router.post('/habilidades/:usuarioId', usuarioHabilidadController.getHabilidadesUsuarioHabilidad);

// Exporta el router
export default router;
