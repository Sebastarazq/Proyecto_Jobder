import { Usuario, Match, Habilidad,RedSocial, UsuariosRedesSociales } from '../models/index.js';
import UsuarioHabilidad from '../models/UsuarioHabilidad.js';
import { Op,Sequelize } from 'sequelize';

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

    // Obtener los IDs de los usuarios con los que se ha creado un match
    const matches = await Match.findAll({
      where: {
        [Op.or]: [
          { usuario1_id: usuarioId },
          { usuario2_id: usuarioId }
        ]
      },
      raw: true, // Agregar esta opción para obtener los resultados como objetos simples
    });

    const usuariosConMatchIds = matches.map(match => {
      if (match.usuario1_id === usuarioId) {
        return match.usuario2_id;
      } else {
        return match.usuario1_id;
      }
    });

    // Buscar otros usuarios que estén dentro de la distancia máxima y que no tengan un match previo con el usuario actual
    const usuariosCercanos = await Usuario.findAll({
      where: {
        usuario_id: { 
          [Op.ne]: usuarioId, // Excluir al propio usuario
          [Op.notIn]: usuariosConMatchIds // Excluir a los usuarios con los que se ha creado un match
        },
        latitud: { [Op.not]: null }, // Asegurarse de que la latitud no sea nula
        longitud: { [Op.not]: null },
        [Op.or]: [
          { latitud: { [Op.gte]: usuario.latitud - (distanciaMaxima / 110.574) } },
          { latitud: { [Op.eq]: null } }
        ],
        [Op.or]: [
          { longitud: { [Op.gte]: usuario.longitud - (distanciaMaxima / (111.32 * Math.cos(usuario.latitud * Math.PI / 180))) } },
          { longitud: { [Op.eq]: null } }
        ]
      },
      include: [
        {
          model: Habilidad, // Incluir el modelo de Habilidad
          through: { attributes: [] }, // Excluir los atributos adicionales de la tabla de unión
          required: true // Asegurar que el usuario tenga al menos una habilidad asociada
        }
      ]
    });

    return usuariosCercanos;
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
    
    let usuariosPorCategorias;
    console.log('Categoría del usuario:', usuario.categoria);
    // Si el usuario actual es un desarrollador, mostrar solo desarrolladores
    if (usuario.categoria === 'Desarrollador') {
      usuariosPorCategorias = await Usuario.findAll({
        where: {
          usuario_id: { [Op.ne]: usuarioId }, // Excluir al propio usuario
          categoria: 'Desarrollador' // Filtrar solo por desarrolladores
        },
        include: [
          {
            model: Habilidad,
            through: { attributes: [] },
            required: true
          },
          {
            model: Match,
            as: 'Matches1', // Asigna un alias a la asociación con Match
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
    }
    // Si el usuario actual es un empresario, mostrar tanto desarrolladores como empresarios
    else if (usuario.categoria === 'Empresario') {
      usuariosPorCategorias = await Usuario.findAll({
        where: {
          usuario_id: { [Op.ne]: usuarioId }, // Excluir al propio usuario
          categoria: { [Op.or]: ['Desarrollador', 'Empresario'] } // Filtrar por desarrolladores y empresarios
        },
        include: [
          {
            model: Habilidad,
            through: { attributes: [] },
            required: true
          },
          {
            model: Match,
            as: 'Matches2', // Asigna un alias a la asociación con Match
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
    } else {
      throw new Error('Categoría de usuario no válida');
    }

    // Filtrar los usuarios para eliminar aquellos con Matches con vistos true
const usuariosSinVistosTrue = usuariosPorCategorias.filter(usuarioCercano => {
  return !usuarioCercano.Matches1.some(match => match.visto1 || match.visto2);
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

    // Obtener los matches en los que el usuario es el usuario2 y no ha marcado el match como visto
    const matches = await Match.findAll({
      where: {
        usuario2_id: usuarioId, // Buscar los matches donde el usuario es el usuario2
        visto1: true, // Verificar si el usuario1 ha marcado el match como visto
    visto2: {
      [Op.not]: true // Verificar que visto2 no sea true
    },
    // Agregar la condición para excluir los matches en los que el usuario2 sea el mismo que el creado_por
    [Op.not]: [{ creado_por: usuarioId }]
  }
    });

    // Obtener los ids de los usuarios1 de los matches encontrados
    const usuarios1Ids = matches.map(match => match.usuario1_id);

    // Obtener la información del usuario1
    const usuarios1 = await Usuario.findAll({
      where: {
        usuario_id: usuarios1Ids // Filtrar por los ids de los usuarios1
      }
    });

    // Combinar la información del usuario1 y del match en un solo objeto
    const matchesConInfo = matches.map((match) => {
      const usuario1 = usuarios1.find(usuario => usuario.usuario_id === match.usuario1_id);
      return { match, usuario1 };
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
        [Op.or]: [
          { usuario1_id: usuarioId },
          { usuario2_id: usuarioId }
        ],
        visto1: true,
        visto2: true
      }
    });
    console.log('usuarioId:', usuarioId)
    console.log('Matches completados:', matchesCompletados);

    const matchesCompletadosConUsuarios = [];

    for (const match of matchesCompletados) {
      let usuario1;
      if (match.usuario1_id === usuarioId) {
        usuario1 = await Usuario.findByPk(match.usuario2_id);
      } else {
        usuario1 = await Usuario.findByPk(match.usuario1_id);
      }

      if (usuario1) {
        matchesCompletadosConUsuarios.push({
          match,
          usuario1
        });
      }
    }

    console.log('Matches completados con usuarios:', matchesCompletadosConUsuarios);

    return matchesCompletadosConUsuarios;
  } catch (error) {
    console.error('Error al obtener matches completados:', error);
    throw error;
  }
};
const crearMatch = async (usuarioId1, usuarioId2, visto1) => {
  try {
    // Verificar si los usuarios existen
    const [usuario1, usuario2] = await Promise.all([
      Usuario.findByPk(usuarioId1),
      Usuario.findByPk(usuarioId2)
    ]);

    if (!usuario1 || !usuario2) {
      throw new Error('Uno o ambos usuarios no existen');
    }

    // Verificar si ya existe un match entre los usuarios (en cualquier dirección)
    const existeMatch = await Match.findOne({
      where: {
        [Op.or]: [
          {
            usuario1_id: usuarioId1,
            usuario2_id: usuarioId2,
          },
          {
            usuario1_id: usuarioId2,
            usuario2_id: usuarioId1,
          }
        ]
      }
    });

    if (existeMatch) {
      throw new Error('Ya existe un match entre estos usuarios');
    }

    // Crear el nuevo match en la base de datos
    await Match.create({
      usuario1_id: usuarioId1,
      usuario2_id: usuarioId2,
      visto1: visto1,
      creado_por: usuarioId1 // Asignar el usuarioId1 al campo creado_por
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
      await match.update({ visto2: true });
  
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