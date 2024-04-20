import Usuario from '../models/Usuario.js';
import { hashPassword, comparePasswords } from '../helpers/hash.js';
import { Op } from 'sequelize';

const getAllUsers = async () => {
  try {
    const users = await Usuario.findAll();
    return users;
  } catch (error) {
    throw error;
  }
};

// Servicio para obtener un usuario por su ID
const getUserById = async (userId) => {
  try {
    const user = await Usuario.findByPk(userId);
    return user;
  } catch (error) {
    throw error;
  }
};

const createUser = async (nombre, email, celular, password, edad, genero, categoria, descripcion, latitud, longitud, token) => {
  try {
    // Verificar si ya existe un usuario con el mismo correo electrónico o celular
    const existingUser = await Usuario.findOne({ where: { [Op.or]: [{ email }, { celular }] } });
    if (existingUser) {
      throw new Error('El correo electrónico o el número de celular ya están registrados');
    }

    // Encriptar la contraseña antes de guardarla en la base de datos
    const hashedPassword = await hashPassword(password);

    // Crear el nuevo usuario en la base de datos con la contraseña encriptada
    const newUser = await Usuario.create({
      nombre,
      email,
      celular,
      password: hashedPassword,
      edad,
      genero,
      categoria,
      descripcion,
      latitud,
      longitud,
      token
    });

    // Retornar el nuevo usuario creado
    return newUser;
  } catch (error) {
    throw error;
  }
};

const confirmUser = async (token) => {
  try {
    // Buscar usuario por token
    const user = await Usuario.findOne({ where: { token } });
    if (!user) {
      return null; // Usuario no encontrado
    }
    // Actualizar usuario
    await Usuario.update({ token: null, confirmado: true }, { where: { token } });
    return user;
  } catch (error) {
    throw error;
  }
};

const loginByEmail = async (email, password) => {
  try {
    const user = await Usuario.findOne({ 
      where: { email }, 
      attributes: ['usuario_id', 'nombre', 'password', 'confirmado'] // Ajusta 'id' por 'usuario_id'
    });
    if (!user) {
      throw new Error('La cuenta no existe');
    }
    const isValidPassword = await comparePasswords(password, user.password);
    if (!isValidPassword) {
      throw new Error('Credenciales inválidas');
    }
    if (!user.confirmado) {
      throw new Error('La cuenta no está confirmada');
    }
    // Devuelve solo las propiedades usuario_id y nombre del usuario
    return { usuario_id: user.usuario_id, nombre: user.nombre };
  } catch (error) {
    throw error;
  }
};

const loginByCellphone = async (celular, password) => {
  try {
    const user = await Usuario.findOne({ 
      where: { celular }, 
      attributes: ['usuario_id', 'nombre', 'password', 'confirmado'] // Ajusta 'id' por 'usuario_id'
    });
    if (!user) {
      throw new Error('La cuenta no existe');
    }
    const isValidPassword = await comparePasswords(password, user.password);
    if (!isValidPassword) {
      throw new Error('Credenciales inválidas');
    }
    if (!user.confirmado) {
      throw new Error('La cuenta no está confirmada');
    }
    // Devuelve solo las propiedades usuario_id y nombre del usuario
    return { usuario_id: user.usuario_id, nombre: user.nombre };
  } catch (error) {
    throw error;
  }
};

const updateUserPartialInfo = async (userId, updates) => {
  try {
    // Busca el usuario por su ID
    const user = await Usuario.findByPk(userId);
    if (!user) {
      throw new Error('Usuario no encontrado');
    }

    // Actualiza los campos proporcionados en el objeto "updates"
    Object.keys(updates).forEach((key) => {
      user[key] = updates[key];
    });

    await user.save();

    // Retorna el usuario actualizado
    return user;
  } catch (error) {
    throw error;
  }
};

export default {
  getAllUsers,
  getUserById,
  createUser,
  confirmUser,
  loginByEmail,
  loginByCellphone,
  updateUserPartialInfo
};
