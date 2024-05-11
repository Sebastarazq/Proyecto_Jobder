import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para utilizar el TextInputFormatter
import 'package:app_jobder/presentation/screens/registro/registro_screen2.dart';
import 'package:go_router/go_router.dart';

class RegistroScreen1 extends StatefulWidget {
  const RegistroScreen1({Key? key}) : super(key: key);

  static const String name = 'registro_screen';

  @override
  State<RegistroScreen1> createState() => _RegistroScreen1State();
}

class _RegistroScreen1State extends State<RegistroScreen1> {
  String _nombre = ''; // Almacenar nombre
  String _email = ''; // Almacenar email
  String _celular = ''; // Almacenar celular
  String _genero = 'Masculino'; // Almacenar género seleccionado
  String _password = ''; // Almacenar contraseña
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Clave para validar el formulario
  final ScrollController _scrollController = ScrollController(); // Controlador del scroll
  bool _showPassword = false; // Nuevo estado para controlar la visibilidad de la contraseña

  //método para alternar la visibilidad de la contraseña
  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close), 
          onPressed: () {
            GoRouter.of(context).go('/');
          },
        ),
      ),
      resizeToAvoidBottomInset: false, // Evitar que la pantalla se redimensione para evitar el teclado
      body: SingleChildScrollView(
        controller: _scrollController, // Asignar el controlador del scroll
        reverse: true, // Invierte el orden de los elementos
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Asignar la clave al formulario
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextField(
                  label: 'Nombre',
                  hintText: 'Escribe tu nombre aquí',
                  onChanged: (value) {
                    setState(() {
                      _nombre = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Email',
                  hintText: 'Escribe tu email aquí',
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu email';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Celular',
                  hintText: 'Escribe tu celular aquí',
                  onChanged: (value) {
                    setState(() {
                      _celular = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu celular';
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Asegura que solo se acepten números
                ),
                 _buildTextField(
                  label: 'Contraseña',
                  hintText: 'Ingresa tu contraseña',
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa tu contraseña';
                    }
                    return null;
                  },
                  obscureText: !_showPassword, // Cambiar entre obscureText y !obscureText
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                _buildDropdownButtonFormField(
                  label: 'Género',
                  value: _genero,
                  items: ['Masculino', 'Femenino', 'Prefiero no decir'],
                  onChanged: (value) {
                    setState(() {
                      _genero = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0), // Margen inferior para evitar el desbordamiento del botón
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Alinea el botón en el centro horizontal
          children: [
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // El formulario es válido, navega a RegistroScreen2 y pasa los datos como argumentos
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistroScreen2(
                        nombre: _nombre,
                        email: _email,
                        celular: _celular,
                        genero: _genero,
                        password: _password,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350.0, 0), // Ancho mínimo del botón
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF096BFF),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14.0),
                child: Text(
                  'CONTINUE',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters, // Agrega un parámetro para los formateadores de entrada
    Widget? suffixIcon, // Nuevo parámetro para el icono del sufijo
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          onChanged: onChanged,
          validator: validator,
          obscureText: obscureText,
          inputFormatters: inputFormatters, // Asigna los formateadores de entrada
          decoration: InputDecoration(
            hintText: hintText,
            labelText: label,
            suffixIcon: suffixIcon, // Agrega el icono del sufijo
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdownButtonFormField({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          items: items
              .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              })
              .toList(),
          decoration: InputDecoration(
            hintText: 'Selecciona tu $label',
            labelText: label,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
