import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/router/app_router.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class editarReserva extends ConsumerWidget {
  static final String name = 'editarReserva';

  editarReserva({super.key});

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Reserva ReservaCargada = ref.watch(reservaEnGarageProvider);

    Future<void> _cancelarReserva() async {
      await db.collection('Reservas').doc(ReservaCargada.id).delete();
    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text('MODIFICAR RESERVA'),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _cancelarReserva();
                context.goNamed(LoginUsuario.name);
              }, // Aquí llamas a la función _cancelarReserva
              child: const Text("Cancelar Reserva"),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed:
                  () {}, // Aquí puedes agregar la lógica para modificar la reserva
              child: const Text("Modificar reserva"),
            ),
          ),
        ],
      ),
    );
  }
}
