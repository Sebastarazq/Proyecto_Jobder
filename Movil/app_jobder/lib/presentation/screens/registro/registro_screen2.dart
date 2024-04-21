import 'package:flutter/material.dart';
import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:app_jobder/presentation/screens/registro/email_code_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_jobder/domain/entities/create_user.dart';

class RegistroScreen2 extends StatefulWidget {
  final String nombre;
  final String email;
  final String celular;
  final String genero;
  final String password;

  const RegistroScreen2({
    Key? key,
    required this.nombre,
    required this.email,
    required this.celular,
    required this.genero,
    required this.password,
  }) : super(key: key);

  static const String name = 'registro_screen_2';

  @override
  State<RegistroScreen2> createState() => _RegistroScreen2State();
}

class _RegistroScreen2State extends State<RegistroScreen2> {
  double _latitude = 0.0;
  double _longitude = 0.0;
  int _edad = 18;
  String _categoria = 'Desarrollador';
  bool _locationPermissionGranted = false;
  bool _loading = false; // Variable para controlar si se está cargando

  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Edad',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _edad,
              onChanged: (value) {
                setState(() {
                  _edad = value ?? _edad;
                });
              },
              items: List.generate(
                100,
                (index) => DropdownMenuItem<int>(
                  value: 18 + index,
                  child: Text((18 + index).toString()),
                ),
              ),
              decoration: const InputDecoration(
                hintText: 'Selecciona tu edad',
                labelText: 'Edad',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Categoría',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _categoria,
              onChanged: (value) {
                setState(() {
                  _categoria = value ?? _categoria;
                });
              },
              items: ['Desarrollador', 'Empresario']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                hintText: 'Selecciona tu categoría',
                labelText: 'Categoría',
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _locationPermissionGranted && !_loading // Solo se puede presionar el botón si no está cargando
                  ? () async {
                      setState(() {
                        _loading = true; // Se establece el estado de carga
                      });
                      await _getLocation();

                      UsuarioCreacion usuario = UsuarioCreacion(
                        nombre: widget.nombre,
                        email: widget.email,
                        celular: int.parse(widget.celular),
                        edad: _edad,
                        genero: widget.genero,
                        password: widget.password,
                        latitud: _latitude,
                        longitud: _longitude,
                        categoria: _categoria,
                      );

                      try {
                        // Llama al método createUser del repositorio
                        await _userRepository.createUser(usuario.toUserModel());
                        // Muestra un diálogo de éxito si el resultado es bueno
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Correo enviado'),
                            content: const Text('Se ha enviado un correo con el código de verificación.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Cierra el diálogo
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VerificationCodeScreen(),
                                    ),
                                  );
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Ops! Algo salió mal'),
                            content: Text(e.toString().replaceAll('Exception:', '')),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } finally {
                        setState(() {
                          _loading = false; // Se establece el estado de carga de nuevo a falso
                        });
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF096BFF),
                minimumSize: const Size(200, 50),
              ),
              child: _loading // Si está cargando, muestra un CircularProgressIndicador, de lo contrario, muestra el texto 'CONTINUE'
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'CONTINUE',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
            if (!_locationPermissionGranted)
              TextButton(
                onPressed: () async {
                  await _requestLocationPermission();
                },
                child: const Text('Volver a solicitar permisos'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    setState(() {
      _locationPermissionGranted =
          permission == LocationPermission.whileInUse ||
              permission == LocationPermission.always;
    });
  }
}
