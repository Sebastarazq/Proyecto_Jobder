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
        // Obtener el ID del usuario del cuerpo de la solicitud
        const usuarioId = req.body.usuario_id;
        console.log('usuarioId:', usuarioId);

        // Verificar si usuarioId está vacío
        if (!usuarioId) {
            return res.status(400).json({ message: 'El ID de usuario no puede estar vacío' });
        }

        // Obtener habilidades del cuerpo de la solicitud
        const { habilidades } = req.body;
        console.log('habilidades:', habilidades);

        // Verificar si habilidades está vacío o no es un array
        if (!habilidades || !Array.isArray(habilidades) || habilidades.length === 0) {
            return res.status(400).json({ message: 'Las habilidades deben ser un array no vacío' });
        }

        // Procesar la solicitud para asociar habilidades al usuario
        await usuarioHabilidadService.asociarHabilidadesUsuario(usuarioId, habilidades);
        
        // Responder con éxito
        res.status(201).json({ message: 'Habilidades asociadas correctamente al usuario' });
    } catch (error) {
        console.error(error);
        // Manejar errores internos del servidor
        res.status(500).json({ message: 'Error al asociar habilidades al usuario' });
    }
};



export default {
    asociarHabilidadesUsuario,
    asociarHabilidadesUsuario2
};
