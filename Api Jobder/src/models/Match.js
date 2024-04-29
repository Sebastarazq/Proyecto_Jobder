import { DataTypes } from 'sequelize';
import db from '../database/db.js';

const Match = db.define('Matches', {
  match_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  usuario1_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  usuario2_id: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  visto1: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  visto2: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  fecha_match: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
},{
    timestamps: false
});

export default Match;
