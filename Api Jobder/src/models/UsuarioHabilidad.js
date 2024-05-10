import { DataTypes } from 'sequelize';
import db from '../database/db.js'; // Asegúrate de importar la instancia de la base de datos

const UsuarioHabilidad = db.define('Usuarios_habilidades', {
  relacion_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  usuario_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  habilidad_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  timestamps: false
});

export default UsuarioHabilidad;
