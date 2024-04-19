import Usuario from '../models/Usuario.js';
import hashPassword from '../helpers/hash.js';

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
      const user = await Usuario.findByPk(userId); // Buscar el usuario por su ID en la base de datos
      return user;
    } catch (error) {
      throw error;
    }
  };

const createUser = async (nombre, email, celular, password, edad, genero, categoria, descripcion, latitud, longitud,token) => {
  try {
    // Verificar si ya existe un usuario con el mismo correo electrónico
    const existingUser = await Usuario.findOne({ where: { email } });
    if (existingUser) {
      throw new Error('El correo electrónico ya está registrado');
    }

    // Encriptar la contraseña antes de guardarla en la base de datos
    const hashedPassword = await hashPassword.hashPassword(password);

    // Crear el nuevo usuario en la base de datos con la contraseña encriptada
    const newUser = await Usuario.create({
      nombre,
      email,
      celular,
      password: hashedPassword, // Guardar la contraseña encriptada
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
    // Propagar cualquier error que ocurra al crear el usuario
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
  

export default {
  getAllUsers,
  getUserById,
  createUser,
  confirmUser,
};
