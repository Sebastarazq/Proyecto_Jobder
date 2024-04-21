import 'package:flutter/material.dart';

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        title: const Text('Verificacion de Codigo'),
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
              decoration: InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                hintText: 'Ingresa tu código',
                filled: true,
                fillColor: Colors.grey[200],
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
              onPressed: () {
                // Validate code and proceed
              },
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
