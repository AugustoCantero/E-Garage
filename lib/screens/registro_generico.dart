import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistroGenericoScreen extends StatefulWidget {
  const RegistroGenericoScreen({super.key});

  @override
  _RegistroGenericoScreen createState() => _RegistroGenericoScreen();
}

class _RegistroGenericoScreen extends State<RegistroGenericoScreen> {
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

  // Función para guardar los datos del usuario
  Future<bool> _guardarUsuario() async {
    final String nombre = _nombreController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (password != _confirmPasswordController.text) {
      // Mostrar mensaje de error si las contraseñas no coinciden
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Las contraseñas no coinciden'),
      ));
      return false; // No proceder con la navegación
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('nombre', nombre);
      await prefs.setString('email', email);
      await prefs.setString('password',
          password); // No se recomienda guardar contraseñas en texto plano

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Usuario guardado correctamente'),
      ));

      return true; // Guardado exitoso, proceder con la navegación
    } catch (error) {
      // Mostrar mensaje de error si hay problemas al guardar
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al guardar los datos del usuario'),
      ));
      return false; // Error al guardar, no proceder con la navegación
    }
  }
}
