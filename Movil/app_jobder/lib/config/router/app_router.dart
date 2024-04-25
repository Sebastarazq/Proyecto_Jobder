import 'package:app_jobder/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
    GoRoute(
      path: '/',
      name: EntradaScreen.name,
      builder: (context, state) => const EntradaScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: UsersScreen.name,
      builder: (context, state) => const UsersScreen(),
    ),
    GoRoute(
      path: '/registro',
      name: RegistroScreen1.name,
      builder: (context, state) => const RegistroScreen1(),
    ),
    GoRoute(
      path: '/ubicacion',
      name: UbicacionScreen.name,
      builder: (context, state) => const UbicacionScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: ProfileScreen.name,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);