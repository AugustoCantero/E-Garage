import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/Test_agregar_vehiculos.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class vehiculosUsuario extends ConsumerStatefulWidget {
  static const String name = 'reservasUsuario';
  const vehiculosUsuario({super.key});

  @override
  vehiculosUsuarioState createState() => vehiculosUsuarioState();
}

//hereda
class vehiculosUsuarioState extends ConsumerState<vehiculosUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('SUS VEHICULOS'),
        ),
        leading: ButtonBar(),
      ),
      body: const _ListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(login_exitoso_home_user.name);
        },
        child: const Icon(Icons.arrow_circle_right_outlined),
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

  Future<void> _eliminarAuto(String patente) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('Vehiculos')
        .where('patente', isEqualTo: patente)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.first.reference.delete();
      } else {
        print('No se encontró ningún vehículo con esa patente.');
      }
    });

    QuerySnapshot querySnap1 = await db
        .collection('UsuariosVehiculos')
        .where('idVehiculo', isEqualTo: patente)
        .limit(1)
        .get();

    DocumentSnapshot userVehiculoDoc = querySnap1.docs.first;

    await userVehiculoDoc.reference.delete();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      // Aquí envolvemos todo en un SingleChildScrollView
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
                      child: Text('No tiene vehiculos cargados.'));
                } else {
                  List<Vehiculo> listaReservas = snapshot.data!;
                  return Column(
                    children: listaReservas.map((elVehiculo) {
                      return Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Espacia los elementos
                          children: [
                            Expanded(
                              // Permite que el ListTile ocupe el espacio disponible
                              child: ListTile(
                                title: Text('Patente: ${elVehiculo.patente}'),
                                subtitle: Text(
                                  "Modelo: ${elVehiculo.modelo}, Marca: ${elVehiculo.marca}, Color: ${elVehiculo.color}",
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (elVehiculo.patente != null) {
                                  _eliminarAuto(elVehiculo
                                      .patente!); // Usa el operador de null assertion "!"
                                } else {
                                  print(
                                      'La patente es nula, no se puede eliminar el vehículo.');
                                }
                              },
                              icon:
                                  const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          Container(
            child: ElevatedButton(
                onPressed: () {
                  context.goNamed(TestAgregarVehiculos.name);
                },
                child: Text("Agregar vehiculo")),
          )
        ],
      ),
    );
  }
}
