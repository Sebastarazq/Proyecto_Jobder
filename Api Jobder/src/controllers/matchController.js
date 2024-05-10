import matchService from '../services/matchService.js';
import { generaCodigo,generarJWT,decodificarJWT,generarJWTlargo,verificarJWT } from '../helpers/tokens.js';

// Controlador para obtener usuarios cercanos
const getUsuariosCercanos = async(req, res) => {
    try {
      // Verificar si el usuario está autenticado y obtener su ID
      const usuarioId = req.body.usuario_id;
      if (!usuarioId) {
        return res.status(400).json({ error: 'ID de usuario no proporcionado' });
      }
      
      // Llamar al servicio para encontrar usuarios cercanos
      const usuariosCercanos = await matchService.encontrarUsuariosCercanos(usuarioId);
      
      // Enviar la respuesta con los usuarios cercanos
      res.status(200).json({ usuariosCercanos });
    } catch (error) {
      console.error('Error al obtener usuarios cercanos:', error);
      res.status(500).json({ error: 'Error al obtener usuarios cercanos' });
    }
}
// Controlador para obtener usuarios por categorias
const getUsuariosCategorias = async(req, res) => {
    try {
      // Verificar si el usuario está autenticado y obtener su ID
      const usuarioId = req.body.usuario_id;
      if (!usuarioId) {
        return res.status(400).json({ error: 'ID de usuario no proporcionado' });
      }
      
      // Llamar al servicio para encontrar usuarios cercanos
      const usuariosCercanos = await matchService.encontrarUsuariosPorCategorias(usuarioId);
      
      // Enviar la respuesta con los usuarios cercanos
      res.status(200).json({ usuariosCercanos });
    } catch (error) {
      console.error('Error al obtener usuarios por categoria:', error);
      res.status(500).json({ error: 'Error al obtener usuarios por categoria' });
    }
}

const getMatches = async (req, res) => {
  try {
    // Verificar si se proporcionó el token en el cuerpo de la solicitud
    const token = req.body.token;
    if (!token) {
      return res.status(400).json({ error: 'Token de autenticación no proporcionado' });
    }

    // Verificar la fecha de expiración del token
    let decoded;
    try {
      decoded = decodificarJWT(token);
    } catch (error) {
      // Si hay un error al decodificar el token (incluido el caso de expiración), retornar un error
      return res.status(401).json({ error: 'Token de autenticación inválido o expirado' });
    }

    // Obtener el ID de usuario del cuerpo de la solicitud
    const usuarioId = req.body.usuario_id;
    if (!usuarioId) {
      return res.status(400).json({ error: 'ID de usuario no proporcionado' });
    }

    // Llamar al servicio para obtener los matches del usuario
    const matches = await matchService.obtenerMatches(usuarioId);

    if (matches.length === 0) {
      return res.status(404).json({ message: 'No tienes matches' });
    }

    // Enviar la respuesta con los matches
    res.status(200).json({ matches });
  } catch (error) {
    console.error('Error al obtener matches del usuario:', error);
    res.status(500).json({ error: 'Error al obtener matches del usuario' });
  }
};

const getMatchesCompletados = async (req, res) => {
  try {
    // Verificar si el usuario está autenticado y obtener su ID
    const usuarioId = req.body.usuario_id;
    if (!usuarioId) {
      return res.status(400).json({ error: 'ID de usuario no proporcionado' });
    }

    // Llamar al servicio para obtener los matches completados
    const matchesCompletados = await matchService.obtenerMatchesCompletados(usuarioId);
    
    // Verificar si no hay matches completados
    if (matchesCompletados.length === 0) {
      return res.status(404).json({ message: 'No tienes matches completados' });
    }

    // Enviar la respuesta con los matches completados
    res.status(200).json({ matchesCompletados });
  } catch (error) {
    console.error('Error al obtener matches completados:', error);
    res.status(500).json({ error: 'Error al obtener matches completados' });
  }
}

const crearMatch = async (req, res) => {
  try {
    const { usuarioId1, usuarioId2, visto1 } = req.body;

    // Verificar si los IDs de usuario y el visto2 están presentes
    if (!usuarioId1 || !usuarioId2 || visto1 === undefined) {
      return res.status(400).json({ error: 'Datos incompletos para crear un match' });
    }

    // Crear el match en la base de datos
    const matchCreado = await matchService.crearMatch(usuarioId1, usuarioId2, visto1);
    console.log('matchCreado:', matchCreado);

    // Si llega aquí, el match se creó correctamente
    return res.status(201).json({ message: 'Match creado exitosamente' });

  } catch (error) {
    // Capturar los errores específicos y enviar mensajes adecuados
    if (error.message === 'Uno o ambos usuarios no existen') {
      return res.status(404).json({ error: error.message });
    } else if (error.message === 'Ya existe un match entre estos usuarios') {
      return res.status(400).json({ error: error.message });
    } else {
      console.error('Error al crear match:', error);
      return res.status(500).json({ error: 'Error al crear match' });
    }
  }
};

const aprobarMatch = async (req, res) => {
  try {
    // Obtener el ID del match a aprobar desde los parámetros de la solicitud
    const matchId = req.body.match_id;

    // Verificar si el ID del match está presente
    if (!matchId) {
      return res.status(400).json({ error: 'ID de match no proporcionado' });
    }

    // Llamar al servicio para aprobar el match
    const matchAprobado = await matchService.aprobarMatch(matchId);

    if (matchAprobado) {
      // Si el match se aprobó correctamente
      return res.status(200).json({ message: 'Match aprobado exitosamente' });
    } else {
      // Si el match no existe
      return res.status(404).json({ error: 'El match no existe' });
    }
  } catch (error) {
    console.error('Error al aprobar match:', error);
    res.status(500).json({ error: 'Error al aprobar match' });
  }
};

const denegarMatch = async (req, res) => {
  try {
    // Obtener el ID del match a denegar desde los parámetros de la solicitud
    const matchId = req.body.match_id;

    // Verificar si el ID del match está presente
    if (!matchId) {
      return res.status(400).json({ error: 'ID de match no proporcionado' });
    }

    // Llamar al servicio para denegar el match
    const matchDenegado = await matchService.denegarMatch(matchId);

    if (matchDenegado) {
      // Si el match se denegó correctamente
      return res.status(200).json({ message: 'Match denegado exitosamente' });
    } else {
      // Si el match no existe
      return res.status(404).json({ error: 'El match no existe' });
    }
  } catch (error) {
    console.error('Error al denegar match:', error);
    res.status(500).json({ error: 'Error al denegar match' });
  }
};



export default {
    getUsuariosCercanos,
    getUsuariosCategorias,
    getMatches,
    getMatchesCompletados,
    crearMatch,
    aprobarMatch,
    denegarMatch

};