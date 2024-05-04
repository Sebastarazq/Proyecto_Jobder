import express from "express";
import db from "./src/database/db.js";
import userRoutes from './src/v1/routes/usuarioRoutes.js';
import habilidadRoutes from './src/v1/routes/habilidadRoutes.js';
import usuarioHabilidadRoutes from './src/v1/routes/usuarioHabilidadRoutes.js';
import macthRoutes from './src/v1/routes/matchRoutes.js';
import setupSwagger from './src/v1/swagger.js';
import redSocialRoutes from './src/v1/routes/redSocialRoutes.js';

// Crear la aplicación de express
const app = express();
// Puerto
const PORT = process.env.PORT || 3000;

// Carpeta publica
app.use(express.static('public'))

// json middleware
app.use(express.json());

//Conexion a la base de datos
try{
    await db.authenticate();
    db.sync()
    console.log(`Conexión Correcta a ${process.env.DATABASE} de MySQL`)
} catch(error){
    console.log(error)
}

// Routes
app.use('/api/v1/users', userRoutes)
app.use('/api/v1/habilidades', habilidadRoutes)
app.use('/api/v1/usuarioshabilidades', usuarioHabilidadRoutes)
app.use('/api/v1/match', macthRoutes)
app.use('/api/v1/redes', redSocialRoutes)



// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`API corriendo en http://localhost:${PORT}`);
  setupSwagger(app);
});