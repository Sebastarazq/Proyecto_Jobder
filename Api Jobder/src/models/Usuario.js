import { DataTypes } from 'sequelize';
import db from '../database/db.js';

const Usuario = db.define('Usuarios', {
  usuario_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  nombre: {
    type: DataTypes.STRING,
    allowNull: false
  },
  email: {
    type: DataTypes.STRING,
    allowNull: false
  },
  celular: {
    type: DataTypes.BIGINT,
    allowNull: false
  },
  password: {
    type: DataTypes.STRING,
    allowNull: false
  },
  edad: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  genero: {
    type: DataTypes.STRING,
    allowNull: false
  },
  foto_perfil: {
    type: DataTypes.STRING,
    allowNull: true
  },
  categoria: {
    type: DataTypes.STRING,
    allowNull: false
  },
  descripcion: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  latitud: {
    type: DataTypes.DECIMAL(10, 8),
    allowNull: true
  },
  longitud: {
    type: DataTypes.DECIMAL(11, 8),
    allowNull: true
  },
  token: {
    type: DataTypes.STRING,
    allowNull: true
  },
  confirmado: {
    type: DataTypes.BOOLEAN,
    allowNull: false,
    defaultValue: false
  }
}, {
  timestamps: false,
  defaultScope: {
    attributes: { exclude: ['password'] } // Excluir el campo de contraseña en las consultas por defecto
  }
});

export default Usuario;
