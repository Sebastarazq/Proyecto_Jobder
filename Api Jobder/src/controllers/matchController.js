import matchService from '../services/matchService.js';

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
      console.log('usuariosCercanos:', usuariosCercanos);
      
      // Enviar la respuesta con los usuarios cercanos
      res.status(200).json({ usuariosCercanos });
    } catch (error) {
      console.error('Error al obtener usuarios cercanos:', error);
      res.status(500).json({ error: 'Error al obtener usuarios cercanos' });
    }
}

const getMatches = async(req, res) => {
  try {
      // Verificar si el usuario está autenticado y obtener su ID
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
}



export default {
    getUsuariosCercanos,
    getMatches

};