// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/ComentarioReserva.dart';
import 'package:flutter_application_1/core/Providers/garage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ComentariosGarage extends ConsumerStatefulWidget {
  static final String name = 'ComentariosGarage';
  const ComentariosGarage({super.key});

  @override
  _ComentariosGarageState createState() => _ComentariosGarageState();
}

class _ComentariosGarageState extends ConsumerState<ComentariosGarage> {
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
                    'COMENTARIOS',
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
          Positioned(
            bottom: 20,
            left: 20,
            child: BackButtonWidget(
              onPressed: () {
                context.push('/mapa');
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ListView extends ConsumerWidget {
  const _ListView();

  Future<List<Comentarioreserva>> _fetchReservas(WidgetRef ref) async {
    final elGarage = ref.watch(garageProvider);
    FirebaseFirestore firestore = await FirebaseFirestore.instance;

    print(
        '*******************************************************************');
    print(elGarage.id);

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('ComentarioReserva')
        .where('idGarage', isEqualTo: elGarage.id)
        .get();

    return snapshot.docs.map((doc) {
      return Comentarioreserva.fromFirestore(doc);
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Comentarioreserva>>(
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
              child: Text('No hay Comentarios.',
                  style: TextStyle(color: Colors.white)));
        } else {
          List<Comentarioreserva> listaComentarios = snapshot.data!;
          return ListView.builder(
            itemCount: listaComentarios.length,
            itemBuilder: (context, index) {
              Comentarioreserva elComentarioreserva = listaComentarios[index];
              return Card(
                color: Colors.grey[800],
                child: ListTile(
                  title: Text(
                    'Fecha inicio: ${elComentarioreserva.comentario}\n',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Marca: ${elComentarioreserva.comentario}, Modelo: ${elComentarioreserva.comentario}, Patente: ${elComentarioreserva.comentario}',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
