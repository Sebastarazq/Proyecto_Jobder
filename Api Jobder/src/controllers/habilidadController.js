// controllers/habilidadController.js

import habilidadService from '../services/habilidadService.js';

const getAllHabilidades = async (req, res) => {
  try {
    const habilidades = await habilidadService.getAllHabilidades();
    res.status(200).json(habilidades);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al obtener habilidades' });
  }
};

export default {
  getAllHabilidades
};
