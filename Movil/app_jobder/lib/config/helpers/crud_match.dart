import 'package:app_jobder/domain/entities/usuario_cercano.dart';
import 'package:dio/dio.dart';

class MatchRepository {
  final Dio _dio = Dio();

  Future<List<UsuarioCercano>> getUsuariosCercanos(int usuarioId) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/match/ubicacion',
        data: {
          'usuario_id': usuarioId,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> usuariosJson = response.data['usuariosCercanos'];
        return usuariosJson.map((json) => UsuarioCercano.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener usuarios cercanos: ${response.data['error']}');
      }
    } catch (error) {
      throw Exception('Error al obtener usuarios cercanos: $error');
    }
  }

  Future<List<dynamic>> obtenerMatches(int usuarioId) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/match',
        data: {
          'usuario_id': usuarioId,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> matchesJson = response.data['matches'];
        return matchesJson;
      } else if (response.statusCode == 404) {
        throw Exception('No tienes matches');
      } else {
        throw Exception('Error al obtener matches: ${response.data['error']}');
      }
    } catch (error) {
      throw Exception('Error al obtener matches: $error');
    }
  }
}
