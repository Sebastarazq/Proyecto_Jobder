import {RedSocial,UsuariosRedesSociales, Usuario} from '../models/index.js';

const getAllRedesSociales = async () => {
  try {
    const redesSociales = await RedSocial.findAll();
    return redesSociales;
  } catch (error) {
    throw error;
  }
};

const getRedesSocialesUsuario = async (usuarioId) => {
    try {
      const usuario = await Usuario.findByPk(usuarioId, {
        include: {
          model: RedSocial,
          attributes: ['red_id', 'nombre'], // Incluir tanto el ID como el nombre
          through: {
            model: UsuariosRedesSociales,
            attributes: ['nombre_usuario_aplicacion'],
          },
        },
      });
  
      if (!usuario) {
        throw new Error('El usuario no existe');
      }
  
      return usuario.RedesSociales; 
    } catch (error) {
      throw error;
    }
  };


  const actualizarRedesSociales = async (redesSociales) => {
    try {
      // Iterar sobre cada objeto de la lista de redes sociales
      for (const redSocial of redesSociales) {
        const { usuario_id, red_id, nombre_usuario_aplicacion } = redSocial;
  
        // Buscar si el usuario ya tiene asociada esta red social
        const redSocialExistente = await UsuariosRedesSociales.findOne({
          where: {
            usuario_id: usuario_id,
            red_id: red_id
          }
        });
  
        if (redSocialExistente) {
          // Si la red social ya existe, actualizar el nombre de usuario en la aplicación
          redSocialExistente.nombre_usuario_aplicacion = nombre_usuario_aplicacion;
          await redSocialExistente.save();
        } else {
          // Si la red social no existe, crear un nuevo registro
          await UsuariosRedesSociales.create({
            usuario_id: usuario_id,
            red_id: red_id,
            nombre_usuario_aplicacion: nombre_usuario_aplicacion
          });
        }
      }
  
      console.log('Redes sociales asociadas correctamente al usuario');
    } catch (error) {
      console.error('Error al asociar redes sociales al usuario:', error);
      throw new Error('Error al asociar redes sociales al usuario.');
    }
  };
  

export default {
  getAllRedesSociales,
  actualizarRedesSociales,
  getRedesSocialesUsuario
};