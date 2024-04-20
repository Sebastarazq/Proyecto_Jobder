import { DataTypes } from 'sequelize';
import db from '../database/db.js';

const Habilidad = db.define('Habilidades', {
  habilidad_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  nombre: {
    type: DataTypes.STRING,
    allowNull: false
  }
}, {
  timestamps: false
});

export default Habilidad;
