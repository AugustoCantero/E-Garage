import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
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

  @override
  void initState() {
    super.initState();
    final vehiculo = ref.read(vehiculoProvider);
    patenteController = TextEditingController(text: vehiculo.patente);
    modeloController = TextEditingController(text: vehiculo.modelo);
    marcaController = TextEditingController(text: vehiculo.marca);
  }

  @override
  void dispose() {
    // Asegúrate de liberar los controladores
    patenteController.dispose();
    modeloController.dispose();
    marcaController.dispose();
    super.dispose();
  }

  Future<void> _eliminarAuto() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // Aquí obtenemos el valor del TextEditingController
    String patente =
        patenteController.text; // Obtenemos el texto de patenteController

    await db
        .collection('Vehiculos')
        .where('patente', isEqualTo: patente) // Usamos el valor de patente
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.first.reference.delete();
      } else {
        print('No se encontró ningún vehículo con esa patente.');
      }
    });

    // También debes asegurarte de usar el texto correcto aquí
    QuerySnapshot querySnap1 = await db
        .collection('UsuariosVehiculos')
        .where('idVehiculo', isEqualTo: patente) // Y aquí también
        .limit(1)
        .get();

    if (querySnap1.docs.isNotEmpty) {
      DocumentSnapshot userVehiculoDoc = querySnap1.docs.first;
      await userVehiculoDoc.reference.delete();
    } else {
      print('No se encontró ningún usuario asociado al vehículo.');
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
                  await _eliminarAuto(); // Llamar al método sin pasarle parámetros
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
