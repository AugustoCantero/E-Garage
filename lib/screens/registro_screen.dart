import 'package:flutter/material.dart';

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
            SizedBox(height: 30),
            // Texto E-GARAJE
            Text(
              'E-GARAJE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 50),
            // Botón de USUARIO
            OutlinedButton(
              onPressed: () {
                // Acción al presionar USUARIO
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistroUsuarioScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'USUARIO',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            // Botón de ADMINISTRADOR
            OutlinedButton(
              onPressed: () {
                // Acción al presionar ADMINISTRADOR
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistroAdminScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
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
