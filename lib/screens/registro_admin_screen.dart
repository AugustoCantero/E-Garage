import 'package:flutter/material.dart';

class RegistroAdminScreen extends StatelessWidget {
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
                height: 150,
              ),
              const SizedBox(height: 30),
              _buildTextField('Razón Social', TextInputType.text),
              const SizedBox(height: 20),
              _buildTextField('Número CUIT', TextInputType.number),
              const SizedBox(height: 20),
              _buildTextField('Correo Electrónico', TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildPasswordField('Contraseña'),
              const SizedBox(height: 10),
              const Text(
                'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, 1 número.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 20),
              _buildPasswordField('Reingrese Contraseña'),
              const SizedBox(height: 10),
              const Text(
                'La contraseña debe contener como mínimo 8 caracteres, letras mayúsculas y minúsculas, 1 número.',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          // Acción al presionar el botón
        },
        child: const Icon(Icons.arrow_forward, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTextField(String labelText, TextInputType inputType) {
    return TextField(
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

  Widget _buildPasswordField(String labelText) {
    return TextField(
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
}
