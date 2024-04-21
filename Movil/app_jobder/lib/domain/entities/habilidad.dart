class Habilidad {
  final int habilidadId;
  final String nombre;

  Habilidad({
    required this.habilidadId,
    required this.nombre,
  });

  factory Habilidad.fromJson(Map<String, dynamic> json) {
    return Habilidad(
      habilidadId: json['habilidad_id'] ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }
}