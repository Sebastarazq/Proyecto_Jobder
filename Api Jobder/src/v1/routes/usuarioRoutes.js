import express from "express";
import userController from "../../controllers/userController.js";

const router = express.Router();

// Ruta para obtener todos los usuarios
router.get('/all',userController.getAllUsers);

// Ruta para registrar un nuevo usuario
router.post('/register', userController.registerUser);


export default router;