import UsuarioHabilidad from '../models/UsuarioHabilidad.js';
import { Usuario, Match, Habilidad,RedSocial, UsuariosRedesSociales } from '../models/index.js';

const asociarHabilidadesUsuario = async (usuarioId, habilidades) => {
    try {
      const usuarioHabilidades = habilidades.map(habilidadId => ({
        usuario_id: usuarioId,
        habilidad_id: habilidadId
      }));
      await UsuarioHabilidad.bulkCreate(usuarioHabilidades);
    } catch (error) {
      throw error;
    }
  };

  const getHabilidadesUsuario = async (usuarioId) => {
    try {
        const habilidades = await UsuarioHabilidad.findAll({
            where: { usuario_id: usuarioId }
        });
        return habilidades;
    } catch (error) {
        throw error;
    }
};

const actualizarHabilidadesUsuario = async (usuarioId, nuevasHabilidades) => {
  try {
    // Eliminar todas las habilidades anteriores del usuario
    console.log('Eliminando habilidades anteriores del usuario...');
    const eliminacion = await UsuarioHabilidad.destroy({ where: { usuario_id: usuarioId } });
    console.log(`${eliminacion} habilidades eliminadas.`);

    // Asociar las nuevas habilidades al usuario
    console.log('Asociando nuevas habilidades al usuario...');
    const usuarioHabilidades = nuevasHabilidades.map(habilidadId => ({
      usuario_id: usuarioId,
      habilidad_id: habilidadId
    }));
    console.log('Nuevas habilidades a asociar:', usuarioHabilidades);
    await UsuarioHabilidad.bulkCreate(usuarioHabilidades);
    console.log('Nuevas habilidades asociadas correctamente.');
  } catch (error) {
    console.error('Error al actualizar las habilidades del usuario:', error);
    throw new Error('Error al actualizar las habilidades del usuario.');
  }
};

const getHabilidadesUsuarioHabilidad = async (usuarioId) => {
  try {
    // Consulta para obtener las habilidades del usuario por su ID
    const habilidadesUsuario = await UsuarioHabilidad.findAll({
      where: { usuario_id: usuarioId }
    });

    // Obtener los IDs de las habilidades del usuario
    const habilidadesIds = habilidadesUsuario.map(habilidad => habilidad.habilidad_id);

    // Consulta para obtener los nombres de las habilidades utilizando los IDs obtenidos
    const habilidadesNombres = await Habilidad.findAll({
      where: { habilidad_id: habilidadesIds }
    });

    // Combinar la información de las habilidades del usuario y los nombres de las habilidades
    const habilidades = habilidadesUsuario.map(habilidadUsuario => {
      const habilidadNombre = habilidadesNombres.find(habilidad => habilidad.habilidad_id === habilidadUsuario.habilidad_id);
      return {
        relacion_id: habilidadUsuario.relacion_id,
        usuario_id: habilidadUsuario.usuario_id,
        habilidad_id: habilidadUsuario.habilidad_id,
        nombre: habilidadNombre.nombre
      };
    });

    // Devolver el objeto con la información combinada
    return { habilidades };
  } catch (error) {
    throw error;
  }
};

export default {
    asociarHabilidadesUsuario,
    getHabilidadesUsuario,
    actualizarHabilidadesUsuario,
    getHabilidadesUsuarioHabilidad
};
  
