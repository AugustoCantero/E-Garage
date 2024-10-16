import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Usuario.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/selection_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroGenericoScreen extends StatefulWidget {
  const RegistroGenericoScreen({super.key});

  @override
  _RegistroGenericoScreen createState() => _RegistroGenericoScreen();
}

class _RegistroGenericoScreen extends State<RegistroGenericoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // PANTALLA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Image.asset(
                'assets/images/car_logo.png',
                height: 200,
              ),
              const SizedBox(height: 30),
              _buildTextField('Nombre', _nombreController),
              const SizedBox(height: 20),
              _buildTextField('Apellido', _apellidoController),
              const SizedBox(height: 20),
              _buildTextField('Número DNI', _dniController),
              const SizedBox(height: 20),
              _buildTextField('Telefono', _telefonoController),
              const SizedBox(height: 20),
              _buildTextField('Correo Electrónico', _emailController,
                  TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildPasswordField('Contraseña', _passwordController),
              const SizedBox(height: 10),
              const Text(
                'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, 1 número.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                  'Reingrese Contraseña', _confirmPasswordController),
              const SizedBox(height: 10),
              const Text(
                'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, 1 número.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 30),
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: () async {
                  // Primero, guardamos el usuario
                  bool isSaved = await _guardarUsuario();

                  // Si el usuario se guarda correctamente, navegamos a la pantalla de selección
                  if (isSaved) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectionScreen()),
                    );
                  }
                },
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Función para crear los campos de texto con el tipo de teclado correcto
  Widget _buildTextField(String labelText, TextEditingController controller,
      [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
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

  Widget _buildPasswordField(
      String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
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

  Future<bool> _guardarUsuario() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      // Mostrar mensaje de error si las contraseñas no coinciden
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Las contraseñas no coinciden'),
      ));
      return false; // No proceder con la navegación
    }

    try {
      // Registrar usuario con Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // se asigna el user que surja de la creación del correo y password
      User? user = userCredential.user;

      // Verifica que el usuario creado no haya llegado en null
      if (user != null) {
        // Crear instancia de Usuario
        Usuario newUser = Usuario(
            id: user.uid,
            email: _emailController.text,
            password: _passwordController.text,
            nombre: _nombreController.text,
            apellido: _apellidoController.text,
            dni: _dniController.text,
            telefono: _telefonoController.text);

        // Crear documento en Firestore con el UID del usuario
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Utilizar user.uid directamente aquí
            .set(newUser.toFirestore());

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Usuario guardado correctamente'),
        ));

        return true; // Asegúrate de que '/' es la ruta correcta
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'El correo electrónico ya está en uso por otra cuenta.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'La contraseña es demasiado débil.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'El correo electrónico es inválido.';
      } else {
        errorMessage = 'Error al registrar el usuario: ${e.message}';
      }

      print('Error al registrar el usuario: $errorMessage');

      // Muestra un mensaje de error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print('Error al registrar el usuario: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar el usuario: $e')),
      );
    }

    return false; // Añadido para asegurarse de que siempre se retorna un valor
  }

  // Función para guardar los datos del usuario
}
