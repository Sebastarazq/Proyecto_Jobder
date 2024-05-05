class RedSocialUsuario {
  final int redId;
  final String nombre;
  final String nombreUsuarioAplicacion;

  RedSocialUsuario({
    required this.redId,
    required this.nombre,
    required this.nombreUsuarioAplicacion,
  });

  factory RedSocialUsuario.fromJson(Map<String, dynamic> json) {
    return RedSocialUsuario(
      redId: json['red_id'],
      nombre: json['nombre'],
      nombreUsuarioAplicacion: json['nombreUsuarioAplicacion'],
    );
  }
}