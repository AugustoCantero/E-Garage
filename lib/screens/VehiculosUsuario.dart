import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
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
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/car_logo.png',
                height: 120,
              ),
              const SizedBox(height: 20),
              const Text(
                'SUS VEHICULOS',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 20),
              const Expanded(child: _ListView()), // Lista de vehículos
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(92, 54, 243, 33),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                  onPressed: () {
                    context.goNamed('AgregarVehiculos');
                  },
                  child: const Text(
                    "Agregar vehículo",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          BackButtonWidget(
            onPressed: () {
              context.goNamed('HomeUser'); // Usa el nombre definido en GoRoute
            },
          )
        ],
      ),
    );
  }
}

class _ListView extends ConsumerWidget {
  const _ListView();

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
                          title: Text('Patente: ${elVehiculo.patente}',
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            "Modelo: ${elVehiculo.modelo}, Marca: ${elVehiculo.marca}, Color: ${elVehiculo.color}",
                            style: const TextStyle(color: Colors.white70),
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
