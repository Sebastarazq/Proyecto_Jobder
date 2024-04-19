import express from "express";

// Crear la aplicación de express
const app = express();
// Puerto
const PORT = process.env.PORT || 3000;

// json middleware
app.use(express.json());

//Conexion a la base de datos
try{
    await db.authenticate();
    db.sync()
    console.log('Conexión Correcta a la Base de Datos de MySQL')
} catch(error){
    console.log(error)
}

// Routes

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`API corriendo en http://localhost:${PORT}`);
});