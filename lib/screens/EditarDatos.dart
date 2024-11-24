import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BiometriaService.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditarDatosScreen extends ConsumerStatefulWidget {
  static const String name = "editarDatos";
  const EditarDatosScreen({Key? key}) : super(key: key);

  @override
  _EditarDatosScreenState createState() => _EditarDatosScreenState();
}

class _EditarDatosScreenState extends ConsumerState<EditarDatosScreen> {
  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController telefonoController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool isPasswordValid = false;

  @override
  void initState() {
    super.initState();
    final usuario = ref.read(usuarioProvider);
    nombreController = TextEditingController(text: usuario.nombre);
    apellidoController = TextEditingController(text: usuario.apellido);
    telefonoController = TextEditingController(text: usuario.telefono);
    emailController = TextEditingController(text: usuario.email);
    passwordController = TextEditingController(text: usuario.password);
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    telefonoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool validatePassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasMinLength = password.length >= 8;
    return hasUppercase && hasLowercase && hasDigit && hasMinLength;
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _eliminarCuenta(BuildContext context, WidgetRef ref) async {
    final usuario = ref.read(usuarioProvider);
    final db = FirebaseFirestore.instance;

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

    if (confirmacion == true) {
      try {
        QuerySnapshot vehiculosSnapshot = await db
            .collection('Vehiculos')
            .where('userId', isEqualTo: usuario.id)
            .get();

        for (DocumentSnapshot vehiculoDoc in vehiculosSnapshot.docs) {
          await vehiculoDoc.reference.delete();
        }

        await db.collection('users').doc(usuario.id).delete();

        ref.read(usuarioProvider.notifier).clearUsuario();

        context.push('/selection');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar cuenta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(usuarioProvider);
    final BiometriaService biometriaService = BiometriaService();

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
                  _buildEditableField(
                      'Nombre Completo', nombreController, true),
                  const SizedBox(height: 20),
                  _buildEditableField('Apellido', apellidoController, true),
                  const SizedBox(height: 20),
                  _buildEditableField('Telefono', telefonoController, true),
                  const SizedBox(height: 20),
                  _buildEditableField(
                      'Correo Electrónico', emailController, false),
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    'Contraseña',
                    passwordController,
                    (value) {
                      setState(() {
                        isPasswordValid = validatePassword(value);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, y 1 número.',
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
                    onPressed: () async {
                      if (!validateEmail(emailController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Por favor ingrese un correo válido.')),
                        );
                        return;
                      }

                      if (isPasswordValid &&
                          passwordController.text ==
                              confirmPasswordController.text) {
                        final db = FirebaseFirestore.instance;

                        try {
                          await db.collection('users').doc(usuario.id).update({
                            'nombre': nombreController.text,
                            'apellido': apellidoController.text,
                            'telefono': telefonoController.text,
                            'email': emailController.text,
                            'password': passwordController.text,
                          });

                          ref.read(usuarioProvider.notifier).setUsuario(
                                usuario.id,
                                nombreController.text,
                                apellidoController.text,
                                emailController.text,
                                passwordController.text,
                                usuario.dni,
                                usuario.telefono,
                                usuario.token!,
                                usuario.esAdmin,
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Datos guardados exitosamente.')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error al guardar cambios: $e')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Verifique la contraseña y su confirmación.'),
                        ));
                      }
                    },
                    child: const Text("Guardar Cambios"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      biometriaService.registrarHuella(
                        context,
                        usuario.id,
                        {
                          'email': emailController.text,
                          'password': passwordController.text,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                    ),
                    child: const Text(
                      "Habilitar Huella Digital",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _eliminarCuenta(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(191, 152, 12, 2),
                    ),
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
                context.push('/HomeUser');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, bool? soloLectura) {
    return TextField(
      controller: controller,
      enabled: soloLectura ?? true,
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
        disabledBorder: const OutlineInputBorder(
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
