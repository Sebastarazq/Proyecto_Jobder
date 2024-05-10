import 'dart:typed_data';
import 'package:app_jobder/config/helpers/crud_habilidades.dart';
import 'package:app_jobder/config/helpers/crud_red_social.dart';
import 'package:app_jobder/domain/entities/habilidad_asociada.dart';
import 'package:app_jobder/domain/entities/match.dart';
import 'package:app_jobder/domain/entities/red_social_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilMatchScreen extends StatefulWidget {
  final UserMatch userMatch;
  final String cityName;

  const PerfilMatchScreen({Key? key, required this.userMatch, required this.cityName}) : super(key: key);

  @override
  _PerfilMatchScreenState createState() => _PerfilMatchScreenState();
}

class _PerfilMatchScreenState extends State<PerfilMatchScreen> {
  final HabilidadesRepository habilidadesRepository = HabilidadesRepository();
  final RedesSocialesRepository redesSocialesRepository = RedesSocialesRepository();
  List<HabilidadUsuarioHabilidad> habilidadesUsuario = [];
  List<RedSocialUsuario> redesSocialesUsuario = []; // Inicializa con una lista vacía

  @override
  void initState() {
    super.initState();
    _loadHabilidades();
    _loadRedesSociales();
  }

  Future<void> _loadHabilidades() async {
    try {
      final habilidadesResponse = await habilidadesRepository.getHabilidadesUsuarioHabilidad(widget.userMatch.usuario1Id);
      print('Habilidades: $habilidadesResponse');

      setState(() {
        habilidadesUsuario = habilidadesResponse.habilidades;
      });
    } catch (error) {
      print('Error al cargar las habilidades: $error');
    }
  }

  Future<void> _loadRedesSociales() async {
    try {
      final redesSocialesResponse = await redesSocialesRepository.obtenerRedesSocialesUsuarioRedes(widget.userMatch.usuario1Id);
      print('Redes Sociales: $redesSocialesResponse');

      setState(() {
        redesSocialesUsuario = redesSocialesResponse;
      });
    } catch (error) {
      print('Error al cargar las redes sociales: $error');
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
                    child: _buildUserImage(widget.userMatch.usuario1.foto_perfil ?? ''),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Text(
                      widget.userMatch.usuario1.nombre,
                      style: const TextStyle(
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
            iconTheme: const IconThemeData(color: Colors.black, size: 32.0),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(Icons.location_on, 'Ciudad:', widget.cityName),
                      const SizedBox(height: 10),
                      _buildInfoRow(Icons.cake, 'Edad:', '${widget.userMatch.usuario1.edad} años'),
                      const SizedBox(height: 10),
                      HabilidadesWidget(habilidades: habilidadesUsuario),
                      const SizedBox(height: 10),
                      _buildInfoRow(Icons.category, 'Categoría:', widget.userMatch.usuario1.categoria),
                      const SizedBox(height: 10),
                      _buildInfoRow(Icons.person, 'Descripción:', widget.userMatch.usuario1.descripcion ?? 'No disponible'),
                      const SizedBox(height: 15),
                      _buildRedesSocialesWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }

  Future<Uint8List> _loadImage(double width, double height) async {
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
        future: _loadImage(80, 80), // Especifica el ancho y alto deseados
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
                width: 80, // Usa el mismo ancho que se especificó en _loadImage
                height: 80, // Usa el mismo alto que se especificó en _loadImage
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
        width: 80,
        height: 80,
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blueGrey[800]),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedesSocialesWidget() {
  if (redesSocialesUsuario.isEmpty) {
    return SizedBox.shrink(); // Si no hay redes sociales, devuelve un widget vacío
  } else {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Redes Sociales',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
        const SizedBox(height: 2), // Espacio mínimo entre el título y la lista
        ...redesSocialesUsuario.map((redSocial) {
          return ListTile(
            leading: _getRedSocialIcon(redSocial.nombre),
            title: Text(
              redSocial.nombre,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[800],
              ),
            ),
            subtitle: Text(
              redSocial.nombreUsuarioAplicacion,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey[600],
              ),
            ),
            onTap: () {
              _launchSocialMedia(
                  redSocial.nombre.toLowerCase(), redSocial.nombreUsuarioAplicacion);
            },
          );
        }).toList(),
      ],
    );
  }
}

  Widget _getRedSocialIcon(String redSocial) {
    final iconPath = _getRedSocialIconPath(redSocial);
    if (iconPath.isNotEmpty) {
      return SvgPicture.asset(iconPath, width: 24, height: 24); // Cargar el SVG como una imagen
    } else {
      return const Icon(Icons.link); // Por defecto, usar un icono de enlace
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

  String _formatHabilidades() {
    if (habilidadesUsuario.isEmpty) {
      return 'No disponible';
    } else {
      return habilidadesUsuario.map((habilidad) => habilidad.nombre).join(', ');
    }
  }
}

class HabilidadesWidget extends StatelessWidget {
  final List<HabilidadUsuarioHabilidad> habilidades;

  const HabilidadesWidget({Key? key, required this.habilidades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (habilidades.isEmpty) {
      return Text(
        'No hay habilidades',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[800],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work, size: 24, color: Colors.blueGrey[800]),
              const SizedBox(width: 10),
              Text(
                'Habilidades:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: habilidades.map((habilidad) {
              return Chip(
                label: Text(
                  habilidad.nombre,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.blueGrey[700],
              );
            }).toList(),
          ),
        ],
      );
    }
  }
}