import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/selection_screen.dart';
import 'package:go_router/go_router.dart';

import 'registro_admin_screen.dart';
import 'registro_usuario_screen.dart';

class RegistroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo del coche en la parte superior
            Image.asset(
              'assets/images/car_logo.png',
              height: 150,
            ),
            const SizedBox(height: 30),
            // Texto E-GARAJE
            const Text(
              'E-GARAJE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            // Botón de USUARIO
            OutlinedButton(
              onPressed: () {
                // Acción al presionar USUARIO
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => RegistroUsuarioScreen()),
                // );
                context.push('/registro-usuario');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'USUARIO',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            // Botón de ADMINISTRADOR
            OutlinedButton(
              onPressed: () {
                // Acción al presionar ADMINISTRADOR
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => RegistroAdminScreen()),
                // );
                context.push('/registro-admin');
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'ADMINISTRADOR',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
