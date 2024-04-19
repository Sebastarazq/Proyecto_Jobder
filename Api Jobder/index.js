import express from "express";
import db from "./src/database/db.js";

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
    console.log(`Conexión Correcta a ${process.env.DATABASE} de MySQL`)
} catch(error){
    console.log(error)
}

// Routes

// Iniciar el servidor
app.listen(PORT, () => {
  console.log(`API corriendo en http://localhost:${PORT}`);
});