import validator from 'validator';
import userService from '../services/userService.js';
import { generaCodigo,generarJWT,decodificarJWT,generarJWTlargo } from '../helpers/tokens.js';
import {emailRegistro, recuperacionPassword, notificarCambioContraseña} from '../helpers/email.js';
import { hashPassword } from '../helpers/hash.js';
import multer from 'multer';

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
      //console.log(user);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener usuario por ID' });
    }
  };
  // Controlador para obtener la información de un usuario por su token
  const obtenerInfoUsuarioPorToken = async (req, res) => {
    try {
        const token = req.body.token; // Obtener el token del cuerpo de la solicitud
        console.log('token:', token);
        
        if (!token) {
            return res.status(400).json({ message: 'Token no proporcionado' });
        }
        
        let decodedToken;
        try {
            decodedToken = decodificarJWT(token); // Decodificar el token
        } catch (error) {
            return res.status(401).json({ message: 'Token inválido' });
        }
        
        console.log('decoded:', decodedToken);
        
        const usuarioId = decodedToken.id; // Obtener el ID del usuario del token decodificado
        console.log('usuarioId:', usuarioId);
        
        const userInfo = await userService.obtenerInfoUsuario(usuarioId);
        
        res.status(200).json(userInfo);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener la información del usuario' });
    }
};

const registerUser = async (req, res) => {
  try {
    const { nombre, email, celular, password, edad, genero, categoria, descripcion, latitud, longitud } = req.body;

    console.log(req.body);

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

      console.log(token)
  
      // Validar token
      if (!token || !validator.isAlphanumeric(token) || token.length !== 5) {
        return res.status(400).json({ message: 'Código de confirmación no válido' });
      }
  
      // Llamar al servicio para confirmar el usuario
      const confirmedUser = await userService.confirmUser(token);
  
      if (!confirmedUser) {
        return res.status(404).json({ message: 'Usuario no encontrado o token inválido'});
      }

      let devolverId = confirmedUser.usuario_id;
  
      res.status(200).json({ message: 'Usuario confirmado exitosamente', devolverId});
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
        email: user.email
      };
      const usuario_id = user.usuario_id;
      
      // Genera el token utilizando los datos ajustados
      const token = generarJWT(datosParaToken);
      res.status(200).json({ token,usuario_id });
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
  const loginVerificarHuella = async (req, res) => {
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
        email: user.email
      };
      const usuario_id = user.usuario_id;
      
      // Genera el token utilizando los datos ajustados
      const token = generarJWTlargo(datosParaToken);
      console.log('token largo de huella digital',token)
      res.status(200).json({ token,usuario_id });
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

  const loginHuella = async (req, res) => {
    try {
      const token = req.params.token; // Recibe el token de la URL
  
      // Verificar si el token está presente en la URL
      if (!token) {
        throw new Error("Token no proporcionado en la URL");
      }
      console.log('Token de huella digital:', token);
  
      // Decodificar el token
      const decodedToken = decodificarJWT(token);
  
      // Verificar si el token es válido
      if (!decodedToken) {
        throw new Error("Token inválido");
      }
  
      // Extraer el id del usuario del token decodificado
      const { id } = decodedToken;
  
      // Buscar el usuario por su ID utilizando el servicio
      const userInfo = await userService.getUserById(id);
      if (!userInfo) {
        throw new Error('El usuario con el ID proporcionado no existe');
      }
  
      // Ajustar el objeto que se pasa a generarJWT para contener solo el id y el nombre
      const datosParaToken = {
        id: userInfo.id,
        email: userInfo.email
      };
  
      // Generar un nuevo token con el ID y el correo electrónico del usuario
      const nuevoToken = generarJWT(datosParaToken);
      console.log('Inicio de sesión con huella digital exitoso');
      console.log('Nuevo token generado:', nuevoToken);
  
      // Devolver el nuevo token en la respuesta
      res.status(200).json({ message: "Token válido", token: nuevoToken, usuario_id: id });
    } catch (error) {
      res.status(400).json({ message: "Error al verificar el token", error: error.message });
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

        // Notificar al usuario sobre el cambio de contraseña
        const user = await userService.getUserById(userId);
        await notificarCambioContraseña({ email: user.email, nombre: user.nombre });

        // Envía una respuesta exitosa
        res.status(200).json({ message: 'Contraseña restablecida exitosamente' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al restablecer la contraseña' });
    }
};

// Controlador para subir la imagen de perfil y guardar el enlace en la base de datos
const uploadImage = async (req, res) => {
  try {
    // Verifica si se cargó una imagen
    if (!req.file) {
      return res.status(400).json({ message: 'No se proporcionó ninguna imagen' });
    }

    console.log(req.file);

    // Guarda la URL de la imagen en la base de datos
    const imageUrl = `https://api-appjobder.azurewebsites.net/uploads/${req.file.filename}`;

    // Obtén el ID de usuario de los parámetros de la URL
    const userId = req.params.id;

    // Llama al servicio para actualizar la URL de la imagen de perfil del usuario en la base de datos
    await userService.updateProfileImage(userId, imageUrl);

    res.status(200).json({ message: 'Imagen de perfil subida exitosamente' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al subir la imagen de perfil' });
  }
};

  

export default {
  getAllUsers,
  getUserById,
  obtenerInfoUsuarioPorToken,
  registerUser,
  confirmUser,
  login,
  updateUserPartialInfo,
  sendPasswordResetCode,
  resetPassword,
  uploadImage,
  loginVerificarHuella,
  loginHuella
};
