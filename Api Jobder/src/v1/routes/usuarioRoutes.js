import express from "express";
import userController from "../../controllers/userController.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/users/all:
 *   get:
 *     summary: Obtiene todos los usuarios.
 *     responses:
 *       200:
 *         description: Lista de usuarios obtenida con éxito.
 *       500:
 *         description: Error al obtener la lista de usuarios.
 */
// Ruta para obtener todos los usuarios
router.get('/all',userController.getAllUsers);

/**
 * @swagger
 * /api/v1/users/{id}:
 *   get:
 *     summary: Obtiene un usuario por su ID.
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID del usuario a obtener.
 *     responses:
 *       200:
 *         description: Usuario obtenido con éxito.
 *       400:
 *         description: ID de usuario no válido.
 *       404:
 *         description: Usuario no encontrado.
 */
router.get('/:id', userController.getUserById); // Ruta para obtener un usuario por su ID

/**
 * @swagger
 * /api/v1/users/register:
 *   post:
 *     summary: Registra un nuevo usuario.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nombre:
 *                 type: string
 *               email:
 *                 type: string
 *               celular:
 *                 type: number
 *               password:
 *                 type: string
 *               edad:
 *                 type: integer
 *               genero:
 *                 type: string
 *               foto_perfil:
 *                 type: string
 *               categoria:
 *                 type: string
 *               descripcion:
 *                 type: string
 *               latitud:
 *                 type: number
 *               longitud:
 *                 type: number
 *     responses:
 *       201:
 *         description: Usuario registrado con éxito.
 *       400:
 *         description: Error en los datos de entrada.
 *       500:
 *         description: Error al registrar el usuario.
 */
// Ruta para registrar un nuevo usuario
router.post('/register', userController.registerUser);

/**
 * @swagger
 * /api/v1/users/confirm/{token}:
 *   post:
 *     summary: Confirma un usuario mediante su token de confirmación.
 *     parameters:
 *       - in: path
 *         name: token
 *         schema:
 *           type: string
 *         required: true
 *         description: Token de confirmación del usuario.
 *     responses:
 *       200:
 *         description: Usuario confirmado con éxito.
 *       400:
 *         description: Token de confirmación inválido.
 *       404:
 *         description: Usuario no encontrado.
 */
router.post('/confirm/:token', userController.confirmUser); // Nueva ruta para confirmar usuario

/**
 * @swagger
 * /api/v1/users/login:
 *   post:
 *     summary: Inicia sesión de usuario.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: Correo electrónico del usuario (opcional si se proporciona "celular").
 *               password:
 *                 type: string
 *                 description: Contraseña del usuario.
 *               celular:
 *                 type: number
 *                 description: Número de celular del usuario (opcional si se proporciona "email").
 *             required:
 *               - password
 *           example:
 *             email: "ejemplo@correo.com //dejar en 0 si no se proporciona"
 *             password: "123456"
 *             celular: 0 // Dejar en 0 si no se proporciona
 *     responses:
 *       200:
 *         description: Inicio de sesión exitoso, token generado.
 *       400:
 *         description: Error en los datos de entrada.
 *       401:
 *         description: Credenciales inválidas o cuenta no confirmada.
 *       500:
 *         description: Error al iniciar sesión.
 */
router.post('/login', userController.login); // ruta para iniciar sesión

/**
 * @swagger
 * /api/v1/users/update/{id}:
 *   patch:
 *     summary: Actualiza parcialmente la información de un usuario.
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: integer
 *         required: true
 *         description: ID del usuario a actualizar.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               nombre:
 *                 type: string
 *                 description: Nuevo nombre del usuario.
 *                 example: Juan
 *               email:
 *                 type: string
 *                 description: Nuevo correo electrónico del usuario.
 *                 example: ejemplo@correo.com
 *               celular:
 *                 type: number
 *                 description: Nuevo número de celular del usuario.
 *                 example: 1234567890
 *               password:
 *                 type: string
 *                 description: Nueva contraseña del usuario.
 *                 example: newPassword123
 *               edad:
 *                 type: integer
 *                 description: Nueva edad del usuario.
 *                 example: 30
 *               genero:
 *                 type: string
 *                 description: Nuevo género del usuario.
 *                 example: Masculino
 *               foto_perfil:
 *                 type: string
 *                 description: Nueva foto de perfil del usuario.
 *                 example: URL de la nueva foto de perfil
 *               categoria:
 *                 type: string
 *                 description: Nueva categoría del usuario.
 *                 example: Desarrollador
 *               descripcion:
 *                 type: string
 *                 description: Nueva descripción del usuario.
 *                 example: Descripción actualizada
 *               latitud:
 *                 type: number
 *                 description: Nueva latitud del usuario.
 *                 example: 40.7128
 *               longitud:
 *                 type: number
 *                 description: Nueva longitud del usuario.
 *                 example: -74.0060
 *           required:
 *             - id
 *           example:
 *             nombre: Juan
 *             email: ejemplo@correo.com
 *             celular: 0
 *             password: newPassword123
 *             edad: 30
 *             genero: Masculino
 *             foto_perfil: URL de la nueva foto de perfil
 *             categoria: Desarrollador
 *             descripcion: Descripción actualizada
 *             latitud: 40.7128
 *             longitud: -74.0060
 *     responses:
 *       200:
 *         description: Información de usuario actualizada con éxito.
 *       400:
 *         description: Error en los datos de entrada.
 *       404:
 *         description: Usuario no encontrado.
 *       500:
 *         description: Error al actualizar la información del usuario.
 */
router.patch('/update/:id', userController.updateUserPartialInfo); // Ruta para actualizar parcialmente la información del usuario

/**
 * @swagger
 * /api/v1/users/forgot-password:
 *   post:
 *     summary: Envía un código de recuperación de contraseña al correo electrónico del usuario.
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 description: Correo electrónico del usuario para enviar el código de recuperación.
 *             required:
 *               - email
 *           example:
 *             email: ejemplo@correo.com
 *     responses:
 *       200:
 *         description: Código de recuperación de contraseña enviado con éxito.
 *       400:
 *         description: Error en los datos de entrada.
 *       404:
 *         description: Usuario no encontrado.
 *       500:
 *         description: Error al enviar el correo de recuperación de contraseña.
 */
router.post('/forgot-password', userController.sendPasswordResetCode); // Ruta para enviar código de recuperación de contraseña

/**
 * @swagger
 * openapi: "3.0.0"
 * info:
 *   title: API de Restablecimiento de Contraseña
 *   version: "1.0.0"
 * paths:
 *   /api/v1/users/password/reset/confirm/{token}:
 *     post:
 *       summary: Restablecer contraseña con código de recuperación.
 *       parameters:
 *         - in: path
 *           name: token
 *           required: true
 *           schema:
 *             type: string
 *           description: Código de recuperación de contraseña.
 *       requestBody:
 *         required: true
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 newPassword:
 *                   type: string
 *               required:
 *                 - newPassword
 *             example:
 *               newPassword: nuevaContraseña123
 *       responses:
 *         200:
 *           description: Contraseña restablecida con éxito.
 *         400:
 *           description: Error de solicitud, por ejemplo, falta el cuerpo de la solicitud.
 *         401:
 *           description: Token de recuperación de contraseña inválido.
 *         404:
 *           description: Usuario no encontrado.
 *         500:
 *           description: Error interno del servidor.
 */
// Ruta para restablecer la contraseña utilizando el código de recuperación
router.post('/password/reset/confirm/:token', userController.resetPassword);

// Ruta para obtener la información del usuario por token
router.post('/infouser/token', userController.obtenerInfoUsuarioPorToken);





export default router;