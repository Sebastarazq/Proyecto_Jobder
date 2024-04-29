import 'package:app_jobder/domain/entities/habilidad.dart';
import 'package:flutter/material.dart';
import 'package:app_jobder/domain/entities/user_data.dart';
import 'package:flutter/services.dart';

class UserProfileScreen extends StatelessWidget {
  final UserData user;

  const UserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blueGrey.shade200, Colors.white],
                      ),
                    ),
                  ),
                  _buildUserImage(),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Text(
                      user.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.cake, 'Edad:', '${user.age} años'),
                      _buildInfoRow(Icons.star, 'Habilidades:', _formatHabilidades(user.habilidades)),
                      _buildInfoRow(Icons.category, 'Categoría:', user.categoria ?? 'No disponible'),
                      _buildInfoRow(Icons.person, 'Descripción:', user.descripcion ?? 'No disponible'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserImage() {
    return FutureBuilder<Uint8List>(
      future: _loadImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // En caso de error, cargar la imagen de assets
            return Image.asset(
              'assets/images/user.jpeg',
              fit: BoxFit.cover,
            );
          } else {
            // Si no hay error, mostrar la imagen desde la red
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            );
          }
        } else {
          // Mientras se está cargando la imagen, mostrar un indicador de progreso
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blueGrey[800],
            size: 24,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatHabilidades(List<Habilidad>? habilidades) {
    if (habilidades == null || habilidades.isEmpty) {
      return 'Sin habilidades';
    }
    return habilidades
        .map((habilidad) => habilidades.firstWhere(
              (hab) => hab.habilidadId == habilidad.habilidadId,
              orElse: () => Habilidad(
                habilidadId: habilidad.habilidadId,
                nombre: 'Habilidad desconocida',
              ),
            )
            .nombre)
        .join(', ');
  }

  Future<Uint8List> _loadImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/user.jpeg');
      return data.buffer.asUint8List();
    } catch (error) {
      print('Error loading asset image: $error');
      throw error;
    }
  }
}
