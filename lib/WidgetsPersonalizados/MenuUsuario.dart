// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuUsuario extends ConsumerWidget {
  const MenuUsuario({super.key});

  Future<void> _logOut(BuildContext context, WidgetRef ref) async {
    ref.read(usuarioProvider.notifier).clearUsuario();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    context.push('/selection');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Menú',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.black),
              title: const Text('Editar Datos', style: TextStyle(fontSize: 18)),
              onTap: () {
                context.push('/EditarDatos');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.car_rental, size: 40, color: Colors.black),
              title:
                  const Text('Mis Vehiculos', style: TextStyle(fontSize: 18)),
              onTap: () {
                context.push('/vehiculosUsuario');
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, size: 40, color: Colors.black),
              title: const Text('Gestión de Reservas',
                  style: TextStyle(fontSize: 18)),
              onTap: () {
                context.push('/reservasUsuario');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, size: 40, color: Colors.black),
              title: const Text('Salir', style: TextStyle(fontSize: 18)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('¿Quieres salir?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Sí'),
                          onPressed: () {
                            Navigator.pop(context);
                            _logOut(context,
                                ref);
                          },
                        ),
                        TextButton(
                          child: const Text('No'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
