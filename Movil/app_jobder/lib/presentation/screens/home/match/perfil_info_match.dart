import 'dart:typed_data';
import 'package:app_jobder/config/helpers/crud_red_social.dart';
import 'package:app_jobder/domain/entities/habilidad.dart';
import 'package:app_jobder/domain/entities/red_social.dart';
import 'package:app_jobder/domain/entities/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa el paquete url_launcher

// Las importaciones de las entidades y repositorios fueron eliminadas para simplificar

class UserProfileScreen extends StatefulWidget {
  final UserData user;
  final int usuarioId;
  final String ubicacion; // Nuevo parámetro para recibir la ubicación

  const UserProfileScreen({Key? key, required this.user, required this.usuarioId,required this.ubicacion}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<List<RedSocial>> _redesSocialesFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserRedesSociales();
  }

  Future<void> _fetchUserRedesSociales() async {
    try {
      setState(() {
        _redesSocialesFuture = _fetchRedesSociales(widget.usuarioId);
      });
    } catch (error) {
      throw Exception('Error al obtener redes sociales del usuario: $error');
    }
  }

  Future<List<RedSocial>> _fetchRedesSociales(int usuarioId) async {
    try {
      final redesSociales = await RedesSocialesRepository().getRedesSocialesUsuario(usuarioId);
      return redesSociales;
    } catch (error) {
      throw Exception('Error al obtener redes sociales del usuario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  SafeArea(
                    child: _buildUserImage(), // Envuelve la imagen con SafeArea
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Text(
                      widget.user.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            iconTheme: IconThemeData(color: Colors.black, size: 32.0), // Personaliza el tamaño de la flecha del AppBar
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 7),
                      Row( // Nuevo Row para mostrar la ubicación del usuario
                        children: [
                          Icon(Icons.location_on, size: 24, color: Colors.blueGrey[800]),
                          SizedBox(width: 10),
                          Text(
                            'Ciudad:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            widget.ubicacion, // Mostrar la ubicación del usuario
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blueGrey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      _buildInfoRow(Icons.cake, 'Edad:', '${widget.user.age} años'),
                      _buildInfoRow(Icons.star, 'Habilidades:', _formatHabilidades(widget.user.habilidades)),
                      _buildInfoRow(Icons.category, 'Categoría:', widget.user.categoria ?? 'No disponible'),
                      _buildInfoRow(Icons.person, 'Descripción:', widget.user.descripcion ?? 'No disponible'),
                    ],
                  ),
                ),
                _buildRedesSocialesWidget(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Al presionar el botón flotante, realizar Navigator.pop
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
    );
  }



  Widget _buildUserImage() {
    final imageUrl = widget.user.imageUrl;
    
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
              return Padding(
                padding: const EdgeInsets.only(top: 100), // Ajuste del margen superior
                child: Image.memory(
                  snapshot.data!,
                  fit: BoxFit.fitWidth, // Ajuste para que la imagen se ajuste horizontalmente
                ),
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
        imageUrl, // No es necesario el operador ?? aquí
        fit: BoxFit.fitWidth, // Ajuste para que la imagen se ajuste horizontalmente
      );
    }
  }



  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.blueGrey[800],
            size: 24,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedesSocialesWidget() {
    return FutureBuilder<List<RedSocial>>(
      future: _redesSocialesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final redesSociales = snapshot.data ?? [];
          if (redesSociales.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, left: 16),
                  child: Text(
                    'Redes sociales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
                  ),
                ),
                SizedBox(height: 2),
                Column(
                  children: redesSociales.map((redSocial) {
                    return _buildRedSocialWidget(redSocial);
                  }).toList(),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _buildRedSocialWidget(RedSocial redSocial) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          _launchSocialMedia(redSocial.nombre.toLowerCase(), redSocial.nombreUsuarioAplicacion);
        },
        child: Row(
          children: [
            SvgPicture.asset(
              _getRedSocialIconPath(redSocial.nombre),
              width: 25,
              height: 25,
            ),
            SizedBox(width: 8),
            Text(
              redSocial.nombreUsuarioAplicacion,
              style: TextStyle(fontSize: 18, color: Colors.lightBlue[800]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatHabilidades(List<Habilidad>? habilidades) {
    if (habilidades == null || habilidades.isEmpty) {
      return 'Sin habilidades';
    }
    return habilidades
        .map((habilidad) => habilidades.firstWhere(
              (hab) => hab.habilidadId == habilidad.habilidadId,
              orElse: () => Habilidad(
                habilidadId: habilidad.habilidadId,
                nombre: 'Habilidad desconocida',
              ),
            )
            .nombre)
        .join(', ');
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

  String _getRedSocialIconPath(String redSocial) {
    switch (redSocial.toLowerCase()) {
      case 'instagram':
        return 'assets/icons/instagram.svg';
      case 'github':
        return 'assets/icons/github.svg';
      case 'linkedin':
        return 'assets/icons/linkedin.svg';
      default:
        return '';
    }
  }

  Future<void> _launchSocialMedia(String socialMedia, String username) async {
    late Uri url;
    switch (socialMedia) {
      case 'instagram':
        url = Uri.parse('https://www.instagram.com/$username/');
        break;
      case 'github':
        url = Uri.parse('https://github.com/$username');
        break;
      case 'linkedin':
        url = Uri.parse('https://www.linkedin.com/in/$username/');
        break;
      default:
        return;
    }
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }
}
