import Usuario from '../models/Usuario.js';
import { hashPassword, comparePasswords } from '../helpers/hash.js';
import { Op } from 'sequelize';
import { generarJWT } from '../helpers/tokens.js';

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

const obtenerInfoUsuario = async (usuarioId) => {
  try {
      const userInfo = await Usuario.findByPk(usuarioId);
      if (!userInfo) {
          throw new Error('Usuario no encontrado');
      }
      return userInfo;
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
      attributes: ['usuario_id', 'nombre', 'password', 'confirmado', 'email'] // Ajusta 'id' por 'usuario_id'
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
    return { usuario_id: user.usuario_id, email: user.email };
  } catch (error) {
    throw error;
  }
};

const loginByCellphone = async (celular, password) => {
  try {
    const user = await Usuario.findOne({ 
      where: { celular }, 
      attributes: ['usuario_id', 'nombre', 'password', 'confirmado', 'email'] // Ajusta 'id' por 'usuario_id'
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
    return { usuario_id: user.usuario_id, email: user.email };
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

const getUserByEmail = async (email) => {
  try {
    const user = await Usuario.findOne({ where: { email } });
    if (!user || user.email !== email) {
      console.log('No se encontró ningún usuario con el correo electrónico proporcionado:', email);
      const error = new Error('Usuario no encontrado con el correo electrónico proporcionado');
      error.statusCode = 404; // Código de estado HTTP 404 para "No encontrado"
      throw error;
    }
    return user;
  } catch (error) {
    throw error; // Reenviar el error para ser manejado en el controlador
  }
};

const savePasswordResetCode = async (userId, resetCode) => {
  try {
    const user = await Usuario.findByPk(userId);
    if (!user) {
      const error = new Error('Usuario no encontrado');
      error.statusCode = 404; // Código de estado HTTP 404 para "No encontrado"
      throw error;
    }
    user.token = resetCode;
    await user.save();
    return resetCode;
  } catch (error) {
    throw error; // Reenviar el error para ser manejado en el controlador
  }
};

const verifyResetCodeAndGetUserId = async (token) => {
  try {
      // Busca un usuario con el token de restablecimiento proporcionado
      const user = await Usuario.findOne({ where: { token } });

      // Si no se encuentra ningún usuario con el token proporcionado
      if (!user) {
          return null;
      }

      // Devuelve el ID de usuario asociado al token
      return user.usuario_id;
  } catch (error) {
      throw error;
  }
};

const updatePassword = async (userId, newPassword) => {
  try {
      // Busca el usuario por su ID
      const user = await Usuario.findByPk(userId);

      // Si no se encuentra el usuario
      if (!user) {
          throw new Error('Usuario no encontrado');
      }

      // Hash de la nueva contraseña
      const hashedPassword = await hashPassword(newPassword);

      // Actualiza la contraseña del usuario con el hash
      user.password = hashedPassword;

      // Limpia el campo de token de restablecimiento
      user.token = null;

      // Guarda los cambios en la base de datos
      await user.save();
  } catch (error) {
      throw error;
  }
};

const updateProfileImage = async (userId, imageUrl) => {
  try {
    // Busca el usuario por su ID
    const user = await Usuario.findByPk(userId);
    if (!user) {
      throw new Error('Usuario no encontrado');
    }

    // Actualiza la URL de la imagen de perfil del usuario
    user.foto_perfil = imageUrl;

    console.log('user:', user);

    // Guarda los cambios en la base de datos
    await user.save();

    // Retorna el usuario actualizado
    return user;
  } catch (error) {
    throw error;
  }
};

const verificarUsuarioYGenerarToken = async (userId) => {
  try {
    // Buscar el usuario por su ID
    const user = await Usuario.findByPk(userId);
    if (!user) {
      throw new Error('El usuario con el ID proporcionado no existe');
    }

    // Devolver la información del usuario
    return user;
  } catch (error) {
    throw error;
  }
};



export default {
  getAllUsers,
  getUserById,
  obtenerInfoUsuario,
  createUser,
  confirmUser,
  loginByEmail,
  loginByCellphone,
  updateUserPartialInfo,
  getUserByEmail,
  savePasswordResetCode,
  verifyResetCodeAndGetUserId,
  updatePassword,
  updateProfileImage,
  verificarUsuarioYGenerarToken
};
