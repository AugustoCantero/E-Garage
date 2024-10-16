import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/lote.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_application_1/domain/CapacidadTotal.dart';
import 'package:flutter_application_1/domain/Reserva.dart';
import 'package:flutter_application_1/domain/usuarioVehiculo.dart';
import 'package:flutter_application_1/domain/utils.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CalendarDemo extends ConsumerStatefulWidget {
  static final String name = 'CalendarDemo';
  const CalendarDemo({super.key});

  @override
  _CalendarDemoState createState() => _CalendarDemoState();
}

class _CalendarDemoState extends ConsumerState<CalendarDemo> {
  int? fechaSeleccionada;
  int? _selectedLote;
  List<Reserva> reservasDelDia = [];

  @override
  void initState() {
    super.initState();
    fechaSeleccionada = DateTime.now().day;
    _fetchReservas();
  }

  Future<void> _fetchReservas() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('Reservas').get();

    //el metodo map itera en los resultados del query, devolviendo por cada vuelta una Reserva
    List<Reserva> reservas = snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc);
    }).toList();

    setState(() {
      reservasDelDia = reservas;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioState = ref.watch(usuarioProvider);
    final vehiculoState = ref.watch(vehiculoProvider);
    final db = FirebaseFirestore.instance;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Calendario de Reserva'),
        ),
        body: Column(
          children: [
            CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(kToday.year, kToday.month - 3, kToday.day),
              lastDate: DateTime(kToday.year, kToday.month + 3, kToday.day),
              onDateChanged: (DateTime value) {
                setState(() {
                  fechaSeleccionada = value.day;
                });
                // _filtrarReservasPorFecha(fechaSeleccionada!);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8.0, // Espacio horizontal entre los elementos
                  runSpacing: 8.0, // Espacio vertical entre las filas
                  children: List.generate(10, (nroLote) {
                    bool isSelected = reservasDelDia
                            .any((reserva) => reserva.lote == nroLote) ||
                        _selectedLote == nroLote;

                    return SizedBox(
                      height: 50,
                      child: Lote(
                          id: nroLote,
                          isSelected: isSelected,
                          onSelected: () {
                            // _onLoteSelected(nroLote);
                            setState(() {
                              // el state porque le cambia el color
                              _selectedLote = nroLote;
                            });
                            print(_selectedLote);
                            print(reservasDelDia);
                          }),
                    );
                  }),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      context.goNamed(Home.name);
                    },
                    child: const Text('Volver')),
                const Padding(
                    padding: EdgeInsets.fromLTRB(60.0, 0.0, 0.0, 60.0)),
                ElevatedButton(
                  onPressed: () async {
                    if (fechaSeleccionada != null && _selectedLote != null) {
                      final relacionUsuariVehiculo = usuarioVehiculo(
                          idUsuario: usuarioState.id,
                          idVehiculo: vehiculoState.patente);

                      final reserva = Reserva(
                          fecha: fechaSeleccionada!,
                          lote: _selectedLote!,
                          elvehiculo: vehiculoState);

                      DocumentSnapshot cantLugares = await db
                          .collection('Lugares')
                          .doc('68PCmlqAUB3JJdDFBodl')
                          .get();

                      int cantActualLugares = cantLugares['cantTotalLugares'];
                      cantActualLugares--;
                      final Capacidad =
                          CapacidadTotal(cantTotalLugares: cantActualLugares);

                      await db
                          .collection('Vehiculos')
                          .doc()
                          .set(vehiculoState.toFireStore());

                      await db
                          .collection('UsuariosVehiculos')
                          .doc()
                          .set(relacionUsuariVehiculo.toFirestore());

                      await db
                          .collection('Reservas')
                          .doc()
                          .set(reserva.toFirestore());

                      await db
                          .collection('Lugares')
                          .doc('68PCmlqAUB3JJdDFBodl')
                          .set(Capacidad.toFirestore());

                      context.goNamed(Home.name);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Seleccione una fecha y un lote')),
                      );
                    }
                  },
                  child: const Text('Reservar'),
                ),
              ],
            ),
          ],
        ));
  }
}
