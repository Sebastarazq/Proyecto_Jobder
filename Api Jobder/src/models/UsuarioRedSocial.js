import { DataTypes } from 'sequelize';
import db from '../database/db.js';

const UsuariosRedesSociales = db.define('Usuarios_Redessociales', {
  usuario_red_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  usuario_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  red_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  nombre_usuario_aplicacion: {
    type: DataTypes.STRING,
    allowNull: false
  }
}, {
  timestamps: false
});

export default UsuariosRedesSociales;
