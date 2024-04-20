import 'package:app_jobder/infraestructure/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<void> createUser(UserModel user) async {
    try {
      final response = await _dio.post(
        'http://localhost:3000/api/v1/users/register',
        data: user.toJson(),
      );

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 200) {
        // Mostrar el mensaje recibido del servidor
        final String message = response.data['message'];
      } else {
        // Si la respuesta no es exitosa, lanzar una excepción con el mensaje del servidor
        throw Exception('Error en la solicitud: ${response.data['message']}');
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw Exception('Bad Request: ${error.response?.data['message']}');
      } else if (error.response?.statusCode == 401) {
        throw Exception('Unauthorized: ${error.response?.data['message']}');
      } else {
        throw Exception('Error en la solicitud: ${error.message}');
      }
    } catch (error) {
      throw Exception('Error al crear usuario: $error');
    }
  }

  Future<void> loginUser(UsuarioLogin user) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/login',
        data: user.toJson(),
      );

      // Extraer el token del servidor
      final String token = response.data['token'];

      // Expiración del token 7 días
      final DateTime expirationDate = DateTime.now().add(const Duration(days: 7));
      final String formattedExpirationDate = DateFormat('yyyy-MM-dd').format(expirationDate);

      // Almacenar el token y la fecha de expiración en SharedPreferences
      await _saveToken(token, formattedExpirationDate);
    } on DioError catch (error) {
      if (error.response?.statusCode == 400) {
        throw Exception('Correo electrónico/celular y contraseña son obligatorios');
      } else if (error.response?.statusCode == 401) {
        final String message = error.response?.data['message'];
        if (message == 'Correo electrónico/celular o contraseña incorrectos') {
          throw Exception('Correo electrónico/celular o contraseña incorrectos');
        } else if (message == 'La cuenta no existe') {
          throw Exception('La cuenta no existe');
        } else if (message == 'La cuenta no está confirmada') {
          throw Exception('La cuenta no está confirmada');
        } else {
          throw Exception('Credenciales inválidas. Por favor, verifica tu correo electrónico y contraseña.');
        }
      } else {
        throw Exception('Error al iniciar sesión: ${error.message}');
      }
    } catch (error) {
      throw Exception('Error al iniciar sesión: $error');
    }
  }

  // Las funciones getUser, updateUser y deleteUser se pueden agregar según sea necesario

  Future<void> _saveToken(String token, String expirationDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('token_expiration', expirationDate);
  }
}
