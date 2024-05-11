import 'package:app_jobder/domain/entities/habilidad.dart';
import 'package:app_jobder/domain/entities/habilidad_asociada.dart';
import 'package:dio/dio.dart';

class HabilidadesRepository {
  final Dio _dio = Dio();
  static const String baseUrl = 'https://api-appjobder.azurewebsites.net/';

  Future<List<Habilidad>> getAllHabilidades() async {
    try {
      final response = await _dio.get('${baseUrl}api/v1/habilidades/all');
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
        '${baseUrl}api/v1/usuarioshabilidades/asociar2',
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
      final response = await _dio.get('${baseUrl}api/v1/usuarioshabilidades/$usuarioId');
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
        '${baseUrl}api/v1/usuarioshabilidades/actualizar',
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

  Future<HabilidadesUsuarioHabilidadResponse> getHabilidadesUsuarioHabilidad(int usuarioId) async {
    try {
      final response = await _dio.post('${baseUrl}api/v1/usuarioshabilidades/habilidades/$usuarioId');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['habilidades']; // Accedemos directamente a la lista de habilidades
        print('Data: $data');

        // Mapear la lista de habilidades a objetos HabilidadUsuarioHabilidad
        List<HabilidadUsuarioHabilidad> habilidades = List<HabilidadUsuarioHabilidad>.from(data.map((x) => HabilidadUsuarioHabilidad.fromJson(x)));

        // Retornar la respuesta con la lista de habilidades
        return HabilidadesUsuarioHabilidadResponse(habilidades: habilidades);
      } else {
        String errorMessage = response.data['message'] ?? 'Error desconocido';
        throw Exception('Error al obtener habilidades del usuario: $errorMessage');
      }
    } catch (error) {
      throw Exception('Error al obtener habilidades del usuario: $error');
    }
  }
}