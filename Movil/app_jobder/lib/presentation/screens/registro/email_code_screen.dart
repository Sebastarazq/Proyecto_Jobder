import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:app_jobder/presentation/screens/habilidades/habilidades_screen.dart';
import 'package:flutter/material.dart';


class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _verificationCodeController = TextEditingController();
    final UserRepository _userRepository = UserRepository();

    void _showErrorDialog(String errorMessage) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error al verificar código'),
          content: Text(errorMessage),
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

    void _verifyCode() async {
      String verificationCode = _verificationCodeController.text.trim();
      if (verificationCode.isEmpty) {
        _showErrorDialog('Por favor, ingresa el código de verificación.');
        return;
      }

      try {
        // Intenta verificar el código
        final userId = await _userRepository.enviarCodigo(verificationCode);
        // Si tiene éxito, navega a la pantalla de selección de habilidades y pasa el userId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelectHabilidadesScreen(userId: userId),
          ),
        );
      } catch (e) {
        // Si hay un error, muestra el diálogo de error con el mensaje obtenido del error, sin incluir la palabra "Exception"
        _showErrorDialog(e.toString().replaceAll('Exception:', ''));
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        title: const Text('Verificación de Código'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Ingresa el código de verificación enviado al correo',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _verificationCodeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 197, 197, 197)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                hintText: 'Ingresa tu código',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Handle code input
              },
              // You can add validation logic here if needed
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF096BFF),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0, // Agrega un efecto de sombra al botón
              ),
              child: const Text('VERIFICAR'),
            ),
          ],
        ),
      ),
    );
  }
}
