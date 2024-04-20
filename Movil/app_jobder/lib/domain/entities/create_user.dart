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
}
