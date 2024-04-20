import 'package:app_jobder/presentation/screens/entrada/tyc_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EntradaScreen extends StatelessWidget {
  const EntradaScreen({Key? key}) : super(key: key);

  static const String name = 'entrada_screen';

  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEE805F), Color(0xFF096BFF)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.work, size: 100, color: Colors.white),
              const Text(
                'Jobder',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Al crear cuenta o iniciar sesión, acepta nuestros Términos.\nConozca cómo procesamos sus datos en nuestra\nPolítica de Privacidad y Política de Cookies:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TerminosScreen()),
                  );
                },
                child: const Text(
                  'Política de Privacidad y Política de Cookies',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navegar a la ruta '/login' cuando se presiona el botón "Iniciar sesión"
                  GoRouter.of(context).go('/login');
                },
                child: const Text('Iniciar sesión'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Crear cuenta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
