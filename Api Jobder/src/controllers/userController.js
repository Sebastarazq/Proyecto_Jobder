import validator from 'validator';
import userService from '../services/userService.js';
import { generaCodigo,generarJWT } from '../helpers/tokens.js';
import {emailRegistro, recuperacionPassword} from '../helpers/email.js';
import { hashPassword } from '../helpers/hash.js';

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
    if (error.message === 'El correo electrónico o el número de celular ya están registrados') {
      return res.status(400).json({ message: 'El correo electrónico o el número de celular ya están registrados' });
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

  const login = async (req, res) => {
    try {
      const { email, password, celular } = req.body;
      if ((!email && !celular) || !password) {
        return res.status(400).json({ message: 'Correo electrónico/celular y contraseña son obligatorios' });
      }
      let user;
      if (email) {
        user = await userService.loginByEmail(email, password);
      } else if (celular) {
        user = await userService.loginByCellphone(celular, password);
      }
      if (!user) {
        return res.status(401).json({ message: 'Correo electrónico/celular o contraseña incorrectos' });
      }
      
      // Ajusta el objeto que se pasa a generarJWT para contener solo el id y el nombre
      const datosParaToken = {
        id: user.usuario_id,
        nombre: user.nombre
      };
      
      // Genera el token utilizando los datos ajustados
      const token = generarJWT(datosParaToken);
      res.status(200).json({ token });
    } catch (error) {
      console.error(error);
      if (error.message === 'La cuenta no existe') {
        return res.status(401).json({ message: 'La cuenta no existe' });
      }
      if (error.message === 'La cuenta no está confirmada') {
        return res.status(401).json({ message: 'La cuenta no está confirmada' });
      }
      if (error.message === 'Credenciales inválidas') {
        return res.status(401).json({ message: 'Credenciales inválidas' });
      }
      res.status(500).json({ message: 'Error al iniciar sesión' });
    }
  };


  const updateUserPartialInfo = async (req, res) => {
    try {
      const userId = req.params.id;
      let updates = req.body; // Contiene los campos a actualizar
  
      // Verifica si hay una contraseña en las actualizaciones
      if ('password' in updates) {
        // Hashea la contraseña
        updates.password = await hashPassword(updates.password);
      }
  
      // Filtra los campos vacíos del objeto updates
      updates = Object.fromEntries(
        Object.entries(updates).filter(([key, value]) => value !== '')
      );
  
      // Validaciones para cada campo opcional si está presente en las actualizaciones
      if ('email' in updates && !validator.isEmail(updates.email)) {
        return res.status(400).json({ message: 'Formato de correo electrónico no válido' });
      }
  
      if ('edad' in updates) {
        const edadStr = String(updates.edad);
        if (!validator.isInt(edadStr, { min: 1, max: 150 })) {
          return res.status(400).json({ message: 'Edad no válida' });
        }
      }
  
      if ('genero' in updates && !['Masculino', 'Femenino', 'Otro'].includes(updates.genero)) {
        return res.status(400).json({ message: 'Género no válido' });
      }
  
      if ('categoria' in updates && !['Desarrollador', 'Empresario', 'Otro'].includes(updates.categoria)) {
        return res.status(400).json({ message: 'Categoría no válida' });
      }
  
      // Llama al servicio para actualizar parcialmente la información del usuario
      await userService.updateUserPartialInfo(userId, updates);
  
      res.status(200).json({ message: 'Información de usuario actualizada con éxito' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al actualizar la información del usuario' });
    }
  };

  const sendPasswordResetCode = async (req, res) => {
    try {
      const { email } = req.body;
  
      // Validar que se haya proporcionado un correo electrónico
      if (!email) {
        return res.status(400).json({ message: 'El correo electrónico es obligatorio' });
      }
  
      try {
        // Verificar si el usuario existe
        const user = await userService.getUserByEmail(email);
        // Verificar si el usuario está confirmado
        if (!user.confirmado) {
          return res.status(401).json({ message: 'El usuario no está confirmado' });
        }
  
        // Generar código de recuperación
        const resetCode = generaCodigo();
  
        // Guardar el código en la base de datos
        await userService.savePasswordResetCode(user.usuario_id, resetCode);
  
        // Enviar correo con el código de recuperación
        await recuperacionPassword({ email, nombre: user.nombre, resetCode });
  
        return res.status(200).json({ message: 'Código de recuperación de contraseña enviado con éxito' });
      } catch (error) {
        // Manejar errores específicos
        if (error.statusCode === 404) {
          // Usuario no encontrado
          return res.status(404).json({ message: 'Usuario no encontrado' });
        }
        console.error(error);
        return res.status(500).json({ message: 'Error interno del servidor' });
      }
    } catch (error) {
      console.error(error);
      return res.status(500).json({ message: 'Error interno del servidor' });
    }
  };

const resetPassword = async (req, res) => {
  try {
      const { token } = req.params; // Obtiene el token de la URL
      const { newPassword } = req.body; // Obtiene la nueva contraseña del cuerpo de la solicitud

      // Verifica que se haya proporcionado una nueva contraseña
      if (!newPassword) {
          return res.status(400).json({ message: 'La nueva contraseña es obligatoria' });
      }

      // Verifica si el token es válido y obtiene el ID de usuario asociado
      const userId = await userService.verifyResetCodeAndGetUserId(token);

      // Si no se encuentra ningún usuario con el token proporcionado
      if (!userId) {
          return res.status(404).json({ message: 'Token inválido o expirado' });
      }

      // Actualiza la contraseña del usuario en la base de datos
      await userService.updatePassword(userId, newPassword);

      // Envía una respuesta exitosa
      res.status(200).json({ message: 'Contraseña restablecida exitosamente' });
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al restablecer la contraseña' });
  }
};


  
  

  

export default {
  getAllUsers,
  getUserById,
  registerUser,
  confirmUser,
  login,
  updateUserPartialInfo,
  sendPasswordResetCode,
  resetPassword
};
