import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:go_router/go_router.dart';

class todasLasReservas extends StatelessWidget {
  static final String nombre = 'reservasEfectuadas';

  const todasLasReservas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('Reservas en sistema'),
        ),
        leading: OverflowBar(),
      ),
      body: const _listView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(LoginUsuario.name);
        },
        child: const Icon(Icons.arrow_circle_right_outlined),
      ),
    );
  }
}

class _listView extends StatefulWidget {
  const _listView();

  @override
  State<_listView> createState() => _listViewState();
}

class _listViewState extends State<_listView> {
  List<Reserva> listaReservas = [];

  @override
  void initState() {
    super.initState();
    _fetchReservas();
  }

  Future<void> _fetchReservas() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('Reservas').get();

    //el metodo map itera en los resultados del query, devolviendo por cada vuelta una Reserva
    List<Reserva> reservasDeFirestore = snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc);
    }).toList();

    setState(() {
      listaReservas = reservasDeFirestore;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listaReservas.length,
      itemBuilder: (context, index) {
        Reserva reserva = listaReservas[index];
        return Card(
          child: ListTile(
            title: Text('lote: ${reserva.elvehiculo.patente}'),
            subtitle: Text(
                'Patente: ${reserva.startTime}, Modelo: ${reserva.endTime}'),
            // le pasa como parametro la vista que se busca.*/
          ),
        );
      },
    );
  }
}
