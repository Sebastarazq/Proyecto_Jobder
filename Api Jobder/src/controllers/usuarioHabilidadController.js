import usuarioHabilidadService from '../services/usuarioHabilidadService.js';
import { decodificarJWT } from '../helpers/tokens.js';

const asociarHabilidadesUsuario = async (req, res) => {
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

        const { habilidades } = req.body;
        console.log('habilidades:', habilidades);

        await usuarioHabilidadService.asociarHabilidadesUsuario(usuarioId, habilidades);
        
        res.status(201).json({ message: 'Habilidades asociadas correctamente al usuario' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al asociar habilidades al usuario' });
    }
};

    const asociarHabilidadesUsuario2 = async (req, res) => {
        try {
            const usuarioId = req.body.usuario_id; // Obtener el ID del usuario del cuerpo de la solicitud
            console.log('usuarioId:', usuarioId);

            const { habilidades } = req.body;
            console.log('habilidades:', habilidades);

            await usuarioHabilidadService.asociarHabilidadesUsuario(usuarioId, habilidades);
            
            res.status(201).json({ message: 'Habilidades asociadas correctamente al usuario' });
        } catch (error) {
            console.error(error);
            res.status(500).json({ message: 'Error al asociar habilidades al usuario' });
        }
    };


export default {
    asociarHabilidadesUsuario,
    asociarHabilidadesUsuario2
};
