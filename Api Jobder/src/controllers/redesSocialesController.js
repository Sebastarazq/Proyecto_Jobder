import redesSocialesService from '../services/redesSocialesService.js';

const getAllRedesSociales = async (req, res) => {
  try {
    const redesSociales = await redesSocialesService.getAllRedesSociales();
    console.log('todas las redes sociales:', redesSociales)
    res.status(200).json(redesSociales);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error al obtener redes sociales' });
  }
};

const getRedesSocialesUsuario = async (req, res) => {
    try {
        const { usuarioId } = req.params;
        const redesSociales = await redesSocialesService.getRedesSocialesUsuario(usuarioId);
        console.log('redes sociales del usuario:', redesSociales)
        res.status(200).json(redesSociales);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener las redes sociales del usuario' });
    }
};

const asociarRedesSociales = async (req, res) => {
    try {
      const redesSociales = req.body;
      
      // Validar que la lista de redes sociales no esté vacía
      if (!redesSociales || redesSociales.length === 0) {
        return res.status(400).json({ message: 'La lista de redes sociales no puede estar vacía' });
      }
  
      // Iterar sobre cada objeto de la lista de redes sociales
      for (const redSocial of redesSociales) {
        const { usuario_id, red_id, nombre_usuario_aplicacion } = redSocial;
        
        // Validar que los campos no estén vacíos
        if (!usuario_id || !red_id || !nombre_usuario_aplicacion) {
          return res.status(400).json({ message: 'Todos los campos son obligatorios' });
        }
      }
  
      // Llamar a la función actualizarRedesSociales para asociar las redes sociales al usuario
      await redesSocialesService.actualizarRedesSociales(redesSociales);
      res.status(201).json({ message: 'Redes sociales asociadas correctamente al usuario' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al asociar redes sociales al usuario' });
    }
  };

  const obtenerTodasLasRedesUsuarioRedes = async (req, res) => {
    try {
      const { usuarioId } = req.params;
      console.log('usuarioId para obtener redes:', usuarioId);
  
      // Llama al servicio para verificar si el usuario existe y obtener sus redes sociales
      const redesSociales = await redesSocialesService.obtenerRedesSocialesUsuario(usuarioId);
  
      // Verificar si el resultado es un mensaje de error
      if (redesSociales.message) {
        return res.status(404).json({ message: redesSociales.message });
      }
  
      res.status(200).json(redesSociales);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Error al obtener las redes sociales del usuario' });
    }
  };
  

export default {
  getAllRedesSociales,
  asociarRedesSociales,
  getRedesSocialesUsuario,
  obtenerTodasLasRedesUsuarioRedes
};
