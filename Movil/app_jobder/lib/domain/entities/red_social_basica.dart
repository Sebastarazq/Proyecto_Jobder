class RedSocialBasica {
  final int redId;
  final String nombre;

  RedSocialBasica({required this.redId, required this.nombre});

  factory RedSocialBasica.fromJson(Map<String, dynamic> json) {
    return RedSocialBasica(
      redId: json['red_id'] ?? 0,
      nombre: json['nombre'] ?? '',
    );
  }
}