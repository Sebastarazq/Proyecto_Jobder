
class UsuarioLogin {
  String? email;
  int? celular;
  String password;

  UsuarioLogin({
    this.email,
    this.celular,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'celular': celular,
      'password': password,
    };
    return data;
  }
}

class UserModel {
  String nombre;
  String email;
  int celular;
  int edad;
  String password;
  String genero;
  String? fotoPerfil;
  String categoria;
  String? descripcion;
  double? latitud;
  double? longitud;

  UserModel({
    required this.nombre,
    required this.email,
    required this.celular,
    required this.password,
    required this.edad,
    required this.genero,
    this.fotoPerfil,
    required this.categoria,
    this.descripcion,
    this.latitud,
    this.longitud,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nombre: json['nombre'] ?? '',
      email: json['email'] ?? '',
      celular: json['celular'] ?? 0,
      password: json['password'] ?? '',
      edad: json['edad'] ?? 0,
      genero: json['genero'] ?? '',
      fotoPerfil: json['foto_perfil'] ?? '',
      categoria: json['categoria'] ?? '',
      descripcion: json['descripcion'] ?? 'Sin descripción',
      latitud: json['latitud'] != null ? double.tryParse(json['latitud']) : null,
    longitud: json['longitud'] != null ? double.tryParse(json['longitud']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'nombre': nombre,
      'email': email,
      'celular': celular,
      'password': password,
      'edad': edad,
      'genero': genero,
      'categoria': categoria,
    };

    if (fotoPerfil != null) data['foto_perfil'] = fotoPerfil;
    if (descripcion != null) data['descripcion'] = descripcion;
    if (latitud != null) data['latitud'] = latitud;
    if (longitud != null) data['longitud'] = longitud;

    return data;
  }

  /* Usuario toUserEntity() => Usuario(
    nombre: nombre,
    email: email,
    celular: celular,
    edad: edad,
    genero: genero,
    foto_perfil: fotoPerfil,
    categoria: categoria,
    descripcion: descripcion,
    latitud: latitud,
    longitud: longitud,
  ); */
}
