import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/app_router.dart';
import 'screens/intro_screen.dart';

void main() => runApp(EGarajeApp());

class EGarajeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      // home: IntroScreen(), // Primera pantalla que se muestra
    );
  }
}