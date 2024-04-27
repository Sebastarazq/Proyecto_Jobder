import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:flutter/material.dart';
import 'package:app_jobder/presentation/screens/home/perfil/edit_profile_screen.dart';
import 'package:app_jobder/presentation/screens/shared/widgets/navigation_bar.dart';
import 'package:app_jobder/infraestructure/model/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class ProfileScreen extends StatelessWidget {
  static const String name = 'profile_screen';
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
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
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          final UserModel user = snapshot.data!;
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
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(user.fotoPerfil!),
                      // Manejar el error con un ternario en lugar del errorBuilder
                      backgroundColor: Colors.transparent,
                      child: user.fotoPerfil != ''
                          ? null
                          : Image.asset(
                              'assets/images/user.jpeg',
                              fit: BoxFit.cover,
                            ),
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileScreen(),
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
                          // Borra el token de autenticación de las preferencias compartidas
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove('auth_token');
                          // Navega de regreso a la pantalla de inicio de sesión
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

  Future<UserModel> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('usuario_id') ?? '';

    return UserRepository().getUserById(userId);
  }
}
