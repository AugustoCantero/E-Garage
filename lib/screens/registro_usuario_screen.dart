import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/router/Usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroUsuarioScreen extends StatefulWidget {
  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
              _buildTextField('Nombre Completo', _nombreController),
              const SizedBox(height: 20),
              _buildTextField('Número DNI', _dniController),
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
                onPressed: _guardarUsuario,
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
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

  // Función para guardar los datos del usuario
  Future<void> _guardarUsuario() async {
    try {
      // Registrar usuario con Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // se asigna el user que surga de la creacion del correo y password
      // Puede aceptar un null
      User? user = userCredential.user;

      //Almaceno en variables para controlar datos
      final String nombre = _nombreController.text;
      final String email = _emailController.text;
      final String password = _passwordController.text;

      if (password != _confirmPasswordController.text) {
        // Mostrar mensaje de error si las contraseñas no coinciden
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Las contraseñas no coinciden'),
        ));
        return;
      }

      // Verifica que el usuario creado no haya llegado en null
      if (user != null) {
        // Crear instancia de Usuario
        Usuario newUser = Usuario(
          id: user.uid,
          email: _emailController.text,
          contrasenia: _passwordController.text,
          nombre: _nombreController.text,
          apellido: _nombreController.text,
          dni: _dniController.text,
        );

        // Crear documento en Firestore con el UID del usuario
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid) // Utilizar user.uid directamente aquí
            .set(newUser.toFirestore());

        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Usuario guardado correctamente'),
        ));

        // Navegar a la pantalla de inicio (o a donde desees)
        //context.goNamed(Login.name); // Asegúrate de que '/' es la ruta correcta
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre', nombre);
      await prefs.setString('email', email);
      await prefs.setString('password',
          password); // No se recomienda guardar contraseñas en texto plano
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
  }
}
