import 'package:app_jobder/domain/entities/user.dart';

class UserMatch {
  final int matchId;
  final int usuario1Id;
  final int usuario2Id;
  final bool visto1;
  final bool visto2;
  final DateTime? fechaMatch;
  final Usuario usuario2;

  UserMatch({
    required this.matchId,
    required this.usuario1Id,
    required this.usuario2Id,
    required this.visto1,
    required this.visto2,
    this.fechaMatch,
    required this.usuario2,
  });

  factory UserMatch.fromJson(Map<String, dynamic> json) {
    return UserMatch(
      matchId: json['match']['match_id'],
      usuario1Id: json['match']['usuario1_id'],
      usuario2Id: json['match']['usuario2_id'],
      visto1: json['match']['visto1'],
      visto2: json['match']['visto2'],
      fechaMatch: json['match']['fecha_match'] != null ? DateTime.parse(json['match']['fecha_match']) : null,
      usuario2: Usuario(
        usuario_id: json['usuario2']['usuario_id'],
        nombre: json['usuario2']['nombre'],
        email: json['usuario2']['email'],
        celular: json['usuario2']['celular'],
        edad: json['usuario2']['edad'],
        genero: json['usuario2']['genero'],
        foto_perfil: json['usuario2']['foto_perfil'] ?? 'assets/images/user.jpeg',
        categoria: json['usuario2']['categoria'],
        descripcion: json['usuario2']['descripcion'],
        latitud: json['usuario2']['latitud'] != null ? double.parse(json['usuario2']['latitud']) : null,
        longitud: json['usuario2']['longitud'] != null ? double.parse(json['usuario2']['longitud']) : null,
      ),
    );
  }
  factory UserMatch.fromJsonMatchCompletos(Map<String, dynamic> json) {
  final matchJson = json['match'];
  final usuarioJson = json['usuario'];

  return UserMatch(
    matchId: matchJson['match_id'],
    usuario1Id: matchJson['usuario1_id'],
    usuario2Id: matchJson['usuario2_id'],
    visto1: matchJson['visto1'],
    visto2: matchJson['visto2'],
    fechaMatch: matchJson['fecha_match'] != null ? DateTime.parse(matchJson['fecha_match']) : null,
    usuario2: Usuario(
      usuario_id: usuarioJson['usuario_id'],
      nombre: usuarioJson['nombre'],
      email: usuarioJson['email'],
      celular: usuarioJson['celular'],
      edad: usuarioJson['edad'],
      genero: usuarioJson['genero'],
      foto_perfil: usuarioJson['foto_perfil'] ?? 'assets/images/user.jpeg',
      categoria: usuarioJson['categoria'],
      descripcion: usuarioJson['descripcion'],
      latitud: usuarioJson['latitud'] != null ? double.parse(usuarioJson['latitud']) : null,
      longitud: usuarioJson['longitud'] != null ? double.parse(usuarioJson['longitud']) : null,
    ),
  );
}
}
