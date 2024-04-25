import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Ahad Hashmi');
  final TextEditingController _phoneController = TextEditingController(text: '03107085816');
  final TextEditingController _emailController = TextEditingController(text: 'ahadhashmideveloper@gmail.com');
  final TextEditingController _ageController = TextEditingController(text: '25');
  final TextEditingController _descriptionController = TextEditingController(text: 'Software Developer');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Color.fromARGB(255, 30, 137, 224),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(CupertinoIcons.person),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(CupertinoIcons.phone),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(CupertinoIcons.mail),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Edad',
                prefixIcon: Icon(CupertinoIcons.calendar),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                prefixIcon: Icon(CupertinoIcons.book),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Vuelve a la pantalla anterior después de guardar cambios
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 78, 160, 226),
                padding: const EdgeInsets.all(15),
              ),
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
