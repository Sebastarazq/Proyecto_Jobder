import 'package:app_jobder/domain/entities/habilidad.dart';
import 'package:dio/dio.dart';

class HabilidadesRepository {
  final Dio _dio = Dio();

  Future<List<Habilidad>> getAllHabilidades() async {
    try {
      final response = await _dio.get('http://192.168.1.5:3000/api/v1/habilidades/all');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Habilidad> habilidades = data.map((json) => Habilidad.fromJson(json)).toList();
        return habilidades;
      } else {
        throw Exception('Error al obtener habilidades: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al obtener habilidades: $error');
    }
  }

  Future<void> asociarHabilidadesUsuario(int usuarioId, List<int> habilidades) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/usuarioshabilidades/asociar2',
        data: {
          'usuario_id': usuarioId,
          'habilidades': habilidades,
        },
      );
      if (response.statusCode == 201) {
        print('Habilidades asociadas correctamente al usuario');
      } else {
        throw Exception('Error al asociar habilidades al usuario: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al asociar habilidades al usuario: $error');
    }
  }
  
  Future<List<Habilidad>> getUsuarioHabilidades(int usuarioId) async {
    try {
      final response = await _dio.get('http://192.168.1.5:3000/api/v1/usuarioshabilidades/$usuarioId');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Habilidad> habilidades = data.map((json) => Habilidad.fromJson(json)).toList();
        return habilidades;
      } else {
        throw Exception('Error al obtener habilidades del usuario: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al obtener habilidades del usuario: $error');
    }
  }
  

  // Método para enviar los datos y actualizar las habilidades del usuario
  Future<void> actualizarHabilidadesUsuario(int usuarioId, List<int> nuevasHabilidades) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/usuarioshabilidades/actualizar',
        data: {
          'usuario_id': usuarioId,
          'habilidades': nuevasHabilidades,
        },
      );
      if (response.statusCode == 200) {
        print('Habilidades actualizadas correctamente');
      } else {
        throw Exception('Error al actualizar habilidades: ${response.data['message']}');
      }
    } catch (error) {
      throw Exception('Error al actualizar habilidades: $error');
    }
  }
}
