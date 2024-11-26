// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReservasUsuario extends ConsumerStatefulWidget {
  const ReservasUsuario({super.key});

  @override
  _ReservasUsuarioState createState() => _ReservasUsuarioState();
}

class _ReservasUsuarioState extends ConsumerState<ReservasUsuario> {
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
                const Center(
                  child: Text(
                    'GESTION de RESERVAS',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Expanded(
                  child: _ListView(),
                ),
              ],
            ),
          ),
           BackButtonWidget(
            onPressed: () {
                    context.push('/HomeUser');
                  }
          ),
        ],
      ),
    );
  }
}

class _ListView extends ConsumerWidget {
  const _ListView();

  Future<List<Reserva>> _fetchReservas(WidgetRef ref) async {
    final usuarioState = ref.watch(usuarioProvider);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('Reservas')
        .where('elvehiculo.idDuenio', isEqualTo: usuarioState.id)
        .where('seRetiro', isEqualTo: false)
        .get();

    return snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Reserva>>(
      future: _fetchReservas(ref),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No hay reservas.',
                  style: TextStyle(color: Colors.white)));
        } else {
          List<Reserva> listaReservas = snapshot.data!;
          return ListView.builder(
            itemCount: listaReservas.length,
            itemBuilder: (context, index) {
              Reserva reserva = listaReservas[index];
              return Card(
                color: Colors.grey[800],
                child: ListTile(
                  title: Text(
                    'Fecha inicio: ${DateFormat('dd-MM-yyyy HH:mm').format(reserva.startTime)}\n'
                    'Fecha fin: ${DateFormat('dd-MM-yyyy HH:mm').format(reserva.endTime)}',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Marca: ${reserva.elvehiculo.marca}, Modelo: ${reserva.elvehiculo.modelo}, Patente: ${reserva.elvehiculo.patente}',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    ref
                        .read(reservaEnGarageProvider.notifier)
                        .setReserva(listaReservas[index]);
                    context.push('/editarReserva');
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
