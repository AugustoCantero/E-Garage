import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/dialog_box.dart';

class BuscadorAuto extends StatefulWidget {
  static const String name = 'BuscadorAuto';
  const BuscadorAuto({super.key});

  @override
  State<BuscadorAuto> createState() => _BuscadorAutoState();
}

class _BuscadorAutoState extends State<BuscadorAuto> {
  final TextEditingController _patenteController = TextEditingController();
  final FocusNode _patenteFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Añade un listener al controlador para validar el formulario cada vez que cambia el texto
    _patenteController.addListener(_validateForm);
  }

  // Valida si el formulario es válido y habilita o deshabilita el botón de buscar
  void _validateForm() {
    setState(() {
      _isButtonEnabled = _patenteController.text.isNotEmpty &&
          _validatePatente(_patenteController.text) == null;
    });
  }

  // Valida la patente según los formatos permitidos
  String? _validatePatente(String? value) {
    final regex1 = RegExp(r'^[A-Za-z]{3}\d{3}$'); // AAA123
    final regex2 = RegExp(r'^[A-Za-z]{2}\d{3}[A-Za-z]{2}$'); // AA123AA

    if (value == null || value.isEmpty) {
      return 'La patente no puede estar vacía';
    } else if (!regex1.hasMatch(value) && !regex2.hasMatch(value)) {
      return 'Patente no válida. Debe ser 3 letras y 3 números o 2 letras, 3 números y 2 letras.';
    }
    return null;
  }

  // Muestra un diálogo con el mensaje proporcionado
  void showBox(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return BoxDialog(
          onCancel: onCancel,
          message: message,
        );
      },
    );
  }

  // Función de cancelación para cerrar el diálogo
  void onCancel() {
    Navigator.of(context).pop();
  }

  // Busca el auto en la base de datos y muestra un mensaje con el resultado
  Future<void> buscarAuto(String patenteBuscado) async {
    final db = FirebaseFirestore.instance;

    // Muestra un mensaje de cargando
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Buscando auto...'),
        duration: Duration(seconds: 1),
      ),
    );

    // Busca el vehículo por patente
    QuerySnapshot querySnap = await db
        .collection('Reservas')
        .where('elvehiculo.patente', isEqualTo: patenteBuscado)
        .get();

    if (querySnap.docs.isNotEmpty) {
      DocumentSnapshot reserDoc = querySnap.docs.first;
      int puesto = reserDoc['lote'];

      // Muestra un mensaje indicando el puesto del auto
      showBox('Su auto está en el puesto $puesto');
    } else {
      // Muestra un mensaje indicando que no se encontró el vehículo
      showBox('No se encontró ningún auto con esa patente');
    }
  }

  @override
  void dispose() {
    _patenteController.dispose();
    _patenteFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Buscar auto'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Campo de texto para la patente del vehículo
                      TextFormField(
                        controller: _patenteController,
                        focusNode: _patenteFocusNode,
                        decoration: const InputDecoration(
                          labelText: 'Patente',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validatePatente,
                      ),

                      const SizedBox(height: 50),

                      // Botón para buscar el vehículo
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isButtonEnabled
                              ? () async {
                                  // Si el formulario es válido, busca el vehículo
                                  if (_formKey.currentState!.validate()) {
                                    await buscarAuto(_patenteController.text);
                                  }
                                }
                              : () {
                                  // Si el formulario no es válido, muestra un mensaje de error
                                  if (!_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Por favor, corrige los errores antes de continuar.'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                          child: const Text(
                            'Buscar',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
