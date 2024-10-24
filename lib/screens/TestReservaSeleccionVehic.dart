import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Usuario.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_application_1/screens/testReserva.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReservationSelectVehicule extends StatefulWidget {
  static const String name = 'ReservationSelectVehicule';

  @override
  _ReservationSelectVehicule createState() => _ReservationSelectVehicule();
}

class _ReservationSelectVehicule extends State<ReservationSelectVehicule> {
  String? selectedVehicle; // Variable para almacenar el vehículo seleccionado
  Vehiculo? vehiculoSeleccionado;

  void _showVehiclePicker(BuildContext context, Usuario usuarioLogueado) {
    final db = FirebaseFirestore.instance;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300, // Definir altura de la ventana emergente
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: db
                .collection('Vehiculos')
                .where('userId', isEqualTo: usuarioLogueado.id)
                .get(), // Obtener datos de Firestore
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar vehículos'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No se encontraron vehículos'));
              }

              // Mostrar la lista de vehículos
              List<DocumentSnapshot<Map<String, dynamic>>> vehicles =
                  snapshot.data!.docs;

              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (BuildContext context, int index) {
                  // Crear el objeto Vehiculo usando fromFirestore
                  final vehiculo =
                      Vehiculo.fromFirestore(vehicles[index], null);

                  return ListTile(
                    title: Text(vehiculo.patente ??
                        'Sin patente'), // Usar el campo marca
                    subtitle: Text(vehiculo.modelo ?? 'Sin Modelo'),
                    trailing: Text(vehiculo.marca ?? 'Sin Marca'),
                    // Mostrar modelo
                    onTap: () {
                      setState(() {
                        selectedVehicle = vehiculo
                            .marca; // Guardar el nombre del vehículo seleccionado
                        vehiculoSeleccionado = vehiculo;
                      });
                      Navigator.pop(context); // Cerrar la ventana modal
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
    return Scaffold(
      appBar: AppBar(title: Text('Reservar Garage')),
      body: Consumer(
        //para usar un consumer sin tener el consumerWidget!!!!!!!
        builder: (context, ref, child) {
          final usuarioState = ref.watch(usuarioProvider);

          // Obtener el estado del usuario

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _showVehiclePicker(context, usuarioState),
                  child: Text(selectedVehicle == null
                      ? 'Seleccionar vehículo'
                      : 'Vehículo: $selectedVehicle'), // Mostrar vehículo seleccionado
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    if (vehiculoSeleccionado != null) {
                      // Llama a setVehiculo pasando el objeto vehiculoSeleccionado completo
                      ref
                          .read(vehiculoProvider.notifier)
                          .setVehiculo(vehiculoSeleccionado!);
                      print(
                          'Vehículo seleccionado: ${vehiculoSeleccionado!.marca} ');
                      context.goNamed(ReservationScreen.name);
                    } else {
                      print(
                          'Por favor, selecciona un vehículo antes de continuar');
                    }
                  },
                  child: Text('Continuar'),
                )
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(login_exitoso_home_user.name);
        },
      ),
    );
  }
}
