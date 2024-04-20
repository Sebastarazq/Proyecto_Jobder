import 'package:flutter/material.dart';
import 'inicio4.dart';

class Inicio3 extends StatefulWidget {
  const Inicio3({Key? key});

  @override
  State<Inicio3> createState() => _Inicio3State();
}

class _Inicio3State extends State<Inicio3> {
  String _selectedOption = ''; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
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
            Text(
              'Yo soy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton('Emprendedor'),
                ),
                SizedBox(width: 10), 
                Expanded(
                  child: _buildOptionButton('Desarrollador'),
                ),
              ],
            ),
            Spacer(), 
            Container(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Inicio4()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF096BFF), 
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0), 
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

  Widget _buildOptionButton(String option) {
    bool isSelected = _selectedOption == option;

    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedOption = option; // Actualiza la opción seleccionada
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xFF096BFF) : Colors.white, // Color de fondo del botón
        side: BorderSide(
          color: isSelected ? Color(0xFF096BFF) : Color.fromARGB(255, 226, 226, 226), // Color del borde del botón
          width: 1.0, // Ancho del borde del botón
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0), // Padding vertical para aumentar la altura del botón
        child: Text(
          option,
          style: TextStyle(
            fontSize: 18,
            color: isSelected ? Colors.white : Color.fromARGB(255, 0, 0, 0), // Color del texto del botón
          ),
        ),
      ),
    );
  }
}
