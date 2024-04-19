import Usuario from '../models/Usuario.js';

const getAllUsers = async () => {
  try {
    const users = await Usuario.findAll();
    return users;
  } catch (error) {
    throw error;
  }
};

const createUser = async (nombre, email, celular, password, edad, genero, categoria, descripcion, latitud, longitud) => {
  try {
    // Verificar si ya existe un usuario con el mismo correo electrónico
    const existingUser = await Usuario.findOne({ where: { email } });
    if (existingUser) {
      throw new Error('El correo electrónico ya está registrado');
    }

    // Crear el nuevo usuario en la base de datos
    const newUser = await Usuario.create({
      nombre,
      email,
      celular,
      password,
      edad,
      genero,
      categoria,
      descripcion,
      latitud,
      longitud
    });

    // Retornar el nuevo usuario creado
    return newUser;
  } catch (error) {
    // Propagar cualquier error que ocurra al crear el usuario
    throw error;
  }
};

export default {
  getAllUsers,
  createUser
};
