import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/Test_agregar_vehiculos.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class vehiculosUsuario extends ConsumerStatefulWidget {
  static const String name = 'vehiculosUsuario';
  const vehiculosUsuario({super.key});

  @override
  vehiculosUsuarioState createState() => vehiculosUsuarioState();
}

class vehiculosUsuarioState extends ConsumerState<vehiculosUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Text(
          'SUS VEHICULOS',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: _buildDrawer(context),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/car_logo.png', // Ruta de la imagen del auto
            height: 120,
          ),
          const SizedBox(height: 20),
          Expanded(child: _ListView()), // Lista de vehículos
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(92, 54, 243, 33),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () {
                context.goNamed(TestAgregarVehiculos.name);
              },
              child: const Text("Agregar vehículo", style:TextStyle(color: Colors.white),
            ),  
          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

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
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.timer, size: 40, color: Colors.black),
              title: const Text('Gestión de Vehiculos', style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.history, size: 40, color: Colors.black),
              title: const Text('Historial y Registro', style: TextStyle(fontSize: 18)),
              onTap: () {},
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

class _ListView extends ConsumerWidget {
  const _ListView({super.key});

  Future<List<Vehiculo>> _fetchAutos(WidgetRef ref) async {
    final usuarioState = ref.watch(usuarioProvider);
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection('Vehiculos')
        .where('userId', isEqualTo: usuarioState.id)
        .get();

    return snapshot.docs.map((doc) {
      return Vehiculo.fromFirestore(doc, null);
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: FutureBuilder<List<Vehiculo>>(
              future: _fetchAutos(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tiene vehículos cargados.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  List<Vehiculo> listaReservas = snapshot.data!;
                  return Column(
                    children: listaReservas.map((elVehiculo) {
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          title: Text('Patente: ${elVehiculo.patente}', style: TextStyle(color: Colors.white)),
                          subtitle: Text(
                            "Modelo: ${elVehiculo.modelo}, Marca: ${elVehiculo.marca}, Color: ${elVehiculo.color}",
                            style: TextStyle(color: Colors.white70),
                          ),
                          onTap: () {
                            Navigator.pop(context, elVehiculo);
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
