#!/bin/bash

# Iniciar el servidor en primer plano
npm start &

# Esperar un momento para que el servidor se inicie completamente
sleep 10

# Ejecutar la importación de la base de datos después de que el servidor esté en funcionamiento
npm run db:importar

# Mantener el script en ejecución para que el contenedor no salga
tail -f /dev/null