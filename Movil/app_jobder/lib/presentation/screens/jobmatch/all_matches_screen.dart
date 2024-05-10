import 'dart:typed_data';

import 'package:app_jobder/config/helpers/crud_match.dart';
import 'package:app_jobder/config/helpers/location_service.dart';
import 'package:app_jobder/domain/entities/match.dart';
import 'package:app_jobder/presentation/screens/jobmatch/perfil_jobmatch/perfil_match.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllMatchesScreen extends StatefulWidget {
  const AllMatchesScreen({Key? key}) : super(key: key);

  @override
  _AllMatchesScreenState createState() => _AllMatchesScreenState();
}

class _AllMatchesScreenState extends State<AllMatchesScreen> {
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

      List<UserMatch> fetchedMatches = await MatchRepository().obtenerMatchesCompletados(userIdInt);
      setState(() {
        matches = fetchedMatches;
        _isLoading = false;
      });
    } catch (error) {
      print('Error al obtener matches: $error');
      // Handle error as needed
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Method to get the city name using user's location
  Future<String> _getCityName(double latitude, double longitude) async {
    try {
      String cityName = await LocationService.getCityName(latitude, longitude);
      return cityName;
    } catch (error) {
      print('Error obtaining city name: $error');
      return 'Error obtaining city';
    }
  }

  Future<Uint8List> _loadImage(double width, double height) async {
    try {
      final ByteData data = await rootBundle.load('assets/images/user.jpeg');
      return data.buffer.asUint8List();
    } catch (error) {
      print('Error loading asset image: $error');
      rethrow; // Throw the original exception to be caught
    }
  }

  Widget _buildUserImage(String imageUrl) {
    if (imageUrl.toLowerCase().contains('assets')) {
      // If URL contains "assets" string, load image from assets
      return FutureBuilder<Uint8List>(
        future: _loadImage(80, 80), // Specify desired width and height
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // In case of error, show a message or an error icon
              return const Icon(Icons.error, color: Colors.red);
            } else {
              // If no error, show the image from loaded bytes
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                width: 80, // Use the same width as specified in _loadImage
                height: 80, // Use the same height as specified in _loadImage
              );
            }
          } else {
            // While image is loading, show a progress indicator
            return const CircularProgressIndicator();
          }
        },
      );
    } else {
      // If URL doesn't contain "assets" string, load image from network
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: 80,
        height: 80,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : matches.isEmpty
              ? Center(
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
                              // Navigate to PerfilMatchScreen and pass the UserMatch object and the city
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PerfilMatchScreen(
                                    userMatch: match,
                                    cityName: cityName, // Pass the city name
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
