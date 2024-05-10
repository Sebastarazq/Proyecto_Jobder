import 'package:app_jobder/domain/entities/match.dart';
import 'package:app_jobder/domain/entities/usuario_cercano.dart';
import 'package:dio/dio.dart';

class MatchRepository {
  final Dio _dio = Dio(
      BaseOptions(
    validateStatus: (status) => status != 401, // Configurar para no lanzar excepción en caso de 401
  ),
);

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

  Future<List<UsuarioCercano>> getUsuariosCategorias(int usuarioId) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/match/categorias',
        data: {
          'usuario_id': usuarioId,
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> usuariosJson = response.data['usuariosCercanos'];
        return usuariosJson.map((json) => UsuarioCercano.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener usuarios por categorías: ${response.data['error']}');
      }
    } catch (error) {
      throw Exception('Error al obtener usuarios por categorías: $error');
    }
  }

  Future<List<UserMatch>> obtenerMatches(int usuarioId, String token) async {
  try {
    final response = await _dio.post(
      'http://192.168.1.5:3000/api/v1/match/matches',
      data: {
        'usuario_id': usuarioId,
        'token': token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> matchesJson = response.data['matches'];
      List<UserMatch> matches = matchesJson.map((json) => UserMatch.fromJson(json)).toList();
      return matches;
    } else if (response.statusCode == 404) {
      throw Exception('No tienes matches');
    } else {
      // Si el servidor responde con un código de estado diferente a 200 o 404,
      // lanzamos una excepción genérica con el mensaje de error del servidor
      final errorMessage = response.data['message'] ?? 'Error del servidor';
      throw Exception(errorMessage);
    }
  } on DioException catch (e) {
    // Si se produce una excepción de DioError
    if (e.response?.statusCode == 401) {
      throw Exception('Token de autenticación inválido o expirado');
    } else {
      throw Exception('Error al obtener matches: ${e.message}');
    }
  }
}

  Future<List<UserMatch>> obtenerMatchesCompletados(int usuarioId) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/match/matches-completados',
        data: {
          'usuario_id': usuarioId,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data; // Obtener la respuesta completa
        final List<dynamic> matchesCompletadosJson = responseData['matchesCompletados'];
        return matchesCompletadosJson.map((json) => UserMatch.fromJsonMatchCompletos(json)).toList();
      } else if (response.statusCode == 404) {
        return []; // No tienes matches completados
      } else {
        throw Exception('Error al obtener matches completados: ${response.data['error']}');
      }
    } catch (error) {
      throw Exception('Error al obtener matches completados: $error');
    }
  }

  Future<String> crearMatch(int usuarioId1, int usuarioId2, bool visto1) async {
      try {
        final response = await _dio.post(
          'http://192.168.1.5:3000/api/v1/match/crear-match',
          data: {
            'usuarioId1': usuarioId1,
            'usuarioId2': usuarioId2,
            'visto1': visto1,
          },
        );
        if (response.statusCode == 201) {
          return 'Match creado exitosamente';
        } else if (response.statusCode == 400) {
          throw Exception(response.data['error']);
        } else if (response.statusCode == 404) {
          throw Exception(response.data['error']);
        } else {
          throw Exception('Error al crear match: ${response.data['error']}');
        }
      } catch (error) {
        throw Exception('Error al crear match: $error');
      }
    }

   Future<String> aprobarMatch(int matchId) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/match/aprobar-match',
        data: {
          'match_id': matchId,
        },
      );
      if (response.statusCode == 200) {
        return 'Match aprobado';
      } else {
        throw Exception(response.data['error']);
      }
    } catch (error) {
      throw Exception('Error al aprobar match: $error');
    }
  }

  Future<String> denegarMatch(int matchId) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/match/denegar-match',
        data: {
          'match_id': matchId,
        },
      );
      if (response.statusCode == 200) {
        return 'Match denegado';
      } else {
        throw Exception(response.data['error']);
      }
    } catch (error) {
      throw Exception('Error al denegar match: $error');
    }
  }
}
