import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login_exitoso.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo del coche en la parte superior
            Center(
              child: Image.asset(
                'assets/images/car_logo.png',  // Asegúrate de que el logo esté en assets
                height: 150,
              ),
            ),
            const SizedBox(height: 50),

            // Campo de texto Usuario
            _buildTextField('Usuario'),
            const SizedBox(height: 20),

            // Campo de texto Contraseña
            _buildTextField('Password', obscureText: true),

            const SizedBox(height: 100), // Espacio entre los campos y la parte inferior
          ],
        ),
      ),
      // Icono de huella digital en la parte inferior izquierda
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón de huella digital
            IconButton(
              icon: const Icon(Icons.fingerprint, color: Colors.white, size: 40),
              onPressed: () {
                // Lógica para huella digital
              },
            ),
            // Botón flotante para continuar (parte inferior derecha)
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // Acción para continuar a la siguiente pantalla
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Función para crear un campo de texto editable
  Widget _buildTextField(String label, {bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Next Screen',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
