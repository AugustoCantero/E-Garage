import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';

class TEST_EDICION_CUENTA extends ConsumerWidget {
  static final String name = "TEST_EDICION_CUENTA";
  const TEST_EDICION_CUENTA({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el usuario actual del provider
    final usuario = ref.watch(usuarioProvider);

    // Controladores para los campos de texto
    final TextEditingController nombreController =
        TextEditingController(text: usuario.nombre);
    final TextEditingController apellidoController =
        TextEditingController(text: usuario.apellido);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: apellidoController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Obtener la referencia a Firestore
                final db = FirebaseFirestore.instance;

                // Actualizar los datos en Firestore
                await db.collection('users').doc(usuario.id).update({
                  'nombre': nombreController.text,
                  'apellido': apellidoController.text,
                });

                // Actualizar el provider
                ref.read(usuarioProvider.notifier).setUsuario(
                      usuario.id,
                      nombreController.text,
                      apellidoController.text,
                      usuario.email,
                      usuario.password,
                      usuario.telefono,
                      usuario.dni,
                      usuario.esAdmin = false,
                    );

                // Regresar a la pantalla anterior
                context.goNamed(LoginUsuario.name);
              },
              child: const Text('Guardar Cambios'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Obtener la referencia a Firestore
                final db = FirebaseFirestore.instance;

                // Elimina los datos en Firestore
                await db.collection('users').doc(usuario.id).delete();

                // Regresar a la pantalla anterior
                context.goNamed('/login');
                
              },
              child: const Text('Eliminar cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
