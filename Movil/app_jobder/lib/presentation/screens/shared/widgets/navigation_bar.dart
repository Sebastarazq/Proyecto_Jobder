import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            _buildNavItem(Icons.home, 'Inicio', 0, currentIndex, context),
            const SizedBox(width: 20),
            _buildNavItem(Icons.work, 'Jobmatch', 1, currentIndex, context),
            const SizedBox(width: 20), 
            _buildNavItem(Icons.person, 'Perfil', 2, currentIndex, context),
            const SizedBox(width: 20),
            _buildNavItem(Icons.map, 'Ubicación', 3, currentIndex, context),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, int currentIndex, BuildContext context) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: isActive ? null : () => _navigateToScreen(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF096BFF) : Colors.black,
            size: 28, // Tamaño del ícono
          ),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF096BFF) : Colors.black,
              fontSize: 14, // Tamaño del texto
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // Navigate to Jobmatch screen
        break;
      case 2:
       context.go('/profile');
        break;
      case 3:
        context.go('/ubicacion');
        break;
      default:
        break;
    }
  }
}
