import 'package:flutter/material.dart';
import 'inicio2.dart'; 

class Inicio extends StatefulWidget {
  const Inicio({Key? key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  String _nombre = ''; // Almacenar nombre

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close), 
          onPressed: () {
            Navigator.of(context).pop(); // Icono x
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Mi nombre es',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  _nombre = value; 
                });
              },
              decoration: const InputDecoration(
                hintText: 'Escribe tu nombre aquí',
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Así aparecerá en Jobder y no podrás cambiarlo',
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
                    MaterialPageRoute(builder: (context) => const Inicio2()),
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
