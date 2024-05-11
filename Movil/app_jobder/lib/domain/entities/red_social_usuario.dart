class RedSocialUsuario {
  final int usuarioRedId;
  final int redId;
  final String nombre;
  final String nombreUsuarioAplicacion;

  RedSocialUsuario({
    required this.usuarioRedId, 
    required this.redId,
    required this.nombre,
    required this.nombreUsuarioAplicacion,
  });

  factory RedSocialUsuario.fromJson(Map<String, dynamic> json) {
    return RedSocialUsuario(
      usuarioRedId: json['usuario_red_id'],
      redId: json['red_id'],
      nombre: json['nombre'],
      nombreUsuarioAplicacion: json['nombreUsuarioAplicacion'],
    );
  }

   @override
  String toString() {
    return 'RedSocialUsuario(usuarioRedId: $usuarioRedId, redId: $redId, nombre: $nombre, nombreUsuarioAplicacion: $nombreUsuarioAplicacion)';
  }
}