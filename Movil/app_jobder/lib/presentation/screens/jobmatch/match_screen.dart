import 'package:flutter/material.dart';
import 'package:app_jobder/presentation/screens/shared/widgets/navigation_bar.dart';
import 'pending_matches_screen.dart';
import 'all_matches_screen.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);
  static const String name = 'user_matchscreen';

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.work), // Icono de trabajo
            SizedBox(width: 8), // Espacio entre el icono y el texto
            Text('Jobmatchs'), // Texto del título
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Matches Pendientes'),
            Tab(text: 'Todos los Matches'),
          ],
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black), // Estilo del texto seleccionado
          indicatorColor: const Color(0xFF096BFF), // Color del subrayado
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingMatchesScreen(), // Contenido de la pestaña Matches Pendientes
          AllMatchesScreen(), // Contenido de la pestaña Todos los Matches
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }
}
