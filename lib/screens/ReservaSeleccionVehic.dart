import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Usuario.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GestionVehiculosScreen extends ConsumerStatefulWidget {
  static const String name = 'ReservationSelectVehicule';
  const GestionVehiculosScreen({super.key});

  @override
  ConsumerState<GestionVehiculosScreen> createState() =>
      _GestionVehiculosScreenState();
}

class _GestionVehiculosScreenState
    extends ConsumerState<GestionVehiculosScreen> {
  String? selectedVehicle;
  Vehiculo? vehiculoSeleccionado;

  void _showVehiclePicker(BuildContext context, Usuario usuarioLogueado) {
    final db = FirebaseFirestore.instance;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: db
                .collection('Vehiculos')
                .where('userId', isEqualTo: usuarioLogueado.id)
                .get(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar vehículos'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No se encontraron vehículos'));
              }

              List<DocumentSnapshot<Map<String, dynamic>>> vehicles =
                  snapshot.data!.docs;

              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (BuildContext context, int index) {
                  final vehiculo =
                      Vehiculo.fromFirestore(vehicles[index], null);

                  return ListTile(
                    title: Text(vehiculo.patente ??
                        'Sin patente'),
                    subtitle: Text(vehiculo.modelo ?? 'Sin Modelo'),
                    trailing: Text(vehiculo.marca ?? 'Sin Marca'),

                    onTap: () {
                      setState(() {
                        selectedVehicle = vehiculo
                            .marca; 
                        vehiculoSeleccionado = vehiculo;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioState = ref.watch(usuarioProvider);
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
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const MenuUsuario(),
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
                  'GESTION DE VEHICULOS',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    if (usuarioState != null) {
                      _showVehiclePicker(context, usuarioState);
                    } else {
                      print('Usuario no encontrado');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vehiculoSeleccionado == null
                          ? 'Seleccionar Vehículo'
                          : 'Vehículo: ${vehiculoSeleccionado!.patente}',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    ref
                        .read(vehiculoProvider.notifier)
                        .setVehiculo(vehiculoSeleccionado!);
                    context.push('/ReservationScreen');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 68, 66, 66),
                          width: 2),
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
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  context.push('/HomeUser');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
