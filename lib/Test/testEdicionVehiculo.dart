import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      // Obtener los valores del controlador
      String patente = patenteController.text;
      String modelo = modeloController.text;
      String marca = marcaController.text;
      String color = colorController.text;

      // Buscar el documento que tiene el campo `patente` igual a `vehiculo.patente`
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

        // Actualizar el estado en el provider
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
    FirebaseFirestore db = FirebaseFirestore.instance;
    String patente = patenteController.text;

    // Eliminar el vehículo de Firestore
    await db.collection('Vehiculos').doc(patente).delete();

    // También eliminar la relación en UsuariosVehiculos
    QuerySnapshot querySnap1 = await db
        .collection('UsuariosVehiculos')
        .where('idVehiculo', isEqualTo: patente)
        .limit(1)
        .get();

    if (querySnap1.docs.isNotEmpty) {
      DocumentSnapshot userVehiculoDoc = querySnap1.docs.first;
      await userVehiculoDoc.reference.delete();
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
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/car_logo.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'EDITAR VEHICULO',
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
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _guardarCambios(
                      vehiculo); // Guardar cambios en Firestore y el provider
                  context.goNamed(vehiculosUsuario.name);
                },
                child: const Text("Guardar cambios"),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _eliminarAuto(); // Eliminar el vehículo
                  context.goNamed(vehiculosUsuario.name);
                },
                child: const Text("Eliminar auto"),
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  context.goNamed(vehiculosUsuario.name);
                },
              ),
            ),
          ],
        ),
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
