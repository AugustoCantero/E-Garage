import 'package:flutter/material.dart';

class DatosCuenta extends StatefulWidget {
  static const String name = "DatosCuenta";
  const DatosCuenta({super.key});

  @override
  State<DatosCuenta> createState() => _DatosCuentaState();
}

class _DatosCuentaState extends State<DatosCuenta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Editar datos"),
      ),
      // body: box
    );
  }
}
