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

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
    _getUsuariosCercanos(); // Llama a la función para obtener usuarios cercanos al iniciar la pantalla
  }

  void _checkAndRequestLocationPermission() async {
    bool permissionGranted = false;
  
    while (!permissionGranted) {
      permissionGranted = await LocationPermissionHelper.requestLocationPermission(context);
      
      if (!permissionGranted) {
        // En este punto, el permiso de ubicación no fue concedido.
        // Puedes mostrar un mensaje o tomar cualquier otra acción necesaria.
        
        // Verificar si el usuario concedió el permiso después de volver desde la configuración
        LocationPermission updatedPermission = await Geolocator.checkPermission();
        if (updatedPermission == LocationPermission.denied) {
          // El usuario sigue sin conceder el permiso, por lo que no se le permite ir a ningún lado
          // Aquí puedes mostrar un mensaje adicional o tomar otra acción necesaria
        }
      }
    }
  }

  void _getUsuariosCercanos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('usuario_id'); // Ahora userId es un String nullable
      int? userIdInt = int.tryParse(userId ?? ''); // Convertir el ID de usuario de String a int
      print('User ID: $userIdInt');
      if (userIdInt != null) {
        List<UsuarioCercano> usuariosCercanos = await matchRepository.getUsuariosCercanos(userIdInt);
        print('Usuarios cercanos: $usuariosCercanos');
        setState(() {
          // Convertir cada UsuarioCercano a UserData y agregarlo a la lista _users
          _users = usuariosCercanos.map((usuario) {
            print('Usuario: ${usuario.nombre}');
            print('Foto de perfil: ${usuario.fotoPerfil}');
            print('Descripción: ${usuario.descripcion}');
            return usuario.toUserData();
          }).toList();
        });
      } else {
        print('Error: userId no es un entero válido.');
      }
    } catch (error) {
      print('Error al obtener usuarios cercanos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isControllerAvailable = mounted;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make app bar transparent
        elevation: 0, // Remove app bar elevation
        title: const Row(
          children: [
            Icon(Icons.work), // Icono de trabajo
            SizedBox(width: 8), // Espacio entre el icono y el título
            Text('Jobder'), // Título
          ],
        ),
      ),
      extendBodyBehindAppBar: true, // Extend body behind app bar
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
              Expanded(
                child: _users.isNotEmpty
                    ? CardSwiper(
                        controller: controller,
                        cardsCount: _users.length,
                        cardBuilder: (context, index, percentX, percentY) {
                          final user = _users[index];
                          return UserCard(
                            user: user,
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
                            habilidades: _usuarioHabilidades, // Pasar la lista de habilidades al UserCard
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No more users to match!',
                          style: TextStyle(fontSize: 18),
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
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final CardSwiperController? controller;
  final List<Habilidad>? habilidades; // Lista de habilidades

  const UserCard({
    Key? key,
    required this.user,
    this.controller,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.habilidades, // Actualizado
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Aquí puedes navegar a la pantalla del perfil del usuario
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(user: user),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      image: DecorationImage(
                        image: NetworkImage(user.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: FutureBuilder<Uint8List>(
                      future: _loadImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            // En caso de error, cargar la imagen de assets
                            return Image.asset(
                              'assets/images/user.jpeg',
                              fit: BoxFit.cover,
                            );
                          } else {
                            // Si no hay error, mostrar la imagen desde la red
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          }
                        } else {
                          // Mientras se está cargando la imagen, mostrar un indicador de progreso
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
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
                            Icon(Icons.star, size: 17, color: Colors.black87),
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
                            Icon(Icons.cake, size: 17, color: Colors.black87,),
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
                            Icon(Icons.category, size: 17, color: Colors.black87,),
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
                            Icon(Icons.description, size: 17, color: Colors.black87,),
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
                            Icon(Icons.location_on, size: 17, color: Colors.black87),
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
                                      'Ubicación: ${snapshot.data ?? 'No disponible'}',
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
                onPressed: onSwipeLeft,
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
                onPressed: onSwipeRight,
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
      throw error;
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

