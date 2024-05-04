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
        // También se verifica que ambos usuarios no hayan marcado el match como visto
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
                    as: 'Matches1',
                    where: {
                        [Op.or]: [
                            { usuario1_id: usuarioId },
                            { usuario2_id: usuarioId }
                        ],
                        [Op.and]: [
                            { visto1: false },
                            { visto2: false }
                        ]
                    },
                    required: false // Permite que la consulta retorne usuarios incluso si no hay match
                },
                {
                    model: Match,
                    as: 'Matches2',
                    where: {
                        [Op.or]: [
                            { usuario1_id: usuarioId },
                            { usuario2_id: usuarioId }
                        ],
                        [Op.and]: [
                            { visto1: false },
                            { visto2: false }
                        ]
                    },
                    required: false // Permite que la consulta retorne usuarios incluso si no hay match
                }
            ]
        });

        // Filtrar los usuarios cercanos que no tienen un match mutuo
        const usuariosSinMatchMutuo = usuariosCercanos.filter(usuarioCercano => {
            return !(usuarioCercano.Matches1.length > 0 && usuarioCercano.Matches2.length > 0);
        });
    
        return usuariosSinMatchMutuo;
    } catch (error) {
        console.error('Error al encontrar usuarios cercanos:', error);
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


export default {
    encontrarUsuariosCercanos,
    obtenerMatches
};