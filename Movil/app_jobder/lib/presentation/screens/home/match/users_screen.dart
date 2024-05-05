import 'dart:typed_data';
import 'package:app_jobder/config/helpers/crud_match.dart';
import 'package:app_jobder/config/helpers/location_service.dart';
import 'package:app_jobder/config/helpers/permiso_location.dart';
import 'package:app_jobder/domain/entities/habilidad.dart';
import 'package:app_jobder/domain/entities/usuario_cercano.dart';
import 'package:app_jobder/presentation/screens/home/match/perfil_info_match.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:app_jobder/domain/entities/user_data.dart';
import 'package:app_jobder/presentation/screens/shared/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  static const String name = 'user_screen';

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final CardSwiperController controller = CardSwiperController();
  final LocationPermissionHelper locationPermissionHelper = LocationPermissionHelper();
  final MatchRepository matchRepository = MatchRepository(); // Instancia del repositorio de Match
  List<UserData> _users = []; // Lista de usuarios
  List<Habilidad>? _usuarioHabilidades; // Lista de habilidades del usuario
  int userIdInt = 0; // Actualización: Variable de instancia para almacenar userIdInt, inicializada con un valor predeterminado de 0
  bool _hasLocationPermission = false;
  bool _hasExitedWithoutGrantingPermission = false;
  List<int> _usersWithMatch = []; // Lista para almacenar los IDs de los usuarios con match creado
  List<int> _rejectedUsers = []; // Lista para almacenar los IDs de los usuarios rechazados

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
    _getUsuariosCercanos(); // Llama a la función para obtener usuarios cercanos al iniciar la pantalla
  }

  void _handleCreateMatch(int userId) {
    setState(() {
      _usersWithMatch.add(userId);
    });
    _getUsuariosCercanos();
  }

  void _handleRejectUser(int userId) {
    setState(() {
      _rejectedUsers.add(userId);
    });
    _getUsuariosCercanos();
  }
  void _checkAndRequestLocationPermission() async {
    bool permissionGranted = false;
    _hasExitedWithoutGrantingPermission = false;

    while (!permissionGranted && !_hasExitedWithoutGrantingPermission) {
      permissionGranted = await LocationPermissionHelper.requestLocationPermission(context);

      if (!permissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Es necesario conceder acceso a la ubicación para utilizar esta función.'),
            action: SnackBarAction(
              label: 'Configuración',
              onPressed: () {
                Geolocator.openAppSettings();
              },
            ),
          ),
        );

        LocationPermission updatedPermission = await Geolocator.checkPermission();
        if (updatedPermission == LocationPermission.denied) {
          final shouldRetry = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permiso de ubicación'),
              content: const Text('No ha concedido el permiso de ubicación. ¿Desea volver a intentarlo?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Sí'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          );

          if (!shouldRetry) {
            _hasExitedWithoutGrantingPermission = true;
          }
        }
      } else {
        setState(() {
          _hasLocationPermission = true;
        });
      }
    }

    if (!permissionGranted && _hasExitedWithoutGrantingPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se puede continuar sin conceder los permisos de ubicación.'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    if (!permissionGranted) {
      setState(() {
        _hasLocationPermission = false;
      });
    }
  }

  void _getUsuariosCercanos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('usuario_id');
      userIdInt = int.tryParse(userId ?? '') ?? 0; // Asigna userIdInt con un valor predeterminado de 0 si userId es nulo o no se puede convertir a int
      print('User ID: $userIdInt');
      if (userIdInt != 0) { // Verifica que userIdInt no sea igual a 0 antes de llamar a matchRepository.getUsuariosCercanos()
        List<UsuarioCercano> usuariosCercanos = await matchRepository.getUsuariosCercanos(userIdInt);
        print('Usuarios cercanos: $usuariosCercanos');
        
        setState(() {
        _users = usuariosCercanos.map((usuario) {
          // Filtra los usuarios que ya tienen un match creado o fueron rechazados
          if (_usersWithMatch.contains(usuario.usuarioId) || _rejectedUsers.contains(usuario.usuarioId)) {
            return null; // Omite este usuario
          }
          print('usuario_id: ${usuario.usuarioId}');
          print('Usuario: ${usuario.nombre}');
          print('Foto de perfil: ${usuario.fotoPerfil}');
          print('Descripción: ${usuario.descripcion}');
          return usuario.toUserData();
        }).whereType<UserData>().toList();
      });
      } else {
        print('Error: userId no es un entero válido.');
      }
    } catch (error) {
      // Captura cualquier excepción ocurrida y muestra un mensaje apropiado
      setState(() {
        _users = []; // Vacía la lista de usuarios para evitar el error
      });
      print('Error al obtener usuarios cercanos: $error');
    }
  }

 @override
Widget build(BuildContext context) {
  if (!_hasLocationPermission || _hasExitedWithoutGrantingPermission) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Es necesario conceder acceso a la ubicación para utilizar esta aplicación.',
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: _checkAndRequestLocationPermission,
              child: const Text('Solicitar permisos'),
            ),
          ],
        ),
      ),
    );
  }

  final bool isControllerAvailable = mounted;

  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Row(
        children: [
          Icon(Icons.work),
          SizedBox(width: 8),
          Text('Jobder'),
        ],
      ),
    ),
    extendBodyBehindAppBar: true,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEE805F), Color(0xFF096BFF)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            if (_users.isNotEmpty)
              Expanded(
                child: CardSwiper(
                  controller: controller,
                  cardsCount: _users.length,
                  numberOfCardsDisplayed: _users.length == 1 ? 1 : 2,
                  cardBuilder: (context, index, percentX, percentY) {
                    try {
                      final user = _users[index];
                      return UserCard(
                        user: user,
                        userIdInt: userIdInt,
                        controller: controller,
                        onSwipeLeft: () {
                          if (isControllerAvailable) {
                            controller.swipe(CardSwiperDirection.left);
                          }
                        },
                        onSwipeRight: () {
                          if (isControllerAvailable) {
                            controller.swipe(CardSwiperDirection.right);
                          }
                        },
                        habilidades: _usuarioHabilidades,
                        onCreateMatch: _handleCreateMatch, // Pasa el método callback
                        onRejectUser: _handleRejectUser, // Pasa el método callback
                      );
                    } catch (e) {
                      // Maneja la excepción de manera adecuada
                      print('Error al construir la tarjeta del usuario: $e');
                      return Container(); // Puedes retornar un contenedor vacío u otro widget según lo necesites
                    }
                  },
                )
              ),
           if (_users.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No hay más usuarios para mostrar',
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins', fontWeight: FontWeight.w500, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20), // Espacio entre el texto y el botón
                    ElevatedButton(
                      onPressed: () {
                        // Vaciar las listas _usersWithMatch y _rejectedUsers
                        setState(() {
                          _usersWithMatch.clear();
                          _rejectedUsers.clear();
                        });
                        // Llamar a la función para obtener nuevos usuarios
                        _getUsuariosCercanos(); 
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF096BFF), // Color del botón
                      ),
                      child: const Text('Realizar otra búsqueda'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
  );
}
}

class UserCard extends StatelessWidget {
  final UserData user;
  final int userIdInt; // Agregado userIdInt como parámetro
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final CardSwiperController? controller;
  final List<Habilidad>? habilidades; // Lista de habilidades
  final Function(int) onCreateMatch; // Callback para crear un match
  final Function(int) onRejectUser; // Callback para rechazar un usuario



  UserCard({
    Key? key,
    required this.user,
    required this.userIdInt, // Agregado userIdInt como parámetro
    this.controller,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.habilidades, // Actualizado
    required this.onCreateMatch, // Agregado el parámetro onCreateMatch
    required this.onRejectUser, // Agregado el parámetro onRejectUser
    
  }) : super(key: key);

  final MatchRepository _matchRepository = MatchRepository();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ubicacion = await LocationService.getCityName(
          double.parse(user.latitud),
          double.parse(user.longitud),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              user: user,
              usuarioId: int.parse(user.id),
              ubicacion: ubicacion,
            ),
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: _buildUserImage(user.imageUrl),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 17, color: Colors.black87),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Habilidades: ${_formatHabilidades(user.habilidades)}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.cake, size: 17, color: Colors.black87,),
                            const SizedBox(width: 5),
                            Text(
                              '${user.age} años',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.category, size: 17, color: Colors.black87,),
                            const SizedBox(width: 5),
                            Text(
                              'Categoría: ${user.categoria ?? 'No disponible'}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.description, size: 17, color: Colors.black87,),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                'Descripción: ${_formatDescription(user.descripcion)}',
                                style: const TextStyle(
                                  color: Colors.black87, // Letras más oscuras
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 17, color: Colors.black87),
                            const SizedBox(width: 5),
                            Expanded(
                              child: FutureBuilder<String>(
                                future: LocationService.getCityName(
                                  double.parse(user.latitud), // Convertir la latitud de String a double
                                  double.parse(user.longitud), // Convertir la longitud de String a double
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Text(
                                      'Ciudad: ${snapshot.data ?? 'No disponible'}',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 15.0,
              left: 80.0,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  onRejectUser(int.parse(user.id)); // Llama al callback para rechazar usuario
                  if (onSwipeLeft != null) {
                    onSwipeLeft!();
                  }
                },
                child: const Icon(Icons.close),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            Positioned(
              bottom: 15.0,
              right: 80.0,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  try {
                    final String mensaje = await _matchRepository.crearMatch(
                      userIdInt,
                      int.parse(user.id),
                      true,
                    );
                    onCreateMatch(int.parse(user.id)); // Llama al callback para crear un match
                    print(mensaje);
                  } catch (error) {
                    print('Error al crear match: $error');
                  }
                  if (onSwipeRight != null) {
                    onSwipeRight!();
                  }
                },
                child: const Icon(Icons.check),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Uint8List> _loadImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/images/user.jpeg');
      return data.buffer.asUint8List();
    } catch (error) {
      print('Error loading asset image: $error');
      rethrow; // Lanza la excepción original para ser capturada
    }
  }

  Widget _buildUserImage(String imageUrl) {
    if (imageUrl.toLowerCase().contains('assets')) {
      // Si la URL contiene la cadena "assets", cargar la imagen desde los activos
      return FutureBuilder<Uint8List>(
        future: _loadImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // En caso de error, mostrar un mensaje o un ícono de error
              return const Icon(Icons.error, color: Colors.red);
            } else {
              // Si no hay error, mostrar la imagen desde los bytes cargados
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            }
          } else {
            // Mientras se está cargando la imagen, mostrar un indicador de progreso
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      // Si la URL no contiene la cadena "assets", cargar la imagen desde la red
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
      );
    }
  }

  String _formatHabilidades(List<Habilidad>? habilidades) {
    if (habilidades == null || habilidades.isEmpty) {
      return 'Sin habilidades';
    }
    // Obtener los nombres de las habilidades del usuario usando la lista de todas las habilidades
    return habilidades.map((habilidad) {
      final habilidadEncontrada = habilidades.firstWhere((hab) => hab.habilidadId == habilidad.habilidadId, orElse: () => Habilidad(habilidadId: habilidad.habilidadId, nombre: 'Habilidad desconocida'));
      return habilidadEncontrada.nombre;
    }).join(', ');
  }

  String _formatDescription(String? description) {
    if (description == null) return 'No disponible';
    if (description.length <= 50) return description;
    return '${description.substring(0, 50)}...';
  }
}

