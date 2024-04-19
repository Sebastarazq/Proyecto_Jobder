import express from "express";
import userController from "../../controllers/userController.js";

const router = express.Router();

// Ruta para obtener todos los usuarios
router.get('/all',userController.getAllUsers);

router.get('/:id', userController.getUserById); // Ruta para obtener un usuario por su ID

// Ruta para registrar un nuevo usuario
router.post('/register', userController.registerUser);

router.post('/confirm/:token', userController.confirmUser); // Nueva ruta para confirmar usuario


export default router;