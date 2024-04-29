import 'package:dio/dio.dart';

class LocationService {
  static Future<String> getCityName(double latitude, double longitude) async {
    final apiKey = 'AIzaSyChDbImoF6dJf2ASnB2gMou_YRL3x_oM-w';
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';
    print('URL: $url');

    try {
      final dio = Dio();
      final response = await dio.get(url);

      // Comprueba si la solicitud fue exitosa
      if (response.statusCode == 200) {
        final decodedResponse = response.data;
        // Verifica si la respuesta tiene la estructura esperada
        if (decodedResponse['status'] == 'OK') {
          // Busca el nombre de la ciudad en los componentes de la dirección
          for (var result in decodedResponse['results']) {
            for (var component in result['address_components']) {
              // Busca el tipo de componente 'locality', que representa la ciudad
              if (component['types'].contains('locality')) {
                // Devuelve el nombre de la ciudad
                return component['long_name'];
              }
            }
          }
          return 'No se encontró la ciudad';
        } else {
          return 'No se pudo obtener la ubicación';
        }
      } else {
        // Si la solicitud no fue exitosa, devuelve un mensaje de error
        return 'Error en la solicitud: ${response.statusCode}';
      }
    } catch (e) {
      // Si ocurre un error durante la solicitud, imprime el error y devuelve un mensaje de error
      print('Error al obtener la ubicación: $e');
      return 'Error al obtener la ubicación';
    }
  }
}
