import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:app_jobder/infraestructure/model/user_model.dart';
import 'package:app_jobder/presentation/screens/login/recuperarcuenta_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  static const String name = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _emailOrCellphone = ''; // Variable para almacenar el email o el número de celular
  String _password = '';
  bool _isUsingEmail = true; // Variable para indicar si se está utilizando el email

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
                  _emailOrCellphone = value; // Actualizar el valor del email o el número de celular
                });
              },
              keyboardType: _isUsingEmail ? TextInputType.emailAddress : TextInputType.phone, // Cambiar el tipo de teclado según el tipo de entrada
              decoration: InputDecoration(
                hintText: _isUsingEmail ? 'Email' : 'Celular', // Mostrar el texto correcto en el campo de entrada
                labelText: _isUsingEmail ? 'Email' : 'Celular',
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
                  _isUsingEmail = !_isUsingEmail; // Cambiar entre email y celular
                });
              },
              child: Text(_isUsingEmail ? 'Iniciar sesión con celular' : 'Iniciar sesión con email'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RecuperarCuentaScreen()));
              },
              child: const Text(
                '¿Has olvidado tu contraseña?',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final userRepository = UserRepository();
                    // Crear instancia de UsuarioLogin con los datos ingresados
                    final user = UsuarioLogin(
                      email: _isUsingEmail ? _emailOrCellphone : null, // Usar email solo si se está utilizando el email
                      celular: _isUsingEmail ? null : int.tryParse(_emailOrCellphone), // Usar celular solo si se está utilizando el celular
                      password: _password,
                    );
                    await userRepository.loginUser(user);
                    GoRouter.of(context).go('/home');
                  } catch (error) {
                    String errorMessage = 'Error al iniciar sesión';
                    if (error is Exception) {
                      errorMessage = error.toString();
                    }
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Ops! Algo salió mal'),
                        content: Text(errorMessage.replaceAll('Exception:', '')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF096BFF),
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
