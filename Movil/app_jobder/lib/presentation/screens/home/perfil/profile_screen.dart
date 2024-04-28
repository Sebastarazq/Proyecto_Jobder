import 'package:flutter/material.dart';
import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:app_jobder/config/helpers/location_service.dart';
import 'package:app_jobder/presentation/screens/home/perfil/edit_profile_screen.dart';
import 'package:app_jobder/presentation/screens/shared/widgets/navigation_bar.dart';
import 'package:app_jobder/infraestructure/model/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  static const String name = 'profile_screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = getUserData();
  }

  Future<UserModel> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('usuario_id') ?? '';

    return UserRepository().getUserById(userId);
  }

  void updateProfileImage() {
    setState(() {
      userFuture = getUserData(); // Recarga los datos del usuario para reflejar la nueva foto
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Perfil Jobder',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xFF096BFF),
            ),
            body: Center(
              child: Text(
                'Ocurrió un error al cargar los datos del usuario: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          final UserModel user = snapshot.data!;
          final latitudUser = user.latitud?.toDouble() ?? 0;
          final longitudUser = user.longitud?.toDouble() ?? 0;

          return Scaffold(
            appBar: AppBar(
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(user.fotoPerfil ?? ''),
                          backgroundColor: Colors.transparent,
                          child: user.fotoPerfil != ''
                              ? null
                              : Image.asset(
                                  'assets/images/user.jpeg',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () => _showImagePickerBottomSheet(context, user.fotoPerfil!), // Añade la URL de la foto de perfil
                              icon: const Icon(Icons.camera_alt, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    itemProfile('Nombre', user.nombre, Icons.person),
                    const SizedBox(height: 10),
                    itemProfile('Teléfono', user.celular.toString(), Icons.phone),
                    const SizedBox(height: 10),
                    itemProfile('Email', user.email, Icons.mail),
                    const SizedBox(height: 10),
                    itemProfile('Categoría', user.categoria, Icons.group),
                    const SizedBox(height: 10),
                    itemProfile('Edad', user.edad.toString(), Icons.calendar_month),
                    const SizedBox(height: 10),
                    itemProfile('Descripción', user.descripcion ?? 'Sin descripción', Icons.book),
                    const SizedBox(height: 20),
                    FutureBuilder<String>(
                      future: LocationService.getLocationName(latitudUser, longitudUser),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final locationName = snapshot.data ?? 'Ubicación desconocida';
                          return itemProfile('Ubicación', locationName, Icons.location_on);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(userData: user),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          backgroundColor: const Color(0xFF096BFF),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Editar perfil'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove('auth_token');
                          context.go('/');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text(
                          'Cerrar sesión',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
          );
        }
      },
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: const Color.fromARGB(255, 133, 180, 219).withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }

  void _showImagePickerBottomSheet(BuildContext context, String photoUrl) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Ver foto de perfil'),
              onTap: () {
                Navigator.pop(context); // Cerrar el bottom sheet
                _viewProfilePicture(context, photoUrl); // Mostrar la foto de perfil actual
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir foto de perfil'),
              onTap: () {
                Navigator.pop(context); // Cierra el bottom sheet
                _pickImageFromGallery(); // Actualiza después de elegir la imagen
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar foto'),
              onTap: () {
                Navigator.pop(context); // Cierra el bottom sheet
                _pickImageFromCamera(); // Actualiza después de tomar una foto
              },
            ),
          ],
        );
      },
    );
  }

  void _viewProfilePicture(BuildContext context, String photoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black.withOpacity(0.8), // Fondo oscuro con opacidad
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            width: 400.0,
            height: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              image: DecorationImage(
                image: NetworkImage(photoUrl),
                fit: BoxFit.contain, // Redimensiona la imagen para que se ajuste al contenedor sin distorsionarla
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop(); // Cerrar el diálogo al presionar el botón
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _pickImageFromGallery() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);

  if (pickedImage != null) {
    _showConfirmationDialog(pickedImage.path);
  }
}

void _pickImageFromCamera() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.camera);

  if (pickedImage != null) {
    _showConfirmationDialog(pickedImage.path);
  }
}

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usuario_id') ?? '';
  }

  void _showConfirmationDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar subida de imagen de perfil'),
          content: Text('¿Estás seguro de que deseas subir esta imagen como tu nueva foto de perfil?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo de confirmación
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Cierra el diálogo de confirmación
                final userId = await _getUserId();
                try {
                  await UserRepository().uploadProfileImage(userId, File(imagePath));
                  setState(() {
                    userFuture = getUserData(); // Actualiza la vista
                  });
                } catch (error) {
                  print('Error al subir la imagen de perfil: $error');
                }
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}