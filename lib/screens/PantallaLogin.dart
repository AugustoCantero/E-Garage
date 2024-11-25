import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/preferencias/pref_usuarios.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:flutter_application_1/services/bloc/notifications_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  String _email = '';
  String _clave = '';
  final db = FirebaseFirestore.instance;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    context.read<NotificationsBloc>().requestPermission();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/car_logo.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 50),
            _buildTextField('Email', (value) => _email = value),
            const SizedBox(height: 20),
            _buildTextField('Password', (value) => _clave = value,
                obscureText: true),
            const SizedBox(height: 50),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BackButtonWidget(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.fingerprint, color: Colors.white, size: 40),
              onPressed: () async {
                await _authenticate(context, ref);
              },
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                onPressed: () {
                  validarCredenciales(context, ref);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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

  validarCredenciales(BuildContext context, WidgetRef ref) async {
    _email = _email.trim();
    _clave = _clave.trim();

    if (_email.isEmpty || _clave.isEmpty) {
      _showErrorSnackbar(context, 'Por favor, complete todos los campos.');
      return;
    }

    if (!_esCorreoValido(_email)) {
      _showErrorSnackbar(
          context, 'El correo electrónico no tiene un formato válido.');
      return;
    }

    try {
      // Intentamos hacer login con las credenciales proporcionadas
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _clave);

      User? user = userCredential.user;

      if (user != null) {
        // Si el usuario es encontrado, lo rediriges o haces lo que necesites
        // Por ejemplo, obtener información de Firestore:
        QuerySnapshot querySnapshot = await db
            .collection("users")
            .where("email", isEqualTo: _email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          QueryDocumentSnapshot userDocument = querySnapshot.docs.first;
          Map<String, dynamic> userData =
              userDocument.data() as Map<String, dynamic>;

          if (userData['token'] == null ||
              userData['token'].toString().isEmpty) {
            var prefs = await PreferenciasUsuario();
            final datos = db.collection('users').doc(userData['id']);

            // Actualizar el token en Firestore
            try {
              print("Iniciando actualización del token en Firestore...");
              await datos.update({'token': prefs.token});
              print("Token actualizado correctamente.");

              // Actualizar el token localmente después de confirmar la operación en Firestore
              userData['token'] = prefs.token;
            } catch (e) {
              print("Error al actualizar el token en Firestore: $e");
              // Manejo de errores (puedes lanzar una excepción o mostrar un mensaje)
              _showErrorSnackbar(context, "No se pudo actualizar el token.");
              return; // Detener el flujo si falla la actualización
            }
          }

// Continuar el flujo solo después de la actualización del token
          ref.read(usuarioProvider.notifier).setUsuario(
                userData['id'],
                userData['nombre'],
                userData['apellido'],
                userData['email'],
                userData['password'],
                userData['dni'],
                userData['telefono'],
                userData['token'], // Ahora contiene el token actualizado
                userData['esAdmin'],
              );

          if (userData['esAdmin'] == false) {
            context.goNamed(LoginUsuario.name);
          }
          ref.read(usuarioProvider.notifier).setUsuario(
                userData['id'],
                userData['nombre'],
                userData['apellido'],
                userData['email'],
                userData['password'],
                userData['dni'],
                userData['telefono'],
                userData['token'],
                userData['esAdmin'],
              );
          context.goNamed(LoginUsuario.name);
        } else {
          _showErrorSnackbar(
              context, 'Usuario no encontrado en la base de datos.');
        }
      }
    } on FirebaseAuthException catch (e) {
      // Manejamos las excepciones específicas
      print("Error: ${e.code}");

      if (e.code == 'invalid-credential') {
        // Error de credenciales mal formadas o incorrectas
        _showErrorSnackbar(context, 'Usuario o contraseña incorrecto');
      } else {
        switch (e.code) {
          case 'user-not-found':
            _showErrorSnackbar(context, 'Usuario no encontrado.');
            break;
          case 'wrong-password':
            _showErrorSnackbar(context, 'Contraseña incorrecta.');
            break;
          case 'invalid-email':
            _showErrorSnackbar(
                context, 'El correo electrónico tiene un formato incorrecto.');
            break;
          default:
            _showErrorSnackbar(context, 'Error: ${e.message}');
        }
      }
    } catch (e) {
      // En caso de un error inesperado
      _showErrorSnackbar(context, 'Error inesperado: $e');
    }
  }

// Método para validar el formato del correo electrónico
  bool _esCorreoValido(String email) {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  Future<void> _authenticate(BuildContext context, WidgetRef ref) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Autentícate para acceder',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        // Recuperar las credenciales almacenadas
        String? email = await storage.read(key: 'email');
        String? password = await storage.read(key: 'password');

        if (email != null && password != null) {
          // Validar usuario con las credenciales recuperadas
          QuerySnapshot querySnapshot = await db
              .collection("users")
              .where("email", isEqualTo: email)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            Map<String, dynamic> userData =
                querySnapshot.docs.first.data() as Map<String, dynamic>;

            if (userData['email'] == email &&
                userData['password'] == password) {
              ref.read(usuarioProvider.notifier).setUsuario(
                    userData['id'],
                    userData['nombre'],
                    userData['apellido'],
                    userData['email'],
                    userData['password'],
                    userData['dni'],
                    userData['telefono'],
                    userData['token'],
                    userData['esAdmin'],
                  );

              // Redirigir según el tipo de usuario
              if (userData['esAdmin'] == false) {
                context.goNamed(LoginUsuario.name);
              }
            } else {
              _showErrorSnackbar(context, 'Error de autenticación.');
            }
          } else {
            _showErrorSnackbar(context, 'Usuario no encontrado.');
          }
        } else {
          _showErrorSnackbar(
            context,
            'No se encontraron credenciales almacenadas.',
          );
        }
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error de autenticación biométrica: $e');
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }
}
