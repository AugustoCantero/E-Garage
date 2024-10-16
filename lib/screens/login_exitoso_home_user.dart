import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/editar_datos.dart';
import 'package:flutter_application_1/screens/open_street_map_screen.dart';
import 'package:flutter_application_1/screens/selection_screen.dart';
import 'package:flutter_application_1/screens/chatBotPage.dart'; // Importar la pantalla del chatbot
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // Si usas go_router para la navegación

class login_exitoso_home_user extends ConsumerWidget {
  static const String name = "HomeUser";
  const login_exitoso_home_user({super.key});

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
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Abrir el Drawer cuando se hace clic en el icono
              },
            );
          },
        ),
      ),
      drawer: _buildDrawer(context), // Aquí agregamos el Drawer
      body: Stack(
        children: [
          Center(
            // Centrar el contenido principal
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo del coche en la parte superior
                Image.asset(
                  'assets/images/car_logo.png',
                  height: 100,
                ),
                const SizedBox(height: 20),

                // Texto de Bienvenida
                const Text(
                  'BIENVENIDO',
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Nombre del usuario
                Text(
                  usuario.nombre,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),

                // Botón de "Buscar Lugar"
                OutlinedButton(
                  onPressed: () {
                    //Navigator.push(
                    //context,
                    // MaterialPageRoute(
                    //builder: (context) => OpenStreetMapScreen()),
                    //  );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'BUSCAR LUGAR',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),

          // Botón flotante con el logo del bot
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatBotPage()), // Navega a ChatBotPage
                );
              },
              backgroundColor: const Color.fromARGB(0, 33, 149, 243),
              child: Image.asset('assets/images/bot.png'),
            ),
          ),
        ],
      ),
    );
  }

  // Función que crea el Drawer (Menú lateral)
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[200], // Fondo claro para el menú
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
            // Opción Editar Datos
            ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.black),
              title: const Text('Editar Datos', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditarDatosScreen()),
                );
              },
            ),
            // Opción Gestión de Reservas
            ListTile(
              leading: const Icon(Icons.timer, size: 40, color: Colors.black),
              title: const Text('Gestión de Reservas',
                  style: TextStyle(fontSize: 18)),
              onTap: () {
                // Agrega tu lógica de navegación o acción aquí
              },
            ),
            // Opción Historial y Registro
            ListTile(
              leading: const Icon(Icons.history, size: 40, color: Colors.black),
              title: const Text('Historial y Registro',
                  style: TextStyle(fontSize: 18)),
              onTap: () {
                // Agrega tu lógica de navegación o acción aquí
              },
            ),
            // Opción Salir
            ListTile(
              leading:
                  const Icon(Icons.exit_to_app, size: 40, color: Colors.black),
              title: const Text('Salir', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SelectionScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
