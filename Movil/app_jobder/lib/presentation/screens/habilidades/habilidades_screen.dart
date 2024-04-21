import 'package:flutter/material.dart';
import 'package:app_jobder/config/helpers/crud_habilidades.dart';
import 'package:app_jobder/domain/entities/habilidad.dart';
import 'package:go_router/go_router.dart';

class SelectHabilidadesScreen extends StatefulWidget {
  final int userId;
  const SelectHabilidadesScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _SelectHabilidadesScreenState createState() => _SelectHabilidadesScreenState();
}

class _SelectHabilidadesScreenState extends State<SelectHabilidadesScreen> {
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
      List<Habilidad> habilidades = await _habilidadesRepository.getAllHabilidades();
      setState(() {
        _habilidades = habilidades;
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
        automaticallyImplyLeading: false,
        title: const Text('Seleccionar Habilidades'),
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
                      if (_selectedHabilidades.length < 3) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Seleccionar Habilidades'),
                              content: const Text('Debes seleccionar al menos 3 habilidades.'),
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
                      } else {
                        try {
                          await _habilidadesRepository.asociarHabilidadesUsuario(widget.userId, _selectedHabilidades);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Éxito'),
                                content: const Text('Habilidades asociadas correctamente al usuario. Por favor, inicia sesión para continuar.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).go('/');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (error) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error al asociar habilidades'),
                                content: const Text('Opps, hubo un error al asociar las habilidades al usuario. Por favor, inténtalo de nuevo más tarde.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      GoRouter.of(context).go('/');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Continuar',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      backgroundColor: const Color(0xFF096BFF),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
