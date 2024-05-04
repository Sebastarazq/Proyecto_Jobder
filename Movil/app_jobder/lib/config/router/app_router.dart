import 'package:app_jobder/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

Future<String?> redirectBasedOnAuth(BuildContext context, GoRouterState state) async {
  //  acceder a los datos almacenados localmente
  final prefs = await SharedPreferences.getInstance();

  // Verificar si hay un token de autenticación almacenado en SharedPreferences
  final hasAuthToken = prefs.getString('auth_token') != null;

  // Si el usuario está autenticado y la ubicación actual es la pantalla de inicio de sesión,
  // redirigir a la pantalla de inicio
  if (hasAuthToken && state.uri.path == '/') {
    return '/home';
  }

  // Si el usuario no está autenticado y la ubicación actual no es la pantalla de inicio de sesión,
  // redirigir a la pantalla de inicio de sesión
  if (!hasAuthToken && state.uri.path != '/') {
    // Permitir que el usuario acceda a /login y /registro
    if (state.uri.path != '/login' && state.uri.path != '/registro') {
      return '/';
    }
  }

  // Si no se cumple ninguna de las condiciones anteriores, no se realiza ninguna redirección
  return null;
}

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: redirectBasedOnAuth,
  routes: [
    GoRoute(
      path: '/',
      name: EntradaScreen.name,
      builder: (context, state) => const EntradaScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/home',
      name: UsersScreen.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const UsersScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(-1.0, 0.0), // Cambio aquí para deslizar desde la izquierda
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/registro',
      name: RegistroScreen1.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const RegistroScreen1(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/matchs',
      name: MatchScreen.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const MatchScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/ubicacion',
      name: UbicacionScreen.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const UbicacionScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/profile',
      name: ProfileScreen.name,
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const ProfileScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
  ],
);