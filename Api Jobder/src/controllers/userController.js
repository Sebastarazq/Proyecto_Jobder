import validator from 'validator';
import userService from '../services/userService.js';
import { generaCodigo } from '../helpers/tokens.js';
import emailRegistro from '../helpers/email.js';

const getAllUsers = async (req, res) => {
  try {
    const users = await userService.getAllUsers();
    res.status(200).json(users);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al obtener usuarios' });
  }
};

// Controlador para obtener un usuario por su ID
const getUserById = async (req, res) => {
    try {
      const userId = req.params.id; // Obtener el ID del parámetro de la URL
      const user = await userService.getUserById(userId); // Llamar al servicio para obtener el usuario
      if (!user) {
        return res.status(404).json({ message: 'Usuario no encontrado' });
      }
      res.status(200).json(user);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener usuario por ID' });
    }
  };

const registerUser = async (req, res) => {
  try {
    const { nombre, email, celular, password, edad, genero, categoria, descripcion, latitud, longitud } = req.body;

    if (!nombre || !email || !celular || !password || !edad || !genero || !categoria) {
      return res.status(400).json({ message: 'Todos los campos son obligatorios' });
    }

    if (!validator.isEmail(email)) {
      return res.status(400).json({ message: 'Formato de correo electrónico no válido' });
    }

    const edadStr = String(edad);
    if (!validator.isInt(edadStr, { min: 1, max: 150 })) {
      return res.status(400).json({ message: 'Edad no válida' });
    }

    if (!['Masculino', 'Femenino', 'Otro'].includes(genero)) {
      return res.status(400).json({ message: 'Género no válido' });
    }

    if (!['Desarrollador', 'Empresario', 'Otro'].includes(categoria)) {
      return res.status(400).json({ message: 'Categoría no válida' });
    }

    // Generar el código de token
    const token = generaCodigo();

    // Llamar al servicio para crear el usuario con el token generado
    await userService.createUser(nombre, email, celular, password, edad, genero, categoria, descripcion, latitud, longitud, token);

    // Enviar el correo de confirmación
    await emailRegistro({ nombre, email, token });

    res.status(201).json({ message: 'Usuario creado exitosamente' });
  } catch (error) {
    console.error(error);
    if (error.message === 'El correo electrónico ya está registrado') {
      return res.status(400).json({ message: 'El correo electrónico ya está registrado' });
    }
    res.status(500).json({ message: 'Error al registrar usuario' });
  }
};

const confirmUser = async (req, res) => {
    try {
      const token = req.params.token;
  
      // Validar token
      if (!token || !validator.isAlphanumeric(token) || token.length !== 5) {
        return res.status(400).json({ message: 'Código de confirmación no válido' });
      }
  
      // Llamar al servicio para confirmar el usuario
      const confirmedUser = await userService.confirmUser(token);
  
      if (!confirmedUser) {
        return res.status(404).json({ message: 'Usuario no encontrado o token inválido' });
      }
  
      res.status(200).json({ message: 'Usuario confirmado exitosamente' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al confirmar usuario' });
    }
  };
  

export default {
  getAllUsers,
  getUserById,
  registerUser,
  confirmUser,
};
