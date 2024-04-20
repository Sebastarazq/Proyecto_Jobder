class Usuario {
  int usuario_id;
  String nombre;
  String email;
  int celular;
  String password;
  int edad;
  String genero;
  String foto_perfil;
  String categoria;
  String? descripcion;
  double? latitud;
  double? longitud;
  String? token;
  bool? confirmado;

  Usuario({
    required this.usuario_id,
    required this.nombre,
    required this.email,
    required this.celular,
    required this.password,
    required this.edad,
    required this.genero,
    required this.foto_perfil,
    required this.categoria,
    this.descripcion,
    this.latitud,
    this.longitud,
    this.token,
    this.confirmado,
  });
}
