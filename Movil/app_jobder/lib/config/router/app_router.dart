import 'package:app_jobder/presentation/screens/entrada/entrada.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/',
      name: EntradaScreen.name,
      builder: (context, state) => const EntradaScreen(),
    ),
  ],
);