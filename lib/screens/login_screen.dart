import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});
  String _email = '';
  String _clave = '';
  static const String name = "LoginScreen";
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
                await _authenticate(); //VEEEEEEEEEEEEEEEEEERRRRRRRRRRR
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

  validarCredenciales(BuildContext context, WidgetRef ref) async {
    try {
      // Realizar la consulta a Firestore para obtener el usuario con el correo electrónico especificado

      QuerySnapshot querySnapshot =
          await db.collection("users").where("email", isEqualTo: _email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Obtener el primer documento que cumple con la consulta
        QueryDocumentSnapshot userDocument = querySnapshot.docs.first;

        // Obtener los datos del usuario
        Map<String, dynamic>? userData =
            userDocument.data() as Map<String, dynamic>?;

        if (userData != null) {
          String? userEmail = userData['email'] as String?;
          String? userPassword = userData['password'] as String?;
          print('LLEGUE');
          if (userEmail != null && userPassword != null) {
            // Verificar si el correo electrónico ingresado coincide con el almacenado
            if (userEmail == _email) {
              // Verificar si la contraseña ingresada coincide con la almacenada
              if (userPassword == _clave) {
                ref.read(usuarioProvider.notifier).setUsuario(
                    userData['id'],
                    userData['nombre'],
                    userData['apellido'],
                    userData['email'],
                    userData['telefono'],
                    userData['dni'],
                    userData['password'],
                    userData['esAdmin']);

                if (userData['esAdmin'] == true) {
                  //context.goNamed(todasLasReservas.nombre);
                } else {
                  context.goNamed(login_exitoso_home_user.name);
                }
                // Usuario autenticado con éxito
              } else {
                print('Contraseña incorrecta.');
              }
            } else {
              print(
                  'El correo electrónico ingresado no coincide con ningún usuario.');
            }
          } else {
            print('Los datos del usuario están incompletos.');
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error con el usuario o contraseña.')));
        }
      } else {
        print('Email: ${_email}');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ingrese todos los datos para iniciar sesion.')));
      }
    } catch (e) {
      print('Error: $e');
      // Manejar el error
    }
  }

  // Función para iniciar la autenticación biométrica
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

    /* if (authenticated) {
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
  }*/
  }
}
