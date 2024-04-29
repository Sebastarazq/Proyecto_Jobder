import 'package:app_jobder/config/helpers/crud_habilidades.dart';
import 'package:app_jobder/domain/entities/habilidad.dart';
import 'package:flutter/material.dart';

class EditHabilidadesScreen extends StatefulWidget {
  final int userId;
  const EditHabilidadesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _EditHabilidadesScreenState createState() => _EditHabilidadesScreenState();
}

class _EditHabilidadesScreenState extends State<EditHabilidadesScreen>{
  Set<int> _selectedHabilidadIds = {};
  List<Habilidad>? _habilidades;
  List<int> _selectedHabilidades = [];

  final HabilidadesRepository _habilidadesRepository = HabilidadesRepository();

  @override
  void initState() {
    super.initState();
    _fetchHabilidades();
  }
  Future<void> _fetchHabilidades() async {
    try {
      // Obtener todas las habilidades disponibles
      List<Habilidad> habilidades = await _habilidadesRepository.getAllHabilidades();
      
      // Obtener las habilidades asociadas al usuario
      List<Habilidad> usuarioHabilidades = await _habilidadesRepository.getUsuarioHabilidades(widget.userId);
      
      // Obtener los IDs de las habilidades asociadas al usuario
      List<int> usuarioHabilidadIds = usuarioHabilidades.map((habilidad) => habilidad.habilidadId).toList();
      
      // Marcar las habilidades seleccionadas
      setState(() {
        _habilidades = habilidades;
        _selectedHabilidades = usuarioHabilidadIds;
        _selectedHabilidadIds.addAll(usuarioHabilidadIds);
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error al obtener habilidades'),
            content: const Text('Opps, hubo un error al obtener las habilidades. Por favor, inténtalo de nuevo más tarde.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _toggleHabilidadSelection(int habilidadId) {
    setState(() {
      if (_selectedHabilidadIds.contains(habilidadId)) {
        _selectedHabilidadIds.remove(habilidadId);
        _selectedHabilidades.remove(habilidadId);
      } else {
        _selectedHabilidadIds.add(habilidadId);
        _selectedHabilidades.add(habilidadId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Habilidades'),
      ),
      body: _habilidades == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    padding: const EdgeInsets.all(16),
                    children: _habilidades!.map((habilidad) {
                      bool isSelected = _selectedHabilidadIds.contains(habilidad.habilidadId);
                      return ElevatedButton(
                        onPressed: () {
                          _toggleHabilidadSelection(habilidad.habilidadId);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: isSelected ? Colors.blue : Colors.white,
                          padding: const EdgeInsets.all(16),
                          minimumSize: const Size(100, 100),
                        ),
                        child: Text(
                          habilidad.nombre,
                          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible: false, // Evita que se cierre el diálogo al tocar fuera de él
                        builder: (BuildContext context) {
                          return const Dialog(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircularProgressIndicator(), // Indicador de progreso circular
                                  SizedBox(width: 20),
                                  Text('Guardando cambios...'), // Texto informativo
                                ],
                              ),
                            ),
                          );
                        },
                      );
                      try {
                        // Llamar a la función para actualizar las habilidades del usuario
                        await _habilidadesRepository.actualizarHabilidadesUsuario(widget.userId, _selectedHabilidades);
                        // Cerrar el diálogo de progreso y mostrar un mensaje de éxito si las habilidades se actualizaron correctamente
                        Navigator.of(context).pop(); // Cerrar el diálogo de progreso
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Éxito'),
                              content: const Text('Las habilidades se actualizaron correctamente.'),
                              actions:[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Cerrar el diálogo
                                    Navigator.of(context).pop(true); // Cerrar la pantalla de edición
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } catch (error) {
                        // Cerrar el diálogo de progreso y mostrar un mensaje de error si hay algún problema al actualizar las habilidades
                        Navigator.of(context).pop(); // Cerrar el diálogo de progreso
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error'),
                              content: Text('Hubo un error al actualizar las habilidades: $error'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      backgroundColor: const Color(0xFF096BFF),
                    ),
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
