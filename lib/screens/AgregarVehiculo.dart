import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/core/Entities/Usuario.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Entities/usuarioVehiculos.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AgregarVehiculos extends ConsumerStatefulWidget {
  static final String name = "AgregarVehiculos";
  const AgregarVehiculos({super.key});

  @override
  _TestAgregarVehiculos createState() => _TestAgregarVehiculos();
}

class _TestAgregarVehiculos extends ConsumerState<AgregarVehiculos> {
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _patenteController = TextEditingController();
  final TextEditingController _color = TextEditingController();
  final FocusNode _patenteFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _marcaController.addListener(_validateForm);
    _modeloController.addListener(_validateForm);
    _patenteController.addListener(_validateForm);

    _patenteFocusNode.addListener(() {
      if (!_patenteFocusNode.hasFocus) {
        final errorMessage = _validatePatente(_patenteController.text);
        if (errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _marcaController.text.isNotEmpty &&
          _modeloController.text.isNotEmpty &&
          _patenteController.text.isNotEmpty &&
          _validatePatente(_patenteController.text) == null;
    });
  }

  String? _validatePatente(String value) {
    final regex1 = RegExp(r'^[A-Za-z]{3}\d{3}$');
    final regex2 = RegExp(r'^[A-Za-z]{2}\d{3}[A-Za-z]{2}$');

    if (value.isEmpty) {
      return 'La patente no puede estar vacía';
    } else if (!regex1.hasMatch(value) && !regex2.hasMatch(value)) {
      return 'Patente no válida. Debe ser 3 letras y 3 números o 2 letras, 3 números y 2 letras.';
    }
    return null;
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _patenteController.dispose();
    _patenteFocusNode.dispose();
    _color.dispose();
    super.dispose();
  }

  Future<void> guardarAuto(bool statusFormulario, Usuario usuario) async {
    if (statusFormulario) {
      try {
        final nuevoVehiculo = Vehiculo(
          marca: _marcaController.text,
          modelo: _modeloController.text,
          patente: _patenteController.text,
          color: _color.text,
          userId: usuario.id,
        );

        final nuevaRelacionUserVehiculo = usuarioVehiculo(
            idUsuario: usuario.id, idVehiculo: nuevoVehiculo.patente);

        await db.collection('Vehiculos').doc().set(nuevoVehiculo.toFireStore());

        await db
            .collection('UsuariosVehiculos')
            .doc()
            .set(nuevaRelacionUserVehiculo.toFirestore());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vehículo agregado'),
            duration: Duration(seconds: 3),
          ),
        );

        context.goNamed(vehiculosUsuario.name);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioState = ref.watch(usuarioProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: const Text('Complete los datos del vehiculo'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/car_logo.png',
                  height: 100,
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _marcaController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Marca',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _modeloController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Modelo',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _patenteController,
                        focusNode: _patenteFocusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Patente',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _color,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Color',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isButtonEnabled
                            ? () => guardarAuto(
                                _formKey.currentState!.validate(), usuarioState)
                            : null,
                        child: const Center(
                          child: Text('Confirmar'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        floatingActionButton: BackButtonWidget(
          onPressed: () {
            context.goNamed('ReservationSelectVehicule');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
