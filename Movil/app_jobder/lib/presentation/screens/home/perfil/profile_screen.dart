import 'package:app_jobder/presentation/screens/home/perfil/edit_profile_screen.dart';
import 'package:app_jobder/presentation/screens/shared/widgets/navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  static const String name = 'profile_screen';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: const TextSpan(
            text: 'Perfil Jobder',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
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
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/user.jpeg'),
              ),
              const SizedBox(height: 20),
              itemProfile('Nombre', 'Ahad Hashmi', CupertinoIcons.person),
              const SizedBox(height: 10),
              itemProfile('Teléfono', '03107085816', CupertinoIcons.phone),
              const SizedBox(height: 10),
              itemProfile('Dirección', 'abc address, xyz city', CupertinoIcons.location),
              const SizedBox(height: 10),
              itemProfile('Email', 'ahadhashmideveloper@gmail.com', CupertinoIcons.mail),
              const SizedBox(height: 10),
              itemProfile('Edad', '25', CupertinoIcons.calendar),
              const SizedBox(height: 10),
              itemProfile('Descripción', 'Software Developer', CupertinoIcons.book),
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
                    side: const BorderSide(color: Colors.red), // Bordes rojos
                  ),
                  child: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.red), // Texto rojo
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
}
