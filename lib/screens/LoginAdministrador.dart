import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuAdministrador.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/Mapa.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminHomePage extends ConsumerWidget {
  static const String name = "HomeAdmin";
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuario = ref.watch(usuarioProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () { Scaffold.of(context).openDrawer();
            },
            );
          }
        ),
      ),
      drawer: const MenuAdministrador(), // Usando el drawer reutilizable
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/car_logo.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                const Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
            const SizedBox(height: 50),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OpenStreetMapScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
              child: const Text(
                'Mi Garage',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
                ),
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}