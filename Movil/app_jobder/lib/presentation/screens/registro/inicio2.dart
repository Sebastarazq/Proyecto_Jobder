import 'package:flutter/material.dart';
import 'inicio3.dart'; 

class Inicio2 extends StatefulWidget {
  const Inicio2({Key? key});

  @override
  State<Inicio2> createState() => _Inicio2State();
}

class _Inicio2State extends State<Inicio2> {
  String _numero = ''; // Almacenar datos

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Icono <-
          onPressed: () {
            Navigator.of(context).pop(); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Mi número es',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  _numero = value; 
                });
              },
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Escribe tu número aquí',
                labelText: 'Número',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Este número será importante porque estará vinculado con WhatsApp para el chat.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const Spacer(), 
            Container(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                 
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Inicio3()),
                  );
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
