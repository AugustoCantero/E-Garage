import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReservasUsuario extends ConsumerStatefulWidget {
  static const String nombre = 'reservasUsuario';
  const ReservasUsuario({super.key});

  @override
  ReservasUsuarioState createState() => ReservasUsuarioState();
}

class ReservasUsuarioState extends ConsumerState<ReservasUsuario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Reservas en sistema'),
        ),
        leading: ButtonBar(),
      ),
      body: const _ListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(login_exitoso_home_user.name);
        },
        child: const Icon(Icons.arrow_circle_right_outlined),
      ),
    );
  }
}

class _ListView extends ConsumerWidget {
  const _ListView({super.key});

  Future<List<Reserva>> _fetchReservas(WidgetRef ref) async {
    final usuarioState = ref.watch(usuarioProvider);
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('Reservas')
        .where('elvehiculo.idDuenio', isEqualTo: usuarioState.id)
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
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay reservas.'));
        } else {
          List<Reserva> listaReservas = snapshot.data!;
          return ListView.builder(
            itemCount: listaReservas.length,
            itemBuilder: (context, index) {
              Reserva reserva = listaReservas[index];
              return Card(
                child: ListTile(
                  title: Text('Lote: ${reserva.startTime}'),
                  subtitle: Text(
                      'Fecha fin: ${reserva.endTime}, Modelo: ${reserva.elvehiculo.modelo}, patente: ${reserva.elvehiculo.marca}'),
                ),
              );
            },
          );
        }
      },
    );
  }
}
