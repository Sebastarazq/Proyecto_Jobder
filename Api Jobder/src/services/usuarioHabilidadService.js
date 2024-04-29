import UsuarioHabilidad from '../models/UsuarioHabilidad.js';

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

export default {
    asociarHabilidadesUsuario,
    getHabilidadesUsuario,
    actualizarHabilidadesUsuario
};
  
