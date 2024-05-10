import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_jobder/config/router/app_router.dart';
import 'package:app_jobder/config/providers/biometric_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BiometricAuthModel(), // Aquí se crea una instancia de BiometricAuthModel
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Jobder',
        routerConfig: appRouter,
      ),
    );
  }
}
