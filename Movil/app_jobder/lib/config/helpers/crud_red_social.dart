import 'package:app_jobder/domain/entities/red_social_basica.dart';
import 'package:app_jobder/domain/entities/red_social_usuario.dart';
import 'package:dio/dio.dart';
import 'package:app_jobder/domain/entities/red_social.dart';

class RedesSocialesRepository {
  final Dio _dio = Dio();

  static const String baseUrl = 'https://api-appjobder.azurewebsites.net/';

  Future<List<RedSocialBasica>> getAllRedesSociales() async {
    try {
      final response = await _dio.get('${baseUrl}api/v1/redes/all');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<RedSocialBasica> redesSociales = data.map((json) => RedSocialBasica.fromJson(json)).toList();
        return redesSociales;
      } else {
        throw Exception('Error al obtener redes sociales: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al obtener redes sociales: $error');
    }
  }

   Future<List<RedSocial>> getRedesSocialesUsuario(int usuarioId) async {
    try {
      final response = await _dio.get('${baseUrl}api/v1/redes/$usuarioId');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.data}');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<RedSocial> redesSociales = data.map((json) => RedSocial.fromJson(json)).toList();
        return redesSociales;
      } else {
        throw Exception('Error al obtener redes sociales del usuario: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al obtener redes sociales del usuario: $error');
    }
  }

  Future<void> asociarRedesSociales(List<Map<String, dynamic>> redesSociales) async {
    try {
      final response = await _dio.post(
        '${baseUrl}api/v1/redes/asociar',
        data: redesSociales,
      );
      if (response.statusCode == 201) {
        print('Redes sociales asociadas correctamente al usuario');
      } else {
        throw Exception('Error al asociar redes sociales al usuario: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al asociar redes sociales al usuario: $error');
    }
  }

  Future<List<RedSocialUsuario>> obtenerRedesSocialesUsuarioRedes(int usuarioId) async {
    try {
      final response = await _dio.post('${baseUrl}api/v1/redes/vinculadas/$usuarioId');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<RedSocialUsuario> redesSociales = data.map((json) => RedSocialUsuario.fromJson(json)).toList();
        return redesSociales;
      } else {
        throw Exception('Error al obtener redes sociales del usuario: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al obtener redes sociales del usuario: $error');
    }
  }

  Future<void> eliminarRedSocial(int redId) async {
    print('Eliminando red social con ID: $redId');
    try {
      final response = await _dio.delete(
        '${baseUrl}api/v1/redes/desvincular/$redId', // Ruta para eliminar la red social por su ID
      );
      if (response.statusCode == 200) {
        print('Red social eliminada correctamente');
      } else if (response.statusCode == 404) {
        throw Exception('La red social no existe');
      } else {
        throw Exception('Error al eliminar la red social: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al eliminar la red social: $error');
    }
  }
}
