import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_jobder/presentation/screens/shared/widgets/navigation_bar.dart';

class UbicacionScreen extends StatefulWidget {
  static const String name = 'ubicacion_screen';
  const UbicacionScreen({Key? key}) : super(key: key);

  @override
  State<UbicacionScreen> createState() => _UbicacionScreenState();
}

class _UbicacionScreenState extends State<UbicacionScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  LatLng _initialCameraPosition = const LatLng(3.7275, -80.7614); // Posición inicial del mapa para ver Colombia desde más lejos
  Set<Marker> _markers = {}; // Conjunto de marcadores
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Obtener la ubicación del usuario al iniciar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal, // Cambio a mapa normal
            initialCameraPosition: CameraPosition(target: _initialCameraPosition, zoom: 5.0),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers, // Agrega los marcadores al mapa
            zoomControlsEnabled: false, // Desactiva los botones + y -
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(), // Indicador de carga
            ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: _goToUserLocation,
        label: const Text(
          'Mi Ubicación',
          style: TextStyle(
            color: Colors.white, // Cambia el color del texto a blanco
          ),
        ),
        icon: const Icon(
          Icons.my_location,
          color: Colors.white, // Cambia el color del icono a blanco
        ),
        backgroundColor: const Color(0xFF096BFF), // Cambia el color de fondo del botón a azul
        foregroundColor: Colors.white, // Cambia el color de la sombra del botón a blanco
        splashColor: Colors.grey, // Cambia el color del efecto de salpicadura cuando se presiona el botón a gris
      ),
    );
  }

  Future<void> _getUserLocation() async {
    try {
      // Verifica si el usuario otorgó permiso para acceder a la ubicación
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Si el servicio de ubicación no está habilitado, muestra un diálogo para solicitar su activación
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Servicio de ubicación desactivado'),
            content: const Text('Por favor, activa el servicio de ubicación para continuar.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // Abre la configuración del dispositivo para que el usuario pueda habilitar el servicio de ubicación
                  Geolocator.openLocationSettings();
                },
                child: const Text('Configuración'),
              ),
            ],
          ),
        );
        return;
      }

      // Verifica si la aplicación tiene permiso para acceder a la ubicación
      PermissionStatus permission = await Permission.location.status;
      if (permission == PermissionStatus.denied) {
        // Si la aplicación no tiene permiso, solicita permiso al usuario
        permission = await Permission.location.request();
        if (permission == PermissionStatus.denied) {
          // Si el usuario niega el permiso, muestra un mensaje y sale del método
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permiso de ubicación denegado'),
              content: const Text('Para usar esta función, necesitas otorgar permiso de ubicación a la aplicación.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }
      }

      // Obtiene la ubicación del usuario
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _initialCameraPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false; // Se detiene la carga
      });

      // Agrega el marcador en la ubicación del usuario
      _markers.add(
        Marker(
          markerId: const MarkerId("userLocation"),
          position: _initialCameraPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), 
        ),
      );

      // Centra el mapa en la ubicación del usuario al abrir la pantalla
      _goToUserLocation();
    } catch (e) {
      // Manejo de errores
      print('Error al obtener la ubicación: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Hubo un error al obtener tu ubicación. Por favor, inténtalo de nuevo más tarde.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _goToUserLocation() async {
    try {
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newLatLngZoom(_initialCameraPosition, 15));
    } catch (e) {
      // Manejo de errores
      print('Error al ir a la ubicación del usuario: $e');
    }
  }
}
