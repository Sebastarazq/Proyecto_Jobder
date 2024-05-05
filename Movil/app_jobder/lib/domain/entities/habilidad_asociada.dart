class HabilidadesUsuarioHabilidadResponse {
  final List<HabilidadUsuarioHabilidad> habilidades;

  HabilidadesUsuarioHabilidadResponse({
    required this.habilidades,
  });

  factory HabilidadesUsuarioHabilidadResponse.fromJson(Map<String, dynamic> json) {
    return HabilidadesUsuarioHabilidadResponse(
      habilidades: List<HabilidadUsuarioHabilidad>.from(json['habilidades'].map((x) => HabilidadUsuarioHabilidad.fromJson(x))),
    );
  }
}

class HabilidadUsuarioHabilidad {
  final int relacionId;
  final int usuarioId;
  final int habilidadId;
  final String nombre;

  HabilidadUsuarioHabilidad({
    required this.relacionId,
    required this.usuarioId,
    required this.habilidadId,
    required this.nombre,
  });

  factory HabilidadUsuarioHabilidad.fromJson(Map<String, dynamic> json) {
    return HabilidadUsuarioHabilidad(
      relacionId: json['relacion_id'],
      usuarioId: json['usuario_id'],
      habilidadId: json['habilidad_id'],
      nombre: json['nombre'],
    );
  }
}