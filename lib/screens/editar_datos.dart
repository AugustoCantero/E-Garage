import 'package:flutter/material.dart';

class EditarDatosScreen extends StatelessWidget {
  const EditarDatosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Abre el menú hamburguesa
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo del coche en la parte superior
            Center(
              child: Image.asset(
                'assets/images/car_logo.png',  // Asegúrate de que esté en assets
                height: 100,
              ),
            ),
            const SizedBox(height: 20),

            // Título "EDITAR DATOS"
            const Center(
              child: Text(
                'EDITAR DATOS',
                style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Campo Nombre Completo
            _buildEditableField(context, 'Nombre Completo'),
            const SizedBox(height: 20),

            // Campo Número DNI
            _buildEditableField(context, 'Número DNI'),
            const SizedBox(height: 20),

            // Campo Correo Electrónico
            _buildEditableField(context, 'Correo Electrónico'),
            const SizedBox(height: 20),

            // Campo Contraseña
            _buildEditableField(context, 'Contraseña', obscureText: true),
            const SizedBox(height: 20),

            // Opción Configurar Datos Biométricos (sin campo de texto)
            GestureDetector(
              onTap: () {
                // Agregar lógica para configurar datos biométricos
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Configurar Datos Biométricos',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Icon(Icons.edit, color: Colors.white, size: 30),
                ],
              ),
            ),

            const Spacer(),

            // Botón de retroceso en la parte inferior izquierda
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);  // Regresar a la pantalla anterior
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para crear un campo de texto editable con ícono de edición
  Widget _buildEditableField(BuildContext context, String label, {bool obscureText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Campo de texto
        Expanded(
          child: TextField(
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
          ),
        ),
        const SizedBox(width: 10),
        // Icono de editar
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            // Lógica de edición (puedes agregar funciones aquí)
          },
        ),
      ],
    );
  }
}
