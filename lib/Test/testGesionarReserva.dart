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

    String idUserAdmin = docReserva['idUserAdmin'];

    DocumentSnapshot documentoAdmin =
        await db.collection('users').doc(idUserAdmin).get();

    String tokenAdmin = documentoAdmin['token'];

    return tokenAdmin;
    }

    Future<void> _enviarNotificaciones() async {
      String tokenAdmin = await _recuperarTokenAdmin();

      Reserva ReservaCargada = ref.watch(reservaEnGarageProvider);
      final usuario = ref.read(usuarioProvider);
//////////////////////////////////borrar despues///////////////////////////////////////////////
      print('**************ACA VIENE EL TOKEN DEL ADMIN**********************');
      print(tokenAdmin);
      print('**************   FIN    **********************');

///////////////////////////////Prueba Token////////////////////////////////
      try {
        http.post(Uri.parse('https://backnoti.onrender.com'),
            headers: {"Content-type": "application/json"},
            body: jsonEncode({
              //aca en vez del token hardcode iria la variable token de arriba
              "token": [usuario.token, tokenAdmin],
              "data": {
                "title": "Reserva Cancelada",
                "body": "La reserva para la Fecha: ${ReservaCargada.startTime}\n"
                    "Monto: ${ReservaCargada.monto}\n"
                    "fue cancelada"
              }
            }));
      } catch (e) {}

    }

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text('OPCIONES DE RESERVA'),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(ModificacionReservationScreen.name);
              }, // Aquí puedes agregar la lógica para modificar la reserva
              child: const Text("Modificar reserva"),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                await _cancelarReserva();
                await  _enviarNotificaciones();
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
