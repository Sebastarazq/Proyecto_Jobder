import { exit } from 'node:process';
import habilidades from '../seed/habilidades.js';
import redesSociales from '../seed/redesSociales.js';
import db from '../database/db.js';
import { Habilidad, RedSocial } from '../models/index.js';

const importarDatos = async () => {
  try {
    await db.authenticate();
    await db.sync();

    // Verificar si la tabla Habilidades ya tiene registros
    const numRegistros = await Habilidad.count();
    if (numRegistros > 0) {
      console.log('La tabla Habilidades ya contiene registros, no se insertarán datos.');
      exit(0);
    }

    // Insertar habilidades
    await Habilidad.bulkCreate(habilidades);
    console.log('Habilidades importadas correctamente');

    // Insertar redes sociales
    await RedSocial.bulkCreate(redesSociales);
    console.log('Redes sociales importadas correctamente');

    exit(0);
  } catch (error) {
    console.log(error);
    exit(1);
  }
};

const eliminarDatos = async () => {
  try {
    await db.sync({ force: true });
    console.log('Datos eliminados correctamente');
    exit(0);
  } catch (error) {
    console.log(error);
    exit(1);
  }
};

if (process.argv[2] === "-i") {
  importarDatos();
} else if (process.argv[2] === "-e") {
  eliminarDatos();
}