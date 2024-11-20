// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/garage_provider.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends ConsumerStatefulWidget {
  static const String name = "ReservationScreen";

  const ReservationScreen({super.key});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class Garage {
  final String idGarage = 'PruebaIdGarage';
  final List<Reserva> reservations; 
  final int totalSpaces; 

  Garage(
      {this.totalSpaces = 3,
      List<Reserva>?
          reservasIngresadas}) 
      : reservations = reservasIngresadas ?? [];

  bool isAvailable(DateTime start, DateTime end) {
    int occupiedSpaces = 0;

    for (var reservation in reservations) {
      if ((start.isBefore(reservation.endTime) &&
          end.isAfter(reservation.startTime))) {
        occupiedSpaces++;
      }
    }

    return occupiedSpaces <
        totalSpaces;
  }

  List<DateTime> getAvailableTimes(DateTime selectedDate) {
    List<DateTime> times = [];
    DateTime now = DateTime.now();

    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        DateTime time = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, hour, minute);

        if (time.isAfter(now) || time.isAtSameMomentAs(now)) {
          if (isAvailable(time, time.add(Duration(minutes: 30)))) {
            times.add(time);
          }
        }
      }
    }
    return times;
  }

  List<DateTime> getAvailableDepartureTimes(
      DateTime selectedDate, DateTime startTime) {
    List<DateTime> times = [];
    for (int hour = startTime.hour; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        DateTime time = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, hour, minute);
        if (time.isAfter(startTime)) {
          if (isAvailable(startTime, time)) {
            times.add(time);
          }
        }
      }
    }
    return times;
  }
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  List<Reserva> lasReservas = [];
  final Garage garage = Garage();
  DateTime? selectedDate;
  DateTime? startTime;
  DateTime? endTime;
  double? totalHoras = 0.0;
  String? tiempoEstadia;
  double? importeAbonar = 0.0;
  final int VALOR_HORA = 500;
  final int VALOR_FRACCION_5_MINUTOS = 100;

  @override
  void initState() {
    super.initState();
    _fetchReservas();
  }

  Future<void> _fetchReservas() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('Reservas').get();

    List<Reserva> reservas = snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc);
    }).toList();

    setState(() {
      lasReservas = reservas;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        startTime = null;
        endTime = null;
      });
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    if (selectedDate == null) return;

    final List<DateTime> availableTimes =
        garage.getAvailableTimes(selectedDate!);
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Hora de Inicio'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${availableTimes[index].hour.toString().padLeft(2, '0')}:${availableTimes[index].minute.toString().padLeft(2, '0')}'),
                  onTap: () {
                    Navigator.of(context).pop(availableTimes[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        startTime = picked;
        endTime = null;
      });
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    if (selectedDate == null || startTime == null) return;

    final List<DateTime> availableTimes =
        garage.getAvailableDepartureTimes(selectedDate!, startTime!);
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Hora de Fin'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: availableTimes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${availableTimes[index].hour.toString().padLeft(2, '0')}:${availableTimes[index].minute.toString().padLeft(2, '0')}'),
                  onTap: () {
                    Navigator.of(context).pop(availableTimes[index]);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        endTime = picked;
        calculateTotalMinutes();
        calcularImporteAbonar();
      });
    }
  }

  calculateTotalMinutes() {
    if (startTime != null && endTime != null) {
      setState(() {
        totalHoras = (endTime!.difference(startTime!).inMinutes / 60);
        tiempoEstadia = _formatDuracion(totalHoras!);
      });
    }
  }

  String _formatDuracion(double duracion) {
    final int horas = duracion.floor();
    final int minutos = ((duracion - horas) * 60).round();
    return '${horas.toString().padLeft(2, '0')}:${minutos.toString().padLeft(2, '0')}';
  }

  calcularImporteAbonar() {
    if (totalHoras != null) {
      setState(() {
        importeAbonar = (totalHoras! * VALOR_HORA);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiculoState = ref.watch(vehiculoProvider);
    final garageSeleccionado = ref.watch(garageProvider);
    final db = FirebaseFirestore.instance;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        drawer: const MenuUsuario(),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/car_logo.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reservar Garage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => selectDate(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    selectedDate == null
                        ? 'Seleccionar Fecha'
                        : 'Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => selectStartTime(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    startTime == null
                        ? 'Seleccionar Hora de Inicio'
                        : 'Hora de Inicio: ${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => selectEndTime(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    endTime == null
                        ? 'Seleccionar Hora de Fin'
                        : 'Hora de Fin: ${endTime!.hour}:${endTime!.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Total de horas: ${tiempoEstadia ?? '00:00'}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                Text(
                  'Importe a abonar: $importeAbonar',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDate != null &&
                        startTime != null &&
                        endTime != null) {
                      DocumentReference docRef =
                          db.collection('Reservas').doc();
                      String idParaReserva = docRef.id;

                      final reserva = Reserva(
                        id: idParaReserva,
                        startTime: startTime!,
                        endTime: endTime!,
                        elvehiculo: vehiculoState,
                        usuarioId: vehiculoState.userId!,
                        garajeId: garageSeleccionado.id,
                        duracionEstadia: totalHoras!,
                        medioDePago: 'Pendiente',
                        estaPago: false,
                        fueAlGarage: false,
                        seRetiro: false,
                        monto: importeAbonar!,
                        valorHoraAlMomentoDeReserva: VALOR_HORA,
                        valorFraccionAlMomentoDeReserva:
                            VALOR_FRACCION_5_MINUTOS,
                      );

                      ref
                          .read(reservaEnGarageProvider.notifier)
                          .setReserva(reserva);

                      context.push('/metodoPago');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Seleccione una fecha y un lote válido.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Reservar',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BackButtonWidget(
          onPressed: () {
            context.push('/ReservationSelectVehicule');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
