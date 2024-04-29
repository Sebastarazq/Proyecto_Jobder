// index.js
import Usuario from './Usuario.js';
import Habilidad from './Habilidad.js';
import Match from './Match.js';
//import db from '../database/db.js'; // Asegúrate de importar la instancia de la base de datos

// Define las relaciones entre los modelos
Usuario.belongsToMany(Habilidad, { through: 'Usuarios_habilidades', foreignKey: 'usuario_id' });
Habilidad.belongsToMany(Usuario, { through: 'Usuarios_habilidades', foreignKey: 'habilidad_id' });

Usuario.hasMany(Match, { foreignKey: 'usuario1_id', as: 'Matches1' });
Usuario.hasMany(Match, { foreignKey: 'usuario2_id', as: 'Matches2' });
export {
    Usuario,
    Habilidad,
    Match
};
