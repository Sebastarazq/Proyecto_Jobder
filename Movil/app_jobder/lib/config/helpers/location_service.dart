import 'package:dio/dio.dart';
import 'dart:convert';

class LocationService {
  static Future<String> getLocationName(double latitude, double longitude) async {
    final apiKey = 'AIzaSyChDbImoF6dJf2ASnB2gMou_YRL3x_oM-w';
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';
    print('URL: $url');

    try {
      final dio = Dio();
      final response = await dio.get(url);

      final decodedResponse = json.decode(response.data);

      if (decodedResponse['status'] == 'OK') {
        return decodedResponse['results'][0]['formatted_address'];
      } else {
        return 'No se pudo obtener la ubicación';
      }
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      return 'Error al obtener la ubicación';
    }
  }
}
