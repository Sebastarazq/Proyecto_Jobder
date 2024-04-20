import 'package:flutter/material.dart';

class Inicio4 extends StatefulWidget {
  const Inicio4({Key? key});

  @override
  State<Inicio4> createState() => _Inicio4State();
}

class _Inicio4State extends State<Inicio4> {
  List<String> _selectedSkills = []; // Lista para almacenar las habilidades

  // Lista de habilidades
  final List<String> _allSkills = [
    'Frontend',
    'Backend',
    'CSS',
    'HTML',
    'JavaScript',
    'React.js',
    'Angular',
    'Next.js',
    'Express',
    'SQL',
    'Base de datos',
    'Linux',
    'Redes',
    'Node.js',
    'Python',
    'App movil',
    'Vue.js',
    'Kotlin',
    'Java',
    'Flutter',
    'Git',
    'Scrum',
    'GitHub',
    'Bootstrap',
    'MongoDB',
    'Firebase',
    '.NET',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), //Icono flchecha <-
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
              'Habilidades',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selecciona tus habilidades para que todos conozcan tus habilidades de desarrollo',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // Número de columnas 
                crossAxisSpacing: 10.0, // Espacio entre columnas
                mainAxisSpacing: 10.0, // Espacio entre filas
                children: _buildSkillButtons(), 
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Color(0xFF096BFF), 
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

  // Método para construir los botones de habilidades
  List<Widget> _buildSkillButtons() {
    return _allSkills.map((skill) {
      bool isSelected = _selectedSkills.contains(skill);

      return ElevatedButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              _selectedSkills.remove(skill); // Elimina la habilidad si ya está seleccionada
            } else {
              _selectedSkills.add(skill); // Agrega la habilidad si no está seleccionada
            }
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Color(0xFF096BFF), backgroundColor: isSelected ? Color(0xFF096BFF) : Colors.white, // Color del texto del botón
          side: BorderSide(
            color: Color(0xFFC6C5C7), // Color del borde del botón
            width: 1.0, // Ancho del borde del botón
          ),
        ),
        child: Text(
          skill,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      );
    }).toList();
  }
}
