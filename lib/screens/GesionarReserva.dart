// ignore_for_file: camel_case_types, non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class editarReserva extends ConsumerWidget {
  static final String name = 'editarReserva';

  editarReserva({super.key});

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Reserva ReservaCargada = ref.watch(reservaEnGarageProvider);

    

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

    Future<void> _cancelarReserva() async {
      final confirmacion = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('¿Quieres cancelar tu reserva?'),
            content: const Text('Esta acción no se puede deshacer.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Sí'),
                onPressed: () => Navigator.of(context).pop(true), 
              ),
              TextButton(
                child: const Text('No'),
                onPressed: () => Navigator.of(context).pop(false), 
              ),
            ],
          );
        },
      );
      if(confirmacion == true) {
        await db.collection('Reservas').doc(ReservaCargada.id).delete();
        await _enviarNotificaciones();
        context.push('/reservasUsuario');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reserva eliminada correctamente.'))
        );
      }
      
    }

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
        leading: Builder(
          builder: (context){
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
                // await _enviarNotificaciones();
                // context.goNamed(LoginUsuario.name);
              },
              style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(191, 152, 12, 2),
                    ),
              child: const Text("Cancelar Reserva",
              style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
      floatingActionButton: BackButtonWidget(
        onPressed: () {
          context.push('/reservasUsuario');
        },
      ),
    );
  }
}
