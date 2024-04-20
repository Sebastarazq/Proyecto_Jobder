class Usuario {
  int usuario_id;
  String nombre;
  String email;
  int celular;
  int edad;
  String genero;
  String? foto_perfil;
  String categoria;
  String? descripcion;
  double? latitud;
  double? longitud;

  Usuario({
    required this.usuario_id,
    required this.nombre,
    required this.email,
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
