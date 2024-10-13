import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthPage extends StatefulWidget {
  @override
  _BiometricAuthPageState createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends State<BiometricAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;

  // Función para iniciar la autenticación biométrica
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Autentícate para ingresar a la app',
        options: const AuthenticationOptions(
          biometricOnly: true, // Solo usar biometría, no PIN
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }

    setState(() {
      _isAuthenticated = authenticated;
    });

    if (_isAuthenticated) {
      // Redirigir a la pantalla principal si la autenticación es exitosa
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()), // Pantalla principal de la app
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _authenticate(); // Llamar a la autenticación al iniciar la app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Autenticación biométrica"),
      ),
      body: Center(
        child: _isAuthenticated
            ? Text('Acceso concedido')
            : Text('Autenticando...'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
      ),
      body: Center(
        child: Text('¡Bienvenido a la app!'),
      ),
    );
  }
}
