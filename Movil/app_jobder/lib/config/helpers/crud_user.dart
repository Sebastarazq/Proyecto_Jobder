import 'package:app_jobder/infraestructure/model/user_actualizar.dart';
import 'package:app_jobder/infraestructure/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class UserRepository {
  final Dio _dio = Dio();

  Future<int> enviarCodigo(String token) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/confirm/$token',
      );

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 200) {
        // Mostrar el mensaje recibido del servidor
        return response.data['devolverId'] as int;
      } else {
        // Si la respuesta no es exitosa, lanzar una excepción con el mensaje del servidor
        throw Exception('Error en la solicitud: ${response.data['message']}');
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw Exception('Código de confirmación no válido');
      } else if (error.response?.statusCode == 404) {
        throw Exception('Usuario no encontrado o token inválido');
      } else {
        throw Exception('Error al confirmar usuario: ${error.message}');
      }
    } catch (error) {
      throw Exception('Error al confirmar usuario: $error');
    }
  }


  Future<void> createUser(UserModel user) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/register',
        data: user.toJson(),
      );

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 201) {
        // Mostrar el mensaje recibido del servidor
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

      // Extraer el id del usuario del servidor
      final int usuarioId = response.data['usuario_id'];
      

      // Expiración del token 7 días
      final DateTime expirationDate = DateTime.now().add(const Duration(days: 7));
      final String formattedExpirationDate = DateFormat('yyyy-MM-dd').format(expirationDate);

      // Almacenar el token y la fecha de expiración en SharedPreferences
      await _saveToken(token, formattedExpirationDate);

      // Almacenar el id del usuario en SharedPreferences
      await _saveid(usuarioId);

    } on DioException catch (error) {
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

  Future<void> loginVerificarHuella(UsuarioLogin user) async {
    try {
      // Realizar la solicitud para iniciar sesión
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/loginverificarhuella',
        data: user.toJson(), // Convertir el objeto UsuarioLogin a JSON
      );

      // Extraer los datos de usuario y token del servidor
      final int usuarioId = response.data['usuario_id'];
      final String token = response.data['token'];

      // Generar la fecha de expiración del token (7 días)
      final DateTime expirationDate = DateTime.now().add(const Duration(days: 7));
      final String formattedExpirationDate = DateFormat('yyyy-MM-dd').format(expirationDate);

      // Guardar el token largo y la fecha de expiración en SharedPreferences
      await _saveTokenLargo(token, formattedExpirationDate);

      // Guardar el usuario ID en SharedPreferences
      await _saveid(usuarioId);
    } on DioException catch (error) {
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

  Future<void> loginHuella(String token) async {
    try {
      // Realizar la solicitud para iniciar sesión con huella dactilar
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/loginhuella/$token',
      );

      // Extraer los datos de usuario y token del servidor
      final int usuarioId = response.data['usuario_id'];
      final String nuevoToken = response.data['token'];

      // Generar la fecha de expiración del token (7 días)
      final DateTime expirationDate = DateTime.now().add(const Duration(days: 7));
      final String formattedExpirationDate = DateFormat('yyyy-MM-dd').format(expirationDate);

      // Guardar el nuevo token en SharedPreferences
      // Almacenar el token y la fecha de expiración en SharedPreferences
      await _saveToken(nuevoToken, formattedExpirationDate);

      // Guardar el usuario ID en SharedPreferences
      await _saveid(usuarioId);
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw Exception('Error de solicitud');
      } else if (error.response?.statusCode == 401) {
        throw Exception('Token inválido');
      } else {
        throw Exception('Error al iniciar sesión: ${error.message}');
      }
    } catch (error) {
      throw Exception('Error al iniciar sesión: $error');
    }
  }

  Future<void> sendPasswordResetCode(String email) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/forgot-password',
        data: {'email': email},
      );

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 200) {
        // Mostrar mensaje de éxito
        print('Código de recuperación de contraseña enviado con éxito');
      } else {
        // Si la respuesta no es exitosa, lanzar una excepción con el mensaje del servidor
        throw Exception('Error en la solicitud: ${response.data['message']}');
      }
    } on DioException catch (error) {
      // Manejar errores de Dio
      if (error.response?.statusCode == 400) {
        throw Exception('Bad Request: ${error.response?.data['message']}');
      } else if (error.response?.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error al enviar código de recuperación de contraseña: ${error.message}');
      }
    } catch (error) {
      // Manejar otros errores
      throw Exception('Error al enviar código de recuperación de contraseña: $error');
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/password/reset/confirm/$token',
        data: {'newPassword': newPassword},
      );

      // Verificar si la respuesta es exitosa
      if (response.statusCode == 200) {
        // Mostrar mensaje de éxito
        print('Contraseña restablecida exitosamente');
      } else {
        // Si la respuesta no es exitosa, lanzar una excepción con el mensaje del servidor
        throw Exception('Error en la solicitud: ${response.data['message']}');
      }
    } on DioException catch (error) {
      // Manejar errores de Dio
      if (error.response?.statusCode == 400) {
        throw Exception('Bad Request: ${error.response?.data['message']}');
      } else if (error.response?.statusCode == 404) {
        throw Exception('Token inválido o expirado');
      } else {
        throw Exception('Error al restablecer la contraseña: ${error.message}');
      }
    } catch (error) {
      // Manejar otros errores
      throw Exception('Error al restablecer la contraseña: $error');
    }
  }

    Future<UserModel> getUserById(String userId) async {
      try {
        final usuarioId = int.parse(userId);
        final response = await _dio.get(
          'http://192.168.1.5:3000/api/v1/users/$usuarioId', // Endpoint para obtener usuario por ID
        );

        // Verificar si la respuesta es exitosa
        if (response.statusCode == 200) {
          // Parsear el JSON de la respuesta a un objeto UserModel
          final user = UserModel.fromJson(response.data);
          return user;
        } else {
          // Si la respuesta no es exitosa, lanzar una excepción con el mensaje del servidor
          throw Exception('Error en la solicitud: ${response.data['message']}');
        }
      } on DioException catch (error) {
        // Manejar errores de Dio
        if (error.response?.statusCode == 404) {
          throw Exception('Usuario no encontrado');
        } else {
          throw Exception('Error al obtener usuario por ID: ${error.message}');
        }
      } catch (error) {
        // Manejar otros errores
        throw Exception('Error al obtener usuario por ID: $error');
      }
    }

    Future<void> uploadProfileImage(String userId, File imageFile) async {
    try {
      // Crea un FormData para adjuntar el archivo de imagen
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile_image.jpg',
        ),
      });

      // Realiza la solicitud POST al endpoint para subir la imagen
      final response = await _dio.post(
        'http://192.168.1.5:3000/api/v1/users/perfilimg/$userId/upload',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      // Verifica si la respuesta es exitosa
      if (response.statusCode == 200) {
        print('Imagen de perfil subida exitosamente');
      } else {
        // Si la respuesta no es exitosa, lanza una excepción con el mensaje del servidor
        throw Exception('Error en la solicitud: ${response.data['message']}');
      }
    } catch (error) {
      // Maneja errores durante la solicitud
      throw Exception('Error al subir la imagen de perfil: $error');
    }
  }

  // Modificar la función updateUserPartialInfo para aceptar PartialUserUpdate como parámetro
  Future<void> updateUserPartialInfo(String userId, PartialUserUpdate updates) async {
    try {
      final response = await _dio.patch(
        'http://192.168.1.5:3000/api/v1/users/update/$userId',
        data: updates.toJson(),
      );

      // Verifica si la respuesta es exitosa
      if (response.statusCode == 200) {
        print('Información de usuario actualizada con éxito');
      } else {
        // Si la respuesta no es exitosa, lanza una excepción con el mensaje del servidor
        throw Exception('Error en la solicitud: ${response.data['message']}');
      }
    } on DioException catch (error) {
      // Maneja errores de Dio
      if (error.response?.statusCode == 400) {
        throw Exception('Bad Request: ${error.response?.data['message']}');
      } else if (error.response?.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error al actualizar la información del usuario: ${error.message}');
      }
    } catch (error) {
      // Maneja otros errores
      throw Exception('Error al actualizar la información del usuario: $error');
    }
  }


  Future<void> _saveToken(String token, String expirationDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('token_expiration', expirationDate);
  }
  Future<void> _saveTokenLargo(String token, String expirationDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token_largo', token);
    await prefs.setString('token_expiration', expirationDate);
  }
  Future<void> _saveid(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_id', usuarioId.toString());
  }
}
