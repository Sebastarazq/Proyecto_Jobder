import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_jobder/config/helpers/crud_match.dart';
import 'package:app_jobder/config/helpers/location_service.dart';
import 'package:app_jobder/domain/entities/match.dart';
import 'package:app_jobder/presentation/screens/jobmatch/perfil_jobmatch/perfil_match.dart';

class PendingMatchesScreen extends StatefulWidget {
  const PendingMatchesScreen({Key? key}) : super(key: key);

  @override
  _PendingMatchesScreenState createState() => _PendingMatchesScreenState();
}

class _PendingMatchesScreenState extends State<PendingMatchesScreen> {
  List<UserMatch> matches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('usuario_id') ?? '';
    int userIdInt = int.tryParse(userId) ?? 0;
    String token = prefs.getString('auth_token') ?? '';
    List<UserMatch> fetchedMatches = await MatchRepository().obtenerMatches(userIdInt, token);
    setState(() {
      matches = fetchedMatches;
      _isLoading = false;
    });
  } catch (error) {
    print('Error al obtener matches: $error');
    if (error.toString().contains('Token de autenticación inválido o expirado')) {
      // Mostrar diálogo de alerta
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sesión Caducada'),
            content: Text('Tu sesión ha caducado. Por favor, inicia sesión nuevamente.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  // Eliminar el token auth_token de SharedPreferences
                  SharedPreferences.getInstance().then((prefs) => prefs.remove('auth_token'));
                  // Cerrar el diálogo
                  Navigator.of(context).pop();
                  // Redirigir al usuario a la pantalla de inicio de sesión
                  context.go('/');
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
  Future<String> _getCityName(double latitude, double longitude) async {
    try {
      String cityName = await LocationService.getCityName(latitude, longitude);
      return cityName;
    } catch (error) {
      print('Error al obtener el nombre de la ciudad: $error');
      return 'Error al obtener la ciudad';
    }
  }

  Future<Uint8List> _loadImage(double width, double height) async {
    try {
      final ByteData data = await rootBundle.load('assets/images/user.jpeg');
      return data.buffer.asUint8List();
    } catch (error) {
      print('Error loading asset image: $error');
      rethrow;
    }
  }

  Widget _buildUserImage(String imageUrl) {
    if (imageUrl.toLowerCase().contains('assets')) {
      return FutureBuilder<Uint8List>(
        future: _loadImage(80, 80),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Icon(Icons.error, color: Colors.red);
            } else {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: 80,
        height: 80,
      );
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      width: MediaQuery.of(context).size.width * 0.8,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _aprobarMatch(int matchId) async {
    try {
      String message = await MatchRepository().aprobarMatch(matchId);
      _showSnackbar(context, message); // Aquí se pasa el context

      // Limpiar la lista de matches
      matches.clear();

      // Refrescar la pantalla después de aprobar el match
      await _fetchMatches();
    } catch (error) {
      _showSnackbar(context, 'Error al aprobar match: $error'); // Aquí se pasa el context
    }
  }

  // Método para denegar un match
  Future<void> _denegarMatch(int matchId) async {
    try {
      String message = await MatchRepository().denegarMatch(matchId);
      _showSnackbar(context, message); // Mostrar SnackBar
      // Limpiar la lista de matches
      matches.clear();
      // Refrescar la pantalla después de denegar el match
      await _fetchMatches();
    } catch (error) {
      _showSnackbar(context, 'Error al denegar match: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : matches.isEmpty
              ? const Center(
                  child: Text(
                    'No hay matches pendientes',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final UserMatch match = matches[index];
                    final usuario2 = match.usuario1;

                    return FutureBuilder(
                      future: _getCityName(usuario2.latitud ?? 0.0, usuario2.longitud ?? 0.0),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          String cityName = snapshot.data.toString();
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerfilMatchScreen(
                                    userMatch: match,
                                    cityName: cityName,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: _buildUserImage(usuario2.foto_perfil ?? ''),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            usuario2.nombre,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            usuario2.email,
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Categoría: ${usuario2.categoria}',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Ubicación: $cityName',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          _denegarMatch(match.matchId);
                                        },
                                      ),
                                        const SizedBox(height: 8),
                                        IconButton(
                                          icon: const Icon(Icons.check),
                                          onPressed: () {
                                            _aprobarMatch(match.matchId);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
    );
  }
}
