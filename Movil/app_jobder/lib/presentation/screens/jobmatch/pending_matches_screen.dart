import 'package:flutter/material.dart';

class PendingMatchesScreen extends StatelessWidget {
  const PendingMatchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 3, // Ejemplo con 3 matches pendientes
        itemBuilder: (context, index) {
          // Datos de ejemplo para cada match pendiente
          final usuario2 = {
            'nombre': 'Juan Perez',
            'email': 'juanperez@example.com',
            'categoria': 'Desarrollador',
            'foto_perfil': 'https://via.placeholder.com/150', // URL de la foto de perfil
            'ubicacion': 'Ciudad', // Ejemplo de ubicación
          };

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: InkWell(
              onTap: () {
                // Agregar lógica para manejar el tap en el match pendiente
                print('Detalles del Match ${index + 1}');
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        usuario2['foto_perfil'] ?? '',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario2['nombre'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // Color de texto negro para el nombre
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            usuario2['email'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[700], // Color de texto gris para el email
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Categoría: ${usuario2['categoria'] ?? ''}',
                            style: TextStyle(
                              color: Colors.grey[700], // Color de texto gris para la categoría
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Ubicación: ${usuario2['ubicacion'] ?? ''}',
                            style: TextStyle(
                              color: Colors.grey[700], // Color de texto gris para la ubicación
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            // Agregar lógica para rechazar el match pendiente
                            print('Rechazar Match ${index + 1}');
                          },
                        ),
                        SizedBox(height: 8),
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            // Agregar lógica para aceptar el match pendiente
                            print('Aceptar Match ${index + 1}');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
