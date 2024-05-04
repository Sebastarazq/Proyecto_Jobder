class RedSocial {
  final int redId;
  final String nombre;
  String nombreUsuarioAplicacion;

  RedSocial({
    required this.redId,
    required this.nombre,
    required this.nombreUsuarioAplicacion,
  });

  factory RedSocial.fromJson(Map<String, dynamic> json) {
    final usuarioRedSocial = json['Usuarios_Redessociales'] ?? {};
    final nombreUsuarioAplicacion = usuarioRedSocial['nombre_usuario_aplicacion'] ?? '';

    return RedSocial(
      redId: json['red_id'] ?? -1,
      nombre: json['nombre'] ?? '',
      nombreUsuarioAplicacion: nombreUsuarioAplicacion,
    );
  }

  RedSocial copyWith({String? nombreUsuarioAplicacion}) {
    return RedSocial(
      redId: redId,
      nombre: nombre,
      nombreUsuarioAplicacion: nombreUsuarioAplicacion ?? this.nombreUsuarioAplicacion,
    );
  }
}