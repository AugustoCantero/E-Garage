import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/preferencias/pref_usuarios.dart';
import 'package:flutter_application_1/screens/LoginAdministrador.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:flutter_application_1/services/bloc/notifications_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    try {
      QuerySnapshot querySnapshot =
          await db.collection("users").where("email", isEqualTo: _email).get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot userDocument = querySnapshot.docs.first;
        Map<String, dynamic>? userData =
            userDocument.data() as Map<String, dynamic>?;

        if (userData != null) {
          String? userEmail = userData['email'] as String?;
          String? userPassword = userData['password'] as String?;

          if (userEmail == _email && userPassword == _clave) {
            context.read<NotificationsBloc>().requestPermission();
            if (userData['token'] == null) {
              var prefs = PreferenciasUsuario();
              final datos = await db.collection('users').doc(userData['id']);
              datos.update({'token': prefs.token});
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
                userData['esAdmin']);

            if (userData['esAdmin'] == false) {
              context.goNamed(LoginUsuario.name);
            } else {
              context.goNamed(AdminHomePage.name);
            }
          } else {
            _showErrorSnackbar(context, 'Contraseña incorrecta.');
          }
        } else {
          _showErrorSnackbar(context, 'Error con el usuario o contraseña.');
        }
      } else {
        _showErrorSnackbar(context, 'Usuario no encontrado.');
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Error: $e');
    }
  }

  Future<void> _authenticate(BuildContext context, WidgetRef ref) async {
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
        validarCredenciales(context, ref);
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
