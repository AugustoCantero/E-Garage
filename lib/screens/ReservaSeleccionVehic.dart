import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonBot.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/screens/VehiculosUsuario.dart';
import 'package:go_router/go_router.dart';

class GestionVehiculosScreen extends StatefulWidget {
  static const String name = 'ReservationSelectVehicule';

  const GestionVehiculosScreen({super.key});

  @override
  State<GestionVehiculosScreen> createState() => _GestionVehiculosScreenState();
}

class _GestionVehiculosScreenState extends State<GestionVehiculosScreen> {
  Vehiculo? vehiculoSeleccionado;

  @override
  Widget build(BuildContext context) {
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
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const vehiculosUsuario()),
                    );

                    if (resultado != null && resultado is Vehiculo) {
                      setState(() {
                        vehiculoSeleccionado = resultado;
                      });
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
                          ? 'Seleccionar Vehiculo'
                          : 'Vehículo: ${vehiculoSeleccionado!.patente}',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    context.goNamed('ReservationScreen');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
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
          const BotLogoButton(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(
                  16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.black),
                onPressed: () {
                  context.go('/HomeUser');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
