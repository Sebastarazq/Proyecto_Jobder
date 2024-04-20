// index.js
import Usuario from './Usuario.js';
import Habilidad from './Habilidad.js';
//import db from '../database/db.js'; // Asegúrate de importar la instancia de la base de datos

// Define las relaciones entre los modelos
Usuario.belongsToMany(Habilidad, { through: 'UsuarioHabilidad', foreignKey: 'usuario_id' });
Habilidad.belongsToMany(Usuario, { through: 'UsuarioHabilidad', foreignKey: 'habilidad_id' });

export {
    Usuario,
    Habilidad,
};
