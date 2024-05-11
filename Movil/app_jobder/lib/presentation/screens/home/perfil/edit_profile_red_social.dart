import 'package:app_jobder/config/helpers/crud_red_social.dart';
import 'package:app_jobder/domain/entities/red_social_basica.dart';
import 'package:app_jobder/domain/entities/red_social_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app_jobder/domain/entities/red_social.dart';


class RedSocialFormField extends StatelessWidget {
  final RedSocial redSocial;
  final int usuarioRedId; // Agregar el usuarioRedId
  final ValueChanged<String> onChanged;
  final Function(int) onDelete; // Definir el parámetro onDelete de tipo Function(int)
  final String initialValue; // Definir el parámetro initialValue

  const RedSocialFormField({
    Key? key,
    required this.redSocial,
    required this.usuarioRedId,
    required this.onChanged,
    required this.onDelete, // Añadir onDelete como un parámetro requerido
    required this.initialValue, // Añadir initialValue como un parámetro requerido
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Initial value: $initialValue'); // Agregar un print para el valor inicial
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: initialValue.isNotEmpty ? initialValue : '', // Usar el parámetro initialValue aquí
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: redSocial.nombre,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDelete(usuarioRedId); // Llamar a la función onDelete con usuarioRedId como argumento
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
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
  final RedesSocialesRepository _crudRedSocial = RedesSocialesRepository();
  List<RedSocialUsuario> _redesSocialesUsuario = [];
  List<RedSocial> _todasLasRedesSociales = []; // Cambiar este tipo a List<RedSocialUsuario>
  Map<int, int> _redesSocialesUsuarioMap = {}; // Crear un mapa para almacenar el usuarioRedId

  @override
  void initState() {
    super.initState();
    _fetchRedesSociales();
  }

  Future<void> _eliminarRedSocial(int redId) async {
    try {
      await _crudRedSocial.eliminarRedSocial(redId); // Llama al método para eliminar la red social
      // Muestra un diálogo indicando que se eliminó correctamente
      _mostrarDialog('Red social eliminada correctamente', Colors.green);
      // Actualiza la lista de redes sociales después de eliminar
      _fetchRedesSociales();
    } catch (error) {
      // Muestra un diálogo de error si no se puede eliminar la red social
      _mostrarDialog('Ops, algo salió mal. Inténtalo nuevamente.', Colors.red);
    }
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
      // Consulta todas las redes sociales básicas
      List<RedSocialBasica> redesSocialesBasica = await _crudRedSocial.getAllRedesSociales();
      
      // Obtén las redes sociales del usuario
      _redesSocialesUsuario = await _crudRedSocial.obtenerRedesSocialesUsuarioRedes(widget.userId);
      
      // Crea una lista de RedSocial combinando las redes sociales básicas y las del usuario
      _todasLasRedesSociales = redesSocialesBasica.map((redSocialBasica) {
        // Busca si hay una instancia de RedSocialUsuario asociada a esta red social
        RedSocialUsuario? redSocialUsuario = _redesSocialesUsuario.firstWhere(
          (rsu) => rsu.redId == redSocialBasica.redId,
          orElse: () => RedSocialUsuario(usuarioRedId: 0, redId: redSocialBasica.redId, nombre: redSocialBasica.nombre, nombreUsuarioAplicacion: ''),
        );
        // Crea una instancia de RedSocial con la información combinada
        return RedSocial(
          redId: redSocialBasica.redId,
          nombre: redSocialBasica.nombre,
          nombreUsuarioAplicacion: redSocialUsuario.nombreUsuarioAplicacion,
        );
      }).toList();
      
      print('Todas las redes sociales: $_todasLasRedesSociales');

      // Luego de inicializar _todasLasRedesSociales, actualiza el mapa de usuarioRedId
      for (var redSocialUsuario in _redesSocialesUsuario) {
        _redesSocialesUsuarioMap[redSocialUsuario.redId] = redSocialUsuario.usuarioRedId;
        print ('Redes sociales del usuario mapa: $_redesSocialesUsuarioMap');
      }

      setState(() {});
    } catch (error) {
    print('Error al obtener las redes sociales: $error');
    // Si hay un error al obtener las redes sociales, generar redes sociales básicas con campos vacíos
    List<RedSocialBasica> redesSocialesBasica = await _crudRedSocial.getAllRedesSociales(); // Definir redesSocialesBasica aquí
    _todasLasRedesSociales = redesSocialesBasica.map((redSocialBasica) {
      return RedSocial(
        redId: redSocialBasica.redId,
        nombre: redSocialBasica.nombre,
        nombreUsuarioAplicacion: '', // Campo vacío
      );
    }).toList();
    setState(() {});
  }
}

  void _mostrarDialog(String mensaje, Color colorFondo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mensaje'),
          content: Text(mensaje),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true); 
              },
              child: const Text('OK'),
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
        title: const Text('Editar Redes Sociales'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _todasLasRedesSociales.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  for (var redSocial in _todasLasRedesSociales)
                    RedSocialFormField(
                      redSocial: redSocial,
                      usuarioRedId: _redesSocialesUsuarioMap[redSocial.redId] ?? 0,
                      onChanged: (value) {
                        setState(() {
                          int index = _todasLasRedesSociales.indexOf(redSocial);
                          _todasLasRedesSociales[index] = redSocial.copyWith(nombreUsuarioAplicacion: value);
                        });
                      },
                      onDelete: (usuarioRedId) {
                        _eliminarRedSocial(usuarioRedId); // Llama a la función para eliminar la red social
                      },
                      initialValue: redSocial.nombreUsuarioAplicacion.toString(),
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final datosParaEnviar = _prepararDatosParaEnviar();
                      if (datosParaEnviar.isNotEmpty) {
                        try {
                          await _crudRedSocial.asociarRedesSociales(datosParaEnviar);
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