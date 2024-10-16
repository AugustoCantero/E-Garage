import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditarDatosScreen extends ConsumerWidget {
  const EditarDatosScreen({super.key});

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
                'assets/images/car_logo.png', // Asegúrate de que esté en assets
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
            const SizedBox(height: 10),

            // Campo Nombre Completo
            _buildEditableField(context, 'Nombre Completo', nombreController),
            const SizedBox(height: 10),

            // Campo Número DNI
            _buildEditableField(context, 'Número DNI', apellidoController),
            const SizedBox(height: 10),

            // Campo Correo Electrónico
            _buildEditableField(context, 'Correo Electrónico', emailController),
            const SizedBox(height: 10),

            // Campo Contraseña
            _buildEditableField(context, 'Contraseña', passwordController,
                obscureText: true),
            const SizedBox(height: 10),

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

            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    context.goNamed(vehiculosUsuario.name);
                  },
                  child: const Text("Mis vehiculos")),
            ),

            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    final db = FirebaseFirestore.instance;
                    await db.collection('users').doc(usuario.id).delete();
                    context.goNamed(vehiculosUsuario.name);
                  },
                  child: const Text("Eliminar cuenta")),
            ),

            const Spacer(),

            // Botón de retroceso en la parte inferior izquierda
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context); // Regresar a la pantalla anterior
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para crear un campo de texto editable con ícono de edición
  Widget _buildEditableField(BuildContext context, String label,
      TextEditingController controladorEspecifico,
      {bool obscureText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Campo de texto
        Expanded(
          child: TextField(
            controller: controladorEspecifico,
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
