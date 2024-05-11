import 'package:flutter/material.dart';
import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:go_router/go_router.dart';

class VerificationCodePasswordScreen extends StatelessWidget {
  const VerificationCodePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _verificationCodeController = TextEditingController();

    void _showErrorDialog(String errorMessage) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error al verificar código'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    void _verifyCode() async {
      String verificationCode = _verificationCodeController.text.trim();
      if (verificationCode.isEmpty || verificationCode.length != 5 || !RegExp(r'^[0-9]*$').hasMatch(verificationCode)) {
        _showErrorDialog('Por favor, ingresa un código de verificación de 5 dígitos.');
        return;
      }

      // Navega a la pantalla de cambio de contraseña y pasa el código
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordScreen(verificationCode: verificationCode),
        ),
      );
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
                // Manejar la entrada del código
              },
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

class NewPasswordScreen extends StatelessWidget {
  final String verificationCode;

  const NewPasswordScreen({Key? key, required this.verificationCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();
    final UserRepository _userRepository = UserRepository();
    

    void _showErrorDialog(String errorMessage) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Ops! Algo salió mal'),
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

    void _showSuccessDialog(String message) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Contraseña cambiada exitosamente'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                GoRouter.of(context).go('/'); // Redirige al usuario a '/'
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    void _setNewPassword() async {
      String password = _passwordController.text.trim();
      String confirmPassword = _confirmPasswordController.text.trim();

      if (password.isEmpty || confirmPassword.isEmpty) {
        _showErrorDialog('Por favor, ingresa una contraseña y confírmala.');
        return;
      }

      if (password != confirmPassword) {
        _showErrorDialog('Las contraseñas no coinciden.');
        return;
      }

      try {
        // Llamar a la función resetPassword con el código de verificación y la nueva contraseña
        await _userRepository.resetPassword(verificationCode, password);
        _showSuccessDialog('Contraseña cambiada exitosamente');
      } catch (e) {
        _showErrorDialog(e.toString().replaceAll('Exception:', ''));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Establece tu nueva contraseña',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Nueva Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 197, 197, 197)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                hintText: 'Ingresa tu nueva contraseña',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility_off),
                  onPressed: () {
                    // Toggle password visibility
                  },
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                // Handle password input
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 197, 197, 197)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                hintText: 'Confirma tu nueva contraseña',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                suffixIcon: IconButton(
                  icon: Icon(Icons.visibility_off),
                  onPressed: () {
                    // Toggle password visibility
                  },
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                // Handle confirmed password input
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _setNewPassword,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF096BFF),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3.0, // Add shadow effect to the button
              ),
              child: const Text('ESTABLECER CONTRASEÑA'),
            ),
          ],
        ),
      ),
    );
  }
}