// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EditarDatosAuto extends ConsumerStatefulWidget {
  const EditarDatosAuto({super.key});
  static const String name = "EditarDatosAuto";

  @override
  EditarDatosAutoState createState() => EditarDatosAutoState();
}

class EditarDatosAutoState extends ConsumerState<EditarDatosAuto> {
  late TextEditingController patenteController;
  late TextEditingController modeloController;
  late TextEditingController marcaController;
  late TextEditingController colorController;

  @override
  void initState() {
    super.initState();
    final vehiculo = ref.read(vehiculoProvider);
    patenteController = TextEditingController(text: vehiculo.patente);
    modeloController = TextEditingController(text: vehiculo.modelo);
    marcaController = TextEditingController(text: vehiculo.marca);
    colorController = TextEditingController(text: vehiculo.color);
  }

  @override
  void dispose() {
    patenteController.dispose();
    modeloController.dispose();
    marcaController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios(Vehiculo vehiculo) async {
    final db = FirebaseFirestore.instance;
    try {
      String patente = patenteController.text;
      String modelo = modeloController.text;
      String marca = marcaController.text;
      String color = colorController.text;

      QuerySnapshot querySnap = await db
          .collection('Vehiculos')
          .where('patente', isEqualTo: vehiculo.patente)
          .get();

      if (querySnap.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnap.docs.first;
        await doc.reference.update({
          'modelo': modelo,
          'marca': marca,
          'patente': patente,
          'color': color,
        });

        final updatedVehiculo = Vehiculo(
          patente: patente,
          marca: marca,
          modelo: modelo,
          color: color,
          userId: vehiculo.userId,
        );
        ref.read(vehiculoProvider.notifier).setVehiculo(updatedVehiculo);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Datos guardados exitosamente.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Documento no encontrado.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar cambios: $e')),
      );
    }
  }

  Future<void> _eliminarAuto() async {
  final db = FirebaseFirestore.instance;
  String patente = patenteController.text;

  final confirmacion = await showDialog<bool>(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿Quieres eliminar tu vehículo?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Sí'),
            onPressed: () => Navigator.of(context).pop(true), 
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () => Navigator.of(context).pop(false), 
          ),
        ],
      );
    },
    );
if(confirmacion == true) {
  try {
    QuerySnapshot vehiculosSnap = await db
        .collection('Vehiculos')
        .where('patente', isEqualTo: patente)
        .limit(1)
        .get();

    if (vehiculosSnap.docs.isNotEmpty) {
      await vehiculosSnap.docs.first.reference.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehículo eliminado correctamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vehículo no encontrado.')),
      );
      return;
    }

    QuerySnapshot userVehiculosSnap = await db
        .collection('UsuariosVehiculos')
        .where('idVehiculo', isEqualTo: patente)
        .limit(1)
        .get();

    if (userVehiculosSnap.docs.isNotEmpty) {
      await userVehiculosSnap.docs.first.reference.delete();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró relación usuario-vehículo.'),
        ),
      );
    }

    ref.read(vehiculoProvider.notifier).clearVehiculo();
    context.push('/vehiculosUsuario');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al eliminar vehículo: $e')),
    );
  }
  }
}

  @override
  Widget build(BuildContext context) {
    final vehiculo = ref.watch(vehiculoProvider);

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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    'assets/images/car_logo.png',
                    height: 100,
                  ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'EDITAR VEHÍCULO',
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            _buildEditableField(context, 'Patente', patenteController),
            const SizedBox(height: 10),
            _buildEditableField(context, 'Modelo', modeloController),
            const SizedBox(height: 10),
            _buildEditableField(context, 'Marca', marcaController),
            const SizedBox(height: 10),
            _buildEditableField(context, 'Color', colorController),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _guardarCambios(vehiculo); 
                  context.push('/vehiculosUsuario');
                },
                child: const Text("Guardar cambios"),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _eliminarAuto();
                },
                style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(191, 152, 12, 2),
                    ),
                child: const Text("Eliminar vehículo",
                style: TextStyle(color: Colors.white),),
              ),
            ),
                ],
              ),
            ),
          ),
            Positioned(
            bottom: 20,
            left: 20,
            child: BackButtonWidget(
              onPressed: () {
                context.push('/vehiculosUsuario');
              },
            ),
          ),
          ],
        ),
      );
  }

  Widget _buildEditableField(
      BuildContext context, String label, TextEditingController controller,
      {bool obscureText = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }
}
