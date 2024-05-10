import 'package:app_jobder/domain/entities/user.dart';

class UserMatch {
  final int matchId;
  final int usuario1Id;
  final int usuario2Id;
  final bool visto1;
  final bool visto2;
  final DateTime? fechaMatch;
  final Usuario usuario1; // Cambio aquí

  UserMatch({
    required this.matchId,
    required this.usuario1Id,
    required this.usuario2Id,
    required this.visto1,
    required this.visto2,
    this.fechaMatch,
    required this.usuario1, // Cambio aquí
  });

  factory UserMatch.fromJson(Map<String, dynamic> json) {
    return UserMatch(
      matchId: json['match']['match_id'],
      usuario1Id: json['match']['usuario1_id'],
      usuario2Id: json['match']['usuario2_id'],
      visto1: json['match']['visto1'],
      visto2: json['match']['visto2'],
      fechaMatch: json['match']['fecha_match'] != null
          ? DateTime.parse(json['match']['fecha_match'])
          : null,
      usuario1: Usuario( // Cambio aquí
        usuario_id: json['usuario1']['usuario_id'], // Cambio aquí
        nombre: json['usuario1']['nombre'], // Cambio aquí
        email: json['usuario1']['email'], // Cambio aquí
        celular: json['usuario1']['celular'], // Cambio aquí
        edad: json['usuario1']['edad'], // Cambio aquí
        genero: json['usuario1']['genero'], // Cambio aquí
        foto_perfil: json['usuario1']['foto_perfil'] ?? 'assets/images/user.jpeg', // Cambio aquí
        categoria: json['usuario1']['categoria'], // Cambio aquí
        descripcion: json['usuario1']['descripcion'], // Cambio aquí
        latitud: json['usuario1']['latitud'] != null // Cambio aquí
            ? double.parse(json['usuario1']['latitud']) // Cambio aquí
            : null,
        longitud: json['usuario1']['longitud'] != null // Cambio aquí
            ? double.parse(json['usuario1']['longitud']) // Cambio aquí
            : null,
      ),
    );
  }

  factory UserMatch.fromJsonMatchCompletos(Map<String, dynamic> json) {
    final matchJson = json['match'];
    final usuarioJson = json['usuario1'];
    return UserMatch(
      matchId: matchJson['match_id'],
      usuario1Id: matchJson['usuario1_id'],
      usuario2Id: matchJson['usuario2_id'],
      visto1: matchJson['visto1'],
      visto2: matchJson['visto2'],
      fechaMatch: matchJson['fecha_match'] != null
          ? DateTime.parse(matchJson['fecha_match'])
          : null,
      usuario1: Usuario( // Cambio aquí
        usuario_id: usuarioJson['usuario_id'], // Cambio aquí
        nombre: usuarioJson['nombre'], // Cambio aquí
        email: usuarioJson['email'], // Cambio aquí
        celular: usuarioJson['celular'], // Cambio aquí
        edad: usuarioJson['edad'], // Cambio aquí
        genero: usuarioJson['genero'], // Cambio aquí
        foto_perfil: usuarioJson['foto_perfil'] ?? 'assets/images/user.jpeg', // Cambio aquí
        categoria: usuarioJson['categoria'], // Cambio aquí
        descripcion: usuarioJson['descripcion'], // Cambio aquí
        latitud: usuarioJson['latitud'] != null // Cambio aquí
            ? double.parse(usuarioJson['latitud']) // Cambio aquí
            : null,
        longitud: usuarioJson['longitud'] != null // Cambio aquí
            ? double.parse(usuarioJson['longitud']) // Cambio aquí
            : null,
      ),
    );
  }
}