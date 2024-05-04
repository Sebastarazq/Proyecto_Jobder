// services/habilidadService.js

import {Habilidad} from '../models/index.js';

const getAllHabilidades = async () => {
  try {
    const habilidades = await Habilidad.findAll();
    return habilidades;
  } catch (error) {
    throw error;
  }
};

export default {
  getAllHabilidades
};
