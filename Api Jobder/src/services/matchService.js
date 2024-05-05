import { Usuario, Match, Habilidad,RedSocial, UsuariosRedesSociales } from '../models/index.js';
import UsuarioHabilidad from '../models/UsuarioHabilidad.js';
import { Op } from 'sequelize';

const encontrarUsuariosCercanos = async (usuarioId) => {
    try {
        // Verificar si el usuario existe
        const usuario = await Usuario.findByPk(usuarioId);
        if (!usuario) {
            throw new Error('El usuario no existe');
        }
        
        // Verificar si el usuario tiene una ubicación válida
        if (!usuario.latitud || !usuario.longitud) {
            throw new Error('El usuario no tiene una ubicación válida');
        }
    
        // Definir la distancia máxima para considerar dos usuarios como cercanos (en kilómetros)
        const distanciaMaxima = 10; // Por ejemplo, 10 kilómetros
    
        // Buscar otros usuarios que estén dentro de la distancia máxima y que no tengan un match previo con el usuario actual
        const usuariosCercanos = await Usuario.findAll({
            where: {
                usuario_id: { [Op.ne]: usuarioId }, // Excluir al propio usuario
                latitud: { [Op.not]: null }, // Asegurarse de que tengan una ubicación válida
                longitud: { [Op.not]: null },
                latitud: {
                    [Op.or]: [
                        { [Op.gte]: usuario.latitud - (distanciaMaxima / 110.574) },
                        { [Op.eq]: null }
                    ]
                },
                longitud: {
                    [Op.or]: [
                        { [Op.gte]: usuario.longitud - (distanciaMaxima / (111.32 * Math.cos(usuario.latitud * Math.PI / 180))) },
                        { [Op.eq]: null }
                    ]
                }
            },
            include: [
                {
                    model: Habilidad, // Incluir el modelo de Habilidad
                    through: { attributes: [] }, // Excluir los atributos adicionales de la tabla de unión
                    required: true // Asegurar que el usuario tenga al menos una habilidad asociada
                },
                {
                    model: Match,
                    as: 'Matches2',
                    where: {
                        [Op.or]: [
                            { usuario1_id: usuarioId },
                            { usuario2_id: usuarioId }
                        ],
                        [Op.or]: [
                            { visto1: false },
                            { visto2: false }
                        ]
                    },
                    required: false // Permite que la consulta retorne usuarios incluso si no hay match
                }
            ]
        });

        // Filtrar los usuarios cercanos para eliminar aquellos con Matches2 con vistos true
        const usuariosSinVistosTrue = usuariosCercanos.filter(usuarioCercano => {
            return usuarioCercano.Matches2.every(match => !match.visto1 && !match.visto2);
        });
    
        return usuariosSinVistosTrue;
    } catch (error) {
        console.error('Error al encontrar usuarios cercanos:', error);
        throw error;
    }
};

const encontrarUsuariosPorCategorias = async (usuarioId) => {
    try {
        // Verificar si el usuario existe
        const usuario = await Usuario.findByPk(usuarioId);
        if (!usuario) {
            throw new Error('El usuario no existe');
        }
        
        // Definir la categoría opuesta a la del usuario actual
        let categoriaOpuesta;
        if (usuario.categoria === 'Empresario') {
            categoriaOpuesta = 'Desarrollador';
        } else if (usuario.categoria === 'Desarrollador') {
            categoriaOpuesta = 'Empresario';
        } else {
            throw new Error('Categoría de usuario no válida');
        }
    
        // Buscar otros usuarios de la categoría opuesta que no tengan un match previo con el usuario actual
        const usuariosPorCategorias = await Usuario.findAll({
            where: {
                usuario_id: { [Op.ne]: usuarioId }, // Excluir al propio usuario
                categoria: categoriaOpuesta // Filtrar por la categoría opuesta
            },
            include: [
                {
                    model: Habilidad,
                    through: { attributes: [] },
                    required: true
                },
                {
                    model: Match,
                    as: 'Matches2',
                    where: {
                        [Op.or]: [
                            { usuario1_id: usuarioId },
                            { usuario2_id: usuarioId }
                        ],
                        [Op.or]: [
                            { visto1: false },
                            { visto2: false }
                        ]
                    },
                    required: false
                }
            ]
        });

        // Filtrar los usuarios por categorías para eliminar aquellos con Matches2 con vistos true
        const usuariosSinVistosTrue = usuariosPorCategorias.filter(usuarioCercano => {
            return usuarioCercano.Matches2.every(match => !match.visto1 && !match.visto2);
        });
    
        return usuariosSinVistosTrue;
    } catch (error) {
        console.error('Error al encontrar usuarios por categorías:', error);
        throw error;
    }
};


const obtenerMatches = async (usuarioId) => {
    try {
        // Verificar si el usuario existe
        const usuario = await Usuario.findByPk(usuarioId);
        if (!usuario) {
            throw new Error('El usuario no existe');
        }

        // Obtener los matches en los que el usuario es el usuario1
        const matches = await Match.findAll({
            where: {
                usuario1_id: usuarioId,
                visto2: true, // Verificar si el usuario2 ha marcado el match como visto
                visto1: {
                    [Op.or]: [false, null] // Verificar si el usuario1 no ha marcado el match como visto o si es nulo
                }
            }
        });

        // Obtener los ids de los usuarios2 de los matches encontrados
        const usuarios2Ids = matches.map(match => match.usuario2_id);

        // Obtener la información del usuario2 y del match
        const [usuarios2, matchesConUsuarios] = await Promise.all([
            Usuario.findAll({
                where: {
                    usuario_id: usuarios2Ids // Filtrar por los ids de los usuarios2
                }
            }),
            Promise.all(matches.map(async (match) => {
                const usuario2 = await Usuario.findByPk(match.usuario2_id);
                return { match, usuario2 };
            }))
        ]);

        // Combinar la información del usuario2 y del match en un solo objeto
        const matchesConInfo = matchesConUsuarios.map((data) => {
            return {
                match: data.match,
                usuario2: data.usuario2
            };
        });

        return matchesConInfo;
    } catch (error) {
        console.error('Error al obtener matches:', error);
        throw error;
    }
};

const obtenerMatchesCompletados = async (usuarioId) => {
    try {
      // Obtener los matches completados donde el usuario ha marcado el match como visto
      const matchesCompletados = await Match.findAll({
        where: {
          usuario1_id: usuarioId,
          visto1: true,
          visto2: true
        }
      });
  
      console.log('Matches completados:', matchesCompletados);
  
      // Obtener los IDs de los usuarios 2 asociados a cada match completado
      const usuarios2Ids = matchesCompletados.map(match => match.usuario2_id);
      
      // Obtener la información de los usuarios 2
      const usuarios = await Usuario.findAll({
        where: {
          usuario_id: usuarios2Ids
        }
      });
  
      console.log('Usuarios correspondientes a los matches completados:', usuarios);
  
      // Combinar la información de los usuarios y los matches completados en un solo objeto
      const matchesCompletadosConUsuarios = matchesCompletados.map(match => {
        const usuario = usuarios.find(usuario => usuario.usuario_id === match.usuario2_id);
        return {
          match,
          usuario
        };
      });
  
      console.log('Matches completados con usuarios:', matchesCompletadosConUsuarios);
  
      return matchesCompletadosConUsuarios;
    } catch (error) {
      console.error('Error al obtener matches completados:', error);
      throw error;
    }
  };
  const crearMatch = async (usuarioId1, usuarioId2, visto2) => {
    try {
      // Verificar si los usuarios existen
      const [usuario1, usuario2] = await Promise.all([
        Usuario.findByPk(usuarioId1),
        Usuario.findByPk(usuarioId2)
      ]);
  
      if (!usuario1 || !usuario2) {
        throw new Error('Uno o ambos usuarios no existen');
      }
  
      // Verificar si ya existe un match entre los usuarios
      const existeMatch = await Match.findOne({
        where: {
          usuario1_id: usuarioId1,
          usuario2_id: usuarioId2
        }
      });
  
      if (existeMatch) {
        throw new Error('Ya existe un match entre estos usuarios');
      }
  
      // Crear el nuevo match en la base de datos
      await Match.create({
        usuario1_id: usuarioId1,
        usuario2_id: usuarioId2,
        visto2: visto2
      });
  
      return true; // Indicar que el match fue creado exitosamente
    } catch (error) {
      console.error('Error al crear match:', error);
      throw error; // Propagar el error para manejarlo en el controlador
    }
  };

  const aprobarMatch = async (matchId) => {
    try {
      // Obtener el match por su ID
      const match = await Match.findByPk(matchId);
  
      // Verificar si el match existe
      if (!match) {
        return false; // El match no existe
      }
  
      // Actualizar el campo visto1 a true
      await match.update({ visto1: true });
  
      // Si llega aquí, el match se actualizó correctamente
      return true;
    } catch (error) {
      console.error('Error al aprobar match:', error);
      throw error; // Propagar el error para manejarlo en el controlador
    }
  };
  
  const denegarMatch = async (matchId) => {
    try {
      // Obtener el match por su ID
      const match = await Match.findByPk(matchId);
  
      // Verificar si el match existe
      if (!match) {
        return false; // El match no existe
      }
  
      // Eliminar el match de la base de datos
      await match.destroy();
  
      // Si llega aquí, el match se eliminó correctamente
      return true;
    } catch (error) {
      console.error('Error al denegar match:', error);
      throw error; // Propagar el error para manejarlo en el controlador
    }
  };
  
export default {
    encontrarUsuariosCercanos,
    encontrarUsuariosPorCategorias,
    obtenerMatches,
    obtenerMatchesCompletados,
    crearMatch,
    aprobarMatch,
    denegarMatch
};