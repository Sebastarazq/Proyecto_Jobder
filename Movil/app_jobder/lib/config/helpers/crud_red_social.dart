import 'package:app_jobder/domain/entities/red_social_basica.dart';
import 'package:dio/dio.dart';
import 'package:app_jobder/domain/entities/red_social.dart';

class RedesSocialesRepository {
  final Dio _dio = Dio();

  Future<List<RedSocialBasica>> getAllRedesSociales() async {
    try {
      final response = await _dio.get('http://192.168.1.5:3000/api/v1/redes/all');
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
    final response = await _dio.get('http://192.168.1.5:3000/api/v1/redes/$usuarioId');
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
        'http://192.168.1.5:3000/api/v1/redes/asociar',
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
}
