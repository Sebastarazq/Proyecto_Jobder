import 'package:app_jobder/infraestructure/model/user_model.dart';

class UsuarioCreacion {
  String nombre;
  String email;
  int celular;
  String password;
  int edad;
  String genero;
  String? foto_perfil;
  String categoria;
  String? descripcion;
  double? latitud;
  double? longitud;

  UsuarioCreacion({
    required this.nombre,
    required this.email,
    required this.password,
    required this.celular,
    required this.edad,
    required this.genero,
    this.foto_perfil,
    required this.categoria,
    this.descripcion,
    this.latitud,
    this.longitud,
  });

  // Método para convertir UsuarioCreacion a UserModel
  UserModel toUserModel() {
    return UserModel(
      nombre: nombre,
      email: email,
      celular: celular,
      password: password,
      edad: edad,
      genero: genero,
      fotoPerfil: foto_perfil,
      categoria: categoria,
      descripcion: descripcion,
      latitud: latitud,
      longitud: longitud,
    );
  }
}
