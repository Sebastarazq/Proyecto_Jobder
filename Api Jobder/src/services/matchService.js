import { Usuario, Match, Habilidad } from '../models/index.js';
import { Op } from 'sequelize';

// Función para encontrar usuarios cercanos basados en la ubicación del usuario actual
const encontrarUsuariosCercanos = async (usuarioId) => {
    try {
        // Verificar si el usuario existe
        const usuario = await Usuario.findOne({ where: { usuario_id: usuarioId } });
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
                        [Op.or]: [
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
                        [Op.or]: [
                            { visto1: false },
                            { visto2: false }
                        ]
                    },
                    required: false // Permite que la consulta retorne usuarios incluso si no hay match
                }
            ]
        });
    
        return usuariosCercanos;
    } catch (error) {
        console.error('Error al encontrar usuarios cercanos:', error);
        throw error;
    }
};


export default {
    encontrarUsuariosCercanos
};