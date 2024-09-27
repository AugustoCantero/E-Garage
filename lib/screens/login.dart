import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/screen_principal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Login extends ConsumerWidget {
  static const String name = 'Login';

  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _email = '';
    String _clave = '';
    final db = FirebaseFirestore.instance;
    final ValueNotifier<bool> _showPassword = ValueNotifier<bool>(false);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Logo del Login
            const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
              size: 120,
            ),

            //Espacio
            const SizedBox(height: 40),

            //EMAIL
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'EMAIL'),
              onChanged: (value) {
                _email = value;
              },
            ),

            // PASS
            ValueListenableBuilder<bool>(
              valueListenable: _showPassword,
              builder: (context, value, child) {
                return TextField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: !value,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    suffixIcon: IconButton(
                      icon: Icon(
                        value ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showPassword.value = !value;
                      },
                    ),
                  ),
                  onChanged: (value) {
                    _clave = value;
                  },
                );
              },
            ),

            //Olvdaste la contraseña?
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Text(
                '¿Olvidaste la contraseña? Hace click aca',
                style: TextStyle(
                  color: Colors.blueGrey[100],
                ),
              ),
            ),

            //Espacio
            const SizedBox(height: 50),

            //Loguearse
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: <Color>[
                    Color(0xFF0D47A1),
                    Color(0xFF1976D2),
                    Color(0xFF42A5F5),
                  ])),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  try {
                    // Realizar la consulta a Firestore para obtener el usuario con el correo electrónico especificado
                    QuerySnapshot querySnapshot = await db
                        .collection("users")
                        .where("email", isEqualTo: _email)
                        .get();

                    /* if (querySnapshot.docs.isNotEmpty) {
                      // Obtener el primer documento que cumple con la consulta
                      QueryDocumentSnapshot userDocument =
                          querySnapshot.docs.first;

                      // Obtener los datos del usuario
                      Map<String, dynamic>? userData =
                          userDocument.data() as Map<String, dynamic>?;

                      if (userData != null) {
                        String? userEmail = userData['email'] as String?;
                        String? userPassword =
                            userData['contrasenia'] as String?;

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
                                  userData['contrasenia'],
                                  userData['esAdmin']);

                              if (userData['esAdmin'] == true) {
                                context.goNamed(todasLasReservas.nombre);
                              } else {*/
                    context.go('/ScreenPrincipal');
                    /* }
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
                        print('No se encontraron datos del usuario.');
                      }
                    } else {
                      print('Usuario no encontrado.');
                    }*/
                  } catch (e) {
                    print('Error: $e');
                    // Manejar el error
                  }
                },
                child: const Text('Login'),
              ),
            ),

            const SizedBox(
              height: 20.5,
            ),
          ],
        ),
      ),
    );
  }

  // App Bar
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Login V1'),
      centerTitle: true,
      backgroundColor: Colors.blue[200],
    );
  }
}
