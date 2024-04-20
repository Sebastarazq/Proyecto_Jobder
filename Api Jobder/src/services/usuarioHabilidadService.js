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
  
export default {
    asociarHabilidadesUsuario
};
  
