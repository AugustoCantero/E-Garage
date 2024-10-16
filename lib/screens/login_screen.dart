import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart'; // Cambia esta por la pantalla a la que desees ir
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  // Función para iniciar la autenticación biométrica
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Autentícate para acceder',
        options: const AuthenticationOptions(
          biometricOnly: true, // Solo usar biometría, no PIN
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }

    if (authenticated) {
      setState(() {
        _isAuthenticated = true;
      });

      // Redirigir a la siguiente pantalla solo si la autenticación es exitosa
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const Login()), // Aquí va la lógica para la siguiente pantalla
      );
    } else {
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                'assets/images/car_logo.png', // Asegúrate de que el logo esté en assets
                height: 150,
              ),
            ),
            const SizedBox(height: 50),

            // Campo de texto Usuario
            _buildTextField('Usuario', (value) => _email = value),
            const SizedBox(height: 20),

            // Campo de texto Contraseña
            _buildTextField('Password', (value) => _clave = value,
                obscureText: true),

            const SizedBox(
                height: 100), // Espacio entre los campos y la parte inferior
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
              icon:
                  const Icon(Icons.fingerprint, color: Colors.white, size: 40),
              onPressed: () async {
                // Llamar a la función de autenticación biométrica
                await _authenticate();
              },
            ),

            // Botón flotante para continuar (parte inferior derecha)
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                // Acción para continuar a la siguiente pantalla
                validarCredenciales(context, ref);
              },
              child: const Icon(Icons.arrow_forward, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Función para crear un campo de texto editable
  Widget _buildTextField(String label, ValueChanged<String> onChanged,
      {bool obscureText = false}) {
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
      onChanged: onChanged,
    );
  }
}
