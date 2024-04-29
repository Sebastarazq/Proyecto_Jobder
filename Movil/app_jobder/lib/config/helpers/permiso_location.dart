import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionHelper {
  static Future<bool> requestLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final dialogResult = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Jobder necesita acceso a tu ubicación'),
          content: Text('Para encontrar coincidencias cercanas, Jobder necesita acceder a tu ubicación. ¿Quieres permitir el acceso a tu ubicación?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Usuario rechazó el permiso
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Usuario concedió el permiso
              },
              child: Text('Sí'),
            ),
          ],
        ),
      );

      if (dialogResult == true) {
        // Solicitar el permiso de ubicación directamente después de que el usuario haya dado su consentimiento
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          // El usuario ha denegado permanentemente los permisos.
          // Puedes redirigirlo a la configuración de ubicación.
          Geolocator.openAppSettings();
        }
      } else {
        // El usuario rechazó el permiso de ubicación, redirigir a la configuración de la aplicación
        Geolocator.openAppSettings();

        // Verificar si el usuario concedió el permiso después de volver desde la configuración
        LocationPermission updatedPermission = await Geolocator.checkPermission();
        if (updatedPermission == LocationPermission.denied) {
          // El usuario sigue sin conceder el permiso, por lo que no se le permite ir a ningún lado
          return false;
        }
      }
      return dialogResult == true;
    } else {
      return true; // Permiso ya concedido previamente
    }
  }
}