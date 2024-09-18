import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';

void main() => runApp(EGarajeApp());

class EGarajeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroScreen(), // Primera pantalla que se muestra
    );
  }
}