import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegistroUsuarioScreen extends StatefulWidget {
  @override
  _RegistroUsuarioScreenState createState() => _RegistroUsuarioScreenState();
}

class _RegistroUsuarioScreenState extends State<RegistroUsuarioScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
              SizedBox(height: 30),
              Image.asset(
                'assets/images/car_logo.png',
                height: 200,
              ),
              SizedBox(height: 30),
              _buildTextField('Nombre Completo', _nombreController),
              SizedBox(height: 20),
              _buildTextField('Número DNI', _dniController),
              SizedBox(height: 20),
              _buildTextField('Correo Electrónico', _emailController, TextInputType.emailAddress),
              SizedBox(height: 20),
              _buildPasswordField('Contraseña', _passwordController),
              SizedBox(height: 10),
              Text(
                'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, 1 número.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(height: 20),
              _buildPasswordField('Reingrese Contraseña', _confirmPasswordController),
              SizedBox(height: 10),
              Text(
                'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, 1 número.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              SizedBox(height: 30),
              FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: _guardarUsuario,
                child: Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función para crear los campos de texto con el tipo de teclado correcto
  Widget _buildTextField(String labelText, TextEditingController controller, [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  // Función para guardar los datos del usuario
  Future<void> _guardarUsuario() async {
    final String nombre = _nombreController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (password != _confirmPasswordController.text) {
      // Mostrar mensaje de error si las contraseñas no coinciden
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Las contraseñas no coinciden'),
      ));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nombre', nombre);
    await prefs.setString('email', email);
    await prefs.setString('password', password);  // No se recomienda guardar contraseñas en texto plano

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Usuario guardado correctamente'),
    ));
  }
}
