// ignore_for_file: camel_case_types, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ComentarReserva extends ConsumerWidget {
  static final String name = 'ComentarReserva';

  ComentarReserva({super.key});

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Reserva ReservaCargada = ref.watch(reservaEnGarageProvider);

    String _formatDuracion(double duracion) {
      final int horas = duracion.floor();
      final int minutos = ((duracion - horas) * 60).round();
      return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: const MenuUsuario(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/car_logo.png',
            height: 100,
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'DATOS DE LA RESERVA',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
          ),
          const SizedBox(height: 20),
          Center(
              child: Text(
            'Vehiculo: ${ReservaCargada.elvehiculo.marca} ${ReservaCargada.elvehiculo.modelo}\n'
            'patente: ${ReservaCargada.elvehiculo.patente} \n'
            'Fecha inicio: ${DateFormat('dd-MM-yyyy HH:mm').format(ReservaCargada.startTime)}\n'
            'Fecha fin: ${DateFormat('dd-MM-yyyy HH:mm').format(ReservaCargada.endTime)}\n'
            'Duración de estadía: ${_formatDuracion(ReservaCargada.duracionEstadia)} \n'
            'Costo estadia: ${ReservaCargada.monto}',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                //await _cancelarReserva();
                // await _enviarNotificaciones();
                // context.goNamed(LoginUsuario.name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(191, 152, 12, 2),
              ),
              child: const Text(
                "Comentar Reserva",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BackButtonWidget(
        onPressed: () {
          context.push('/HistorialReservasUsuario');
        },
      ),
    );
  }
}
