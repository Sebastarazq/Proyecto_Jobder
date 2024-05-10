import 'package:app_jobder/config/helpers/crud_user.dart';
import 'package:app_jobder/config/providers/biometric_provider.dart';
import 'package:app_jobder/infraestructure/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

class BiometricSetupScreen extends StatefulWidget {
  @override
  _BiometricSetupScreenState createState() => _BiometricSetupScreenState();
  static const String name = 'biometric_screen';
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final UserRepository _authService = UserRepository();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _showCredentialFields = false;
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricEnabled();
  }

  Future<void> _checkBiometricEnabled() async {
    bool biometricEnabled = Provider.of<BiometricAuthModel>(context, listen: false).biometricEnabled;
    setState(() {
      _biometricEnabled = biometricEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habilitar inicio de sesión biométrico'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (!_biometricEnabled) // Mostrar solo si la autenticación biométrica está deshabilitada
              ElevatedButton(
                onPressed: () => _enableBiometricAuthentication(context),
                child: const Text('Habilitar inicio de sesión biométrico'),
              ),
            if (_showCredentialFields)
              Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Por favor, ingresa tus credenciales para completar la configuración:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      filled: true,
                      fillColor: Color.fromARGB(255, 242, 238, 238),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      filled: true,
                      fillColor: Color.fromARGB(255, 242, 238, 238),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _submitCredentials(context),
                    child: const Text('Enviar credenciales', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor, // Use the theme primary color for the button
                    ),
                  ),
                ],
              ),
            if (_biometricEnabled) // Mostrar solo si la autenticación biométrica está habilitada
              ElevatedButton(
                onPressed: () => _disableBiometricAuthentication(context),
                child: const Text('Deshabilitar inicio de sesión biométrico', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Método para habilitar la autenticación biométrica
  Future<void> _enableBiometricAuthentication(BuildContext context) async {
    try {
      bool isBiometricAvailable = await _localAuthentication.canCheckBiometrics;
      if (isBiometricAvailable) {
        bool isBiometricAuthenticated = await _localAuthentication.authenticate(
          localizedReason: 'Por favor, autentícate para habilitar la autenticación biométrica',
        );

        if (isBiometricAuthenticated) {
          setState(() {
            _showCredentialFields = true;
          });
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('La autenticación biométrica no está disponible en este dispositivo.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _disableBiometricAuthentication(BuildContext context) async {
    try {
      bool isBiometricAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Por favor, autentícate para deshabilitar la autenticación biométrica',
      );

      if (isBiometricAuthenticated) {
        Provider.of<BiometricAuthModel>(context, listen: false).biometricEnabled = false;
        setState(() {
          _biometricEnabled = false;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Método para enviar las credenciales
  void _submitCredentials(BuildContext context) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    UsuarioLogin user = UsuarioLogin(email:username, password:password);

    try {
      await _authService.loginVerificarHuella(user);
      setState(() {
        _showCredentialFields = false;
        _biometricEnabled = Provider.of<BiometricAuthModel>(context, listen: false).biometricEnabled = true;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Éxito'),
            content: const Text('La autenticación biométrica ha sido habilitada.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Hubo un error al verificar las credenciales.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}