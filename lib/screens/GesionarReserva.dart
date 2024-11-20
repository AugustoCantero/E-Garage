import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Test/test_modif_reserva.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/core/router/app_router.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:math';

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

    Future<String> _recuperarTokenAdmin() async {
      Reserva ReservaCargada2 = ref.watch(reservaEnGarageProvider);

      QuerySnapshot documento = await db
          .collection('adminGarage')
          .where('idGarage', isEqualTo: ReservaCargada2.garajeId)
          .get();

      print(documento);

      if (documento.docs.isEmpty) {
        print('No trajo nada');
      } else {
        print('Ahora trajo');
      }

      DocumentSnapshot docReserva = documento.docs.first;
      print(docReserva.id);
      String idUserAdmin = docReserva['idAdmin'];

      DocumentSnapshot documentoAdmin =
          await db.collection('duenos').doc(idUserAdmin).get();

      String tokenAdmin = documentoAdmin['token'];

      return tokenAdmin;
    }

    Future<void> _enviarNotificaciones() async {
      String tokenAdmin = await _recuperarTokenAdmin();
      Reserva ReservaCargada = ref.watch(reservaEnGarageProvider);
      final usuario = ref.read(usuarioProvider);

      try {
        http.post(Uri.parse('https://backnoti.onrender.com'),
            headers: {"Content-type": "application/json"},
            body: jsonEncode({
              //aca en vez del token hardcode iria la variable token de arriba
              "token": [usuario.token, tokenAdmin],
              "data": {
                "title": "Reserva Cancelada",
                "body":
                    "La reserva para la Fecha: ${ReservaCargada.startTime}\n"
                        "Monto: ${ReservaCargada.monto}\n"
                        "fue cancelada"
              }
            }));
      } catch (e) {}
    }

    String _formatDuracion(double duracion) {
      final int horas = duracion.floor();
      final int minutos = ((duracion - horas) * 60).round();
      return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 50),
          Center(
            child: Text(
              'DATOS DE LA RESERVA',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          Center(
              child: Text(
            'Vehiculo: ${ReservaCargada.elvehiculo.marca} ${ReservaCargada.elvehiculo.modelo}\n'
            'patente: ${ReservaCargada.elvehiculo.patente} \n'
            // 'Garage: ${nombreGarage}\n'
            //'Direccion: ${direccionGarage}\n'
            'Fecha inicio: ${DateFormat('dd-MM-yyyy HH:mm').format(ReservaCargada.startTime)}\n'
            'Fecha fin: ${DateFormat('dd-MM-yyyy HH:mm').format(ReservaCargada.endTime)}\n'
            'Duración de estadía: ${_formatDuracion(ReservaCargada.duracionEstadia)} \n'
            'Costo estadia: ${ReservaCargada.monto}',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white),
            //style: const TextStyle(color: Colors.white),
          )),
          const SizedBox(height: 30),
          /*Center(
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(ModificacionReservationScreen.name);
              }, // Aquí puedes agregar la lógica para modificar la reserva
              child: const Text("Modificar reserva"),
            ),
          ),
          const SizedBox(height: 20),*/
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _cancelarReserva();
                await _enviarNotificaciones();
                context.goNamed(LoginUsuario.name);
              }, // Aquí llamas a la función _cancelarReserva
              child: const Text("Cancelar Reserva"),
            ),
          ),
        ],
      ),
      floatingActionButton: BackButtonWidget(
        onPressed: () {
          context.goNamed(LoginUsuario.name);
        },
      ),
    );
  }
}
