import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_application_1/screens/chatBotPage.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

class GestionVehiculosScreen extends StatefulWidget {
  static const String name = 'ReservationSelectVehicule';

  const GestionVehiculosScreen({super.key});

  @override
  State<GestionVehiculosScreen> createState() => _GestionVehiculosScreenState();
}

class _GestionVehiculosScreenState extends State<GestionVehiculosScreen> {
  Vehiculo? vehiculoSeleccionado;

  @override
  Widget build(BuildContext context) {
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
                Scaffold.of(context).openDrawer(); // Abrir el Drawer (Menú hamburguesa)
              },
            );
          },
        ),
        title: const Text(
          'GESTION DE VEHICULOS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Centrar el título
      ),
      drawer: _buildDrawer(context), // Agregar el Drawer
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/car_logo.png',  // Reemplaza con la ruta de tu logo
                  height: 100,  // Ajusta el tamaño del logo según sea necesario
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => vehiculosUsuario()),
                    );

                    if (resultado != null && resultado is Vehiculo) {
                      setState(() {
                        vehiculoSeleccionado = resultado;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vehiculoSeleccionado == null
                          ? 'Seleccionar Vehiculo'
                          : 'Vehículo: ${vehiculoSeleccionado!.patente}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    print('Acción de gestión de reservas 2');
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatBotPage()),
                );
              },
              backgroundColor: Colors.transparent,
              child: Image.asset(
                'assets/images/bot.png',
                height: 70,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
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
                // Lógica de navegación a Editar Datos
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, size: 40, color: Colors.black),
              title: const Text('Gestión de Vehiculos', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Lógica de navegación o acción para Gestión de Reservas
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, size: 40, color: Colors.black),
              title: const Text('Historial y Registro', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Lógica de navegación o acción para Historial y Registro
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, size: 40, color: Colors.black),
              title: const Text('Salir', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
