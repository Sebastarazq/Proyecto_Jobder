import 'package:app_jobder/domain/entities/usuario_cercano.dart'; // Importa la clase UsuarioCercano
import 'package:app_jobder/domain/entities/habilidad.dart'; // Importa la clase Habilidad

class UserData {
  final String id; // Agregar un campo para el ID del usuario
  final String name;
  final String imageUrl;
  final int age;
  final String? bio;
  final String? categoria;
  final String? descripcion;
  final List<Habilidad> habilidades; // Agrega la lista de habilidades
  final String latitud;
  final String longitud;

  UserData({
    required this.name,
    required this.imageUrl,
    required this.age,
    this.bio,
    this.categoria,
    this.descripcion,
    required this.habilidades, // Añade la lista de habilidades al constructor
    required this.latitud,
    required this.longitud,
    required this.id, // Incluir el ID del usuario
  });

  factory UserData.fromUsuarioCercano(UsuarioCercano usuario) {
    return UserData(
      name: usuario.nombre,
      imageUrl: usuario.fotoPerfil ?? 'assets/images/user.jpeg', // Si fotoPerfil es null, usa una imagen predeterminada
      age: usuario.edad,
      bio: usuario.genero,
      categoria: usuario.categoria,
      descripcion: usuario.descripcion,
      habilidades: usuario.habilidades, // Asigna la lista de habilidades del usuario
      latitud: usuario.latitud,
      longitud: usuario.longitud,
      id: 'ID del usuario', // Asignar un ID único al usuario
    );
  }
}