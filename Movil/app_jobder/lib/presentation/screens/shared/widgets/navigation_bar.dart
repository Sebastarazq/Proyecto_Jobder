import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // Navigate to matches screen
              },
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Colors.blue : Colors.black, // Color azul si está en la pantalla de coincidencias, de lo contrario, negro
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigate to profile screen
              },
              icon: Icon(
                Icons.person,
                color: currentIndex == 1 ? Colors.blue : Colors.black, // Color azul si está en la pantalla de perfil, de lo contrario, negro
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigate to map screen
              },
              icon: Icon(
                Icons.map,
                color: currentIndex == 2 ? Colors.blue : Colors.black, // Color azul si está en la pantalla del mapa, de lo contrario, negro
              ),
            ),
          ],
        ),
      ),
    );
  }
}
