import { DataTypes } from 'sequelize';
import db from '../database/db.js';

const RedSocial = db.define('RedesSociales', {
  red_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  nombre: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  }
}, {
  timestamps: false
});

export default RedSocial;