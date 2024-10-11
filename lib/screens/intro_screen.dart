import 'package:flutter/material.dart';
import 'selection_screen.dart'; // Importa la siguiente pantalla

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo en el centro
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SelectionScreen()),
          );
        },
        child: const Icon(Icons.arrow_forward, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
