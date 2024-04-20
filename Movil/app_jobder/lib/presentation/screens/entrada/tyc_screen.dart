import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TerminosScreen extends StatelessWidget {
  const TerminosScreen({Key? key}) : super(key: key);

  static const String name = 'terminos_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Términos y Condiciones de Jobder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '1. Aceptación de los Términos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Al usar la aplicación Jobder, usted acepta cumplir con estos términos y condiciones. Si no está de acuerdo con alguno de los términos, por favor, no utilice la aplicación.',
            ),
            const SizedBox(height: 20),
            const Text(
              '2. Condiciones del Servicio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Jobder proporciona una plataforma para la búsqueda y oferta de empleo. Nos esforzamos por mantener la precisión y la integridad de la información, pero no garantizamos la exactitud de la información proporcionada por terceros.',
            ),
            const SizedBox(height: 20),
            const Text(
              '3. Política de Privacidad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Respetamos su privacidad y estamos comprometidos a protegerla. Nuestra Política de Privacidad describe cómo recopilamos, usamos y protegemos la información que usted proporciona.',
            ),
            const SizedBox(height: 20),
            const Text(
              '4. Ley Aplicable',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Estos términos y condiciones se rigen por las leyes de la República de Colombia. Cualquier disputa relacionada con estos términos y condiciones estará sujeta a la jurisdicción exclusiva de los tribunales de Colombia.',
            ),
            const SizedBox(height: 20),
            const Text(
              '5. Política de Protección de Datos de Colombia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nos comprometemos a cumplir con la legislación colombiana de protección de datos personales, incluida la Ley Estatutaria 1581 de 2012 y sus decretos reglamentarios, garantizando la seguridad y confidencialidad de los datos personales de los usuarios.',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la ruta '/' cuando se presiona el botón "Aceptar"
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
