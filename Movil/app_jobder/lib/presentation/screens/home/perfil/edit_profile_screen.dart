import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:app_jobder/infraestructure/model/user_actualizar.dart';
import 'package:app_jobder/infraestructure/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel userData;
  const EditProfileScreen({required this.userData, Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _getLocation(); // Llama al método para obtener la ubicación al cargar la página
    _nameController.text = widget.userData.nombre;
    _phoneController.text = widget.userData.celular.toString();
    _emailController.text = widget.userData.email;
    _ageController.text = widget.userData.edad.toString();
    _descriptionController.text = widget.userData.descripcion ?? "";
    _selectedCategory = widget.userData.categoria;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Perfil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white, // Púrpura oscuro
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(CupertinoIcons.person, color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(CupertinoIcons.phone, color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(CupertinoIcons.mail, color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Edad',
                  prefixIcon: Icon(CupertinoIcons.calendar, color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Categoría',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: ['Desarrollador', 'Empresario']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  prefixIcon: Icon(CupertinoIcons.briefcase, color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Text(
                'Sobre ti',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Escribe una breve descripción sobre ti',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF096BFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Guardar Cambios',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    // Mostrar un diálogo de progreso circular al iniciar el proceso de guardado
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

    // Obtener el ID del usuario de SharedPreferences
    String userId = await _getUserId();

    // Obtener la ubicación actual
    Map<String, double> location = await _getLocation();

    // Crear un objeto PartialUserUpdate con los datos actualizados
    PartialUserUpdate updates = PartialUserUpdate(
      nombre: _nameController.text,
      celular: int.tryParse(_phoneController.text),
      edad: int.tryParse(_ageController.text),
      categoria: _selectedCategory,
      descripcion: _descriptionController.text,
      latitud: location['latitud'],
      longitud: location['longitud'],
    );

    try {
      // Llamar a la función de actualización del perfil en UserRepository
      await UserRepository().updateUserPartialInfo(userId, updates);

      // Cerrar el diálogo de progreso y mostrar un diálogo de éxito
      Navigator.of(context).pop(); // Cerrar el diálogo de progreso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('Perfil actualizado correctamente'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                  Navigator.pop(context, true); // Cerrar la pantalla de edición
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      // Cerrar el diálogo de progreso y mostrar un diálogo de error
      Navigator.of(context).pop(); // Cerrar el diálogo de progreso
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error al actualizar el perfil: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<Map<String, double>> _getLocation() async {
    Map<String, double> location = {};
    try {
      // Verificar si la ubicación del dispositivo está habilitada
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Mostrar un diálogo para solicitar que el usuario habilite la ubicación
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ubicación deshabilitada'),
              content: const Text('Para continuar, habilite la ubicación del dispositivo en la configuración de la aplicación.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    // Abrir la configuración de la aplicación para que el usuario habilite la ubicación
                    Geolocator.openAppSettings();
                  },
                  child: const Text('Configuración'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            );
          },
        );
        throw 'La ubicación del dispositivo está deshabilitada';
      }

      // Obtener la posición actual del dispositivo
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Obtener la latitud y longitud de la posición
      location['latitud'] = position.latitude;
      location['longitud'] = position.longitude;
    } catch (e) {
      print('Error al obtener la ubicación: $e');
      // Manejar el error, mostrar un mensaje al usuario, etc.
    }
    return location;
  }

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_id') ?? '';
  }
}