import 'package:app_jobder/domain/entities/user_data.dart'; // Importa la clase UserData
import 'package:app_jobder/domain/entities/habilidad.dart'; // Importa la clase Habilidad

class UsuarioCercano {
  final int usuarioId;
  final String nombre;
  final String email;
  final int celular;
  final int edad;
  final String genero;
  final String? fotoPerfil; // Marcar como nullable
  final String categoria;
  final String? descripcion;
  final String latitud;
  final String longitud;
  final String? token;
  final bool confirmado;
  final List<Habilidad> habilidades; // Lista de habilidades

  UsuarioCercano({
    required this.usuarioId,
    required this.nombre,
    required this.email,
    required this.celular,
    required this.edad,
    required this.genero,
    required this.fotoPerfil,
    required this.categoria,
    required this.descripcion,
    required this.latitud,
    required this.longitud,
    required this.token,
    required this.confirmado,
    required this.habilidades, // Agregar habilidades al constructor
  });

  factory UsuarioCercano.fromJson(Map<String, dynamic> json) {
    // Mapear la lista de habilidades desde JSON
    List<dynamic> habilidadesJson = json['Habilidades'];
    List<Habilidad> habilidades = habilidadesJson.map((habilidadJson) => Habilidad.fromJson(habilidadJson)).toList();

    return UsuarioCercano(
      usuarioId: json['usuario_id'],
      nombre: json['nombre'],
      email: json['email'],
      celular: json['celular'],
      edad: json['edad'],
      genero: json['genero'],
      fotoPerfil: json['foto_perfil'],
      categoria: json['categoria'],
      descripcion: json['descripcion'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      token: json['token'],
      confirmado: json['confirmado'],
      habilidades: habilidades, // Asignar la lista de habilidades
    );
  }

  UserData toUserData() {
    return UserData(
      name: nombre,
      imageUrl: fotoPerfil != null ? fotoPerfil! : 'assets/images/user.jpeg', // Si fotoPerfil no es nulo, úsalo; de lo contrario, usa la imagen predeterminada
      age: edad,
      bio: genero,
      categoria: categoria,
      descripcion: descripcion != null ? descripcion! : 'No disponible', // Si la descripción no es nula, úsala; de lo contrario, usa un valor predeterminado
      habilidades: habilidades, // Pasar la lista de habilidades
      latitud: latitud,
      longitud: longitud,
      id: usuarioId.toString(), // Convertir el ID a una cadena
    );
  }
}
