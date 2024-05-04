import 'package:app_jobder/config/helpers/crud_red_social.dart';
import 'package:app_jobder/domain/entities/red_social_basica.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_jobder/domain/entities/red_social.dart';


class RedSocialFormField extends StatelessWidget {
  final RedSocial redSocial;
  final ValueChanged<String> onChanged;

  const RedSocialFormField({
    Key? key,
    required this.redSocial,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: RedSocialIcon(redSocial: redSocial.nombre),
          title: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              initialValue: redSocial.nombreUsuarioAplicacion,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: redSocial.nombre,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class RedSocialIcon extends StatelessWidget {
  final String redSocial;

  const RedSocialIcon({Key? key, required this.redSocial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String iconPath = _getRedSocialIconPath(redSocial);
    return SvgPicture.asset(iconPath, width: 24, height: 24);
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
}

class EditRedesSocialesScreen extends StatefulWidget {
  final int userId;

  const EditRedesSocialesScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _EditRedesSocialesScreenState createState() =>
      _EditRedesSocialesScreenState();
}

class _EditRedesSocialesScreenState extends State<EditRedesSocialesScreen> {
  final RedesSocialesRepository _redesSocialesRepository =
      RedesSocialesRepository();
  List<RedSocial> _redesSocialesUsuario = [];
  List<RedSocial> _todasLasRedesSociales = [];

  @override
  void initState() {
    super.initState();
    _fetchRedesSociales();
  }

  List<Map<String, dynamic>> _prepararDatosParaEnviar() {
    final datosParaEnviar = <Map<String, dynamic>>[];

    for (var redSocial in _todasLasRedesSociales) {
      if (redSocial.nombreUsuarioAplicacion.isNotEmpty) {
        datosParaEnviar.add({
          'usuario_id': widget.userId,
          'red_id': redSocial.redId,
          'nombre_usuario_aplicacion': redSocial.nombreUsuarioAplicacion,
        });
      }
    }

    return datosParaEnviar;
  }

  Future<void> _fetchRedesSociales() async {
  try {
    // Consulta todas las redes sociales y crea el formulario con sus campos
    List<RedSocialBasica> redesSocialesBasica =
        await _redesSocialesRepository.getAllRedesSociales();
    _todasLasRedesSociales = redesSocialesBasica
        .map((redSocialBasica) => RedSocial(
              redId: redSocialBasica.redId,
              nombre: redSocialBasica.nombre,
              nombreUsuarioAplicacion: '',
            ))
        .toList();

    // Obtén las redes sociales del usuario
    _redesSocialesUsuario =
        await _redesSocialesRepository.getRedesSocialesUsuario(widget.userId);

    // Actualiza los valores de nombreUsuarioAplicacion en _todasLasRedesSociales
    for (var redSocialUsuario in _redesSocialesUsuario) {
      int index = _todasLasRedesSociales.indexWhere((rs) => rs.redId == redSocialUsuario.redId);
      if (index != -1) {
        _todasLasRedesSociales[index] = redSocialUsuario;
      }
    }

    setState(() {});
  } catch (error) {
    print('Error al obtener las redes sociales: $error');
  }
}

  Future<void> _fetchRedesSocialesUsuario() async {
    try {
      _redesSocialesUsuario =
          await _redesSocialesRepository.getRedesSocialesUsuario(widget.userId);

      setState(() {
        _todasLasRedesSociales = _redesSocialesUsuario;
      });
    } catch (error) {
      print('Error al obtener las redes sociales del usuario: $error');
    }
  }

   void _mostrarDialog(String mensaje, Color colorFondo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mensaje'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true); 
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Redes Sociales'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _todasLasRedesSociales.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  for (var redSocial in _todasLasRedesSociales)
                    RedSocialFormField(
                      redSocial: redSocial,
                      onChanged: (value) {
                        setState(() {
                          int index = _todasLasRedesSociales.indexOf(redSocial);
                          _todasLasRedesSociales[index] = redSocial.copyWith(nombreUsuarioAplicacion: value);
                        });
                      },
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final datosParaEnviar = _prepararDatosParaEnviar();
                      if (datosParaEnviar.isNotEmpty) {
                        try {
                          await _redesSocialesRepository
                              .asociarRedesSociales(datosParaEnviar);
                          _mostrarDialog(
                              'Tus redes sociales se han actualizado correctamente',
                              Colors.green);
                        } catch (error) {
                          _mostrarDialog(
                              'Ops, algo salió mal. Inténtalo nuevamente.',
                              Colors.red);
                        }
                      } else {
                        _mostrarDialog('No hay datos para enviar', Colors.amber);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      backgroundColor: const Color(0xFF096BFF),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 30,
                      width: 200,
                      child: const Text(
                        'Guardar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}