import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditarDatosAdmin extends ConsumerWidget {
  const EditarDatosAdmin({super.key});

  Future<void> _eliminarCuenta(BuildContext context, WidgetRef ref) async {
    final usuario = ref.read(usuarioProvider);
    final db = FirebaseFirestore.instance;

    // Diálogo de confirmación para eliminar la cuenta
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Quieres eliminar tu cuenta?'),
          content: const Text('Esta acción no se puede deshacer.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Sí'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ],
        );
      },
    );

    // Si el usuario confirma la eliminación
    if (confirmacion == true) {
      try {
        // Eliminar la cuenta de Firebase
        await db.collection('users').doc(usuario.id).delete();

        // Limpiar el estado de usuario y token de autenticación
        ref.read(usuarioProvider.notifier).clearUsuario();

        // Redirigir a la pantalla de inicio de sesión
        context.goNamed('SelectionScreen'); // Cambia esto por la ruta de tu pantalla de inicio de sesión
      } catch (e) {
        // Manejar errores al eliminar la cuenta
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar cuenta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioProvider);

    final TextEditingController nombreController =
        TextEditingController(text: usuario.nombre);
    final TextEditingController apellidoController =
        TextEditingController(text: usuario.apellido);
    final TextEditingController emailController =
        TextEditingController(text: usuario.email);
    final TextEditingController passwordController =
        TextEditingController(text: usuario.password);
    final TextEditingController confirmPasswordController =
        TextEditingController();

    bool isPasswordValid = false;

    bool validatePassword(String password) {
      final hasUppercase = password.contains(RegExp(r'[A-Z]'));
      final hasLowercase = password.contains(RegExp(r'[a-z]'));
      final hasDigit = password.contains(RegExp(r'\d'));
      final hasMinLength = password.length >= 8;
      return hasUppercase && hasLowercase && hasDigit && hasMinLength;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const MenuUsuario(),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/car_logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'EDITAR DATOS',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEditableField('Nombre Completo', nombreController),
                  const SizedBox(height: 20),
                  _buildEditableField('Apellido', apellidoController),
                  const SizedBox(height: 20),
                  _buildEditableField('Correo Electrónico', emailController),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    'Contraseña',
                    passwordController,
                    (value) {
                      isPasswordValid = validatePassword(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, 1 número.',
                    style: TextStyle(
                      color: isPasswordValid ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                      'Confirmar Contraseña', confirmPasswordController, null),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (isPasswordValid &&
                          passwordController.text ==
                              confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Datos guardados exitosamente.')));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Verifique la contraseña y su confirmación.')));
                      }
                    },
                    child: const Text("Guardar Cambios"),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(191, 152, 12, 2),
                    ),
                    onPressed: () {  },
                    child: const Text(
                      "Eliminar cuenta",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: BackButtonWidget(
              onPressed: () {
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
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
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      ValueChanged<String>? onChanged) {
    return TextField(
      controller: controller,
      obscureText: true,
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
}
