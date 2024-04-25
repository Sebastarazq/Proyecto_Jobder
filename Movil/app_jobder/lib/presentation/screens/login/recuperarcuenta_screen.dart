import 'package:app_jobder/presentation/screens/login/verificacionpassword_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_jobder/config/helpers/crud_user.dart';

class RecuperarCuentaScreen extends StatelessWidget {
  const RecuperarCuentaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final UserRepository _userRepository = UserRepository();

    void _showMessageDialog(String message, {String? title}) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    void _sendResetCode() async {
      String email = _emailController.text.trim();
      if (email.isEmpty) {
        _showMessageDialog('Por favor, ingresa tu correo electrónico.');
        return;
      }

      try {
        await _userRepository.sendPasswordResetCode(email);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Correo enviado'),
            content: const Text('Se ha enviado un correo con el código de verificación.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VerificationCodePasswordScreen(),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (error) {
        // Verifica si el error es de tipo Exception antes de mostrar el mensaje
        String errorMessage = error is Exception ? error.toString().replaceAll('Exception:', '') : 'Error al enviar el código.';
        _showMessageDialog(errorMessage, title: 'Ops, algo salió mal');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ingresa tu correo para recuperar tu contraseña de Jobder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Correo Electrónico',
                labelText: 'Correo Electrónico',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendResetCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xFF096BFF),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Recuperar Contraseña'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
