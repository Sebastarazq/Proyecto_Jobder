import express from "express";
import habilidadController from "../../controllers/habilidadController.js";


const router = express.Router();

router.get('/all', habilidadController.getAllHabilidades); // Ruta para obtener todas las habilidades



export default router;