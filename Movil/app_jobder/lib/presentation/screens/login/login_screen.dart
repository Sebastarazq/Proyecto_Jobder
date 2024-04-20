import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _useEmail = true; // Inicializado como true para que el inicio de sesión con email esté activo por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close), 
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Iniciar sesión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value; 
                });
              },
              decoration: InputDecoration(
                hintText: _useEmail ? 'Email' : 'Celular',
                labelText: _useEmail ? 'Email' : 'Celular',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  _password = value; 
                });
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Contraseña',
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _useEmail = !_useEmail; // Alternar entre iniciar sesión con email y celular
                });
              },
              child: Text(_useEmail ? 'Iniciar sesión con celular' : 'Iniciar sesión con email'),
            ),
            const Spacer(), 
            Container(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                  // Aquí llamarías a tu función de inicio de sesión con email y contraseña
                  // Si _useEmail es verdadero, entonces usarías _email y _password para iniciar sesión
                  // Si _useEmail es falso, entonces usarías _email (o _password si necesitas contraseña) para iniciar sesión con celular
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF096BFF), 
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
