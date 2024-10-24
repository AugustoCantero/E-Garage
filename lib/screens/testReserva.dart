import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Importar el paquete intl

class ReservationScreen extends ConsumerStatefulWidget {
  static const String name = "ReservationScreen";

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class Garage {
  // Tengo que llenar esta array con las reservas

  final List<Reserva> reservations; // Lista de reservas
  final int totalSpaces; // Total de espacios disponibles en el garage

  Garage(
      {this.totalSpaces = 3,
      List<Reserva>?
          reservasIngresadas}) // Inicializa reservations // Asigna 3 como valor por defecto
      : reservations = reservasIngresadas ?? [];

  // Verifica la disponibilidad en un rango dado
  bool isAvailable(DateTime start, DateTime end) {
    int occupiedSpaces = 0;

    for (var reservation in reservations) {
      // Contar reservas que se solapan con el rango
      if ((start.isBefore(reservation.endTime) &&
          end.isAfter(reservation.startTime))) {
        occupiedSpaces++;
      }
    }

    return occupiedSpaces <
        totalSpaces; // Devuelve true si hay al menos un espacio disponible
  }

  List<DateTime> getAvailableTimes(DateTime selectedDate) {
    List<DateTime> times = [];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        DateTime time = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, hour, minute);
        // Solo agrega el tiempo si está disponible
        if (isAvailable(time, time.add(Duration(minutes: 30)))) {
          times.add(time);
        }
      }
    }
    return times;
  }

  List<DateTime> getAvailableDepartureTimes(
      DateTime selectedDate, DateTime startTime) {
    List<DateTime> times = [];
    // Inicia desde la misma hora que se seleccionó para el inicio.
    for (int hour = startTime.hour; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        DateTime time = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, hour, minute);
        // Permitir seleccionar la hora de fin justo después de la hora de inicio
        if (time.isAfter(startTime)) {
          // Cambiar isAtSameMomentAs a isAfter
          // Verificar que la hora de fin seleccionada no se superponga con las reservas existentes
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
  //consumer state, staful y consumer widget combinados!!!
  List<Reserva> lasReservas = [];
  final Garage garage = Garage();
  DateTime? selectedDate;
  DateTime? startTime;
  DateTime? endTime;

  @override // lo primero que se va a ejectuar al abrir la pantalla.
  void initState() {
    super.initState();
    _fetchReservas();
  }

  Future<void> _fetchReservas() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('Reservas').get();

    // Usa snapshot.docs para obtener una lista de DocumentSnapshot
    List<Reserva> reservas = snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc); // Esto debería estar bien
    }).toList();

    setState(() {
      lasReservas = reservas;
    });
  }

  void checkAvailability() {
    if (selectedDate != null && startTime != null && endTime != null) {
      if (startTime!.isBefore(endTime!) &&
          garage.isAvailable(startTime!, endTime!)) {
        // Aquí puedes añadir la lógica para hacer la reserva
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Reserva realizada!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No disponible en este rango horario.')));
      }
    }
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
        startTime = null; // Reinicia el tiempo seleccionado al cambiar la fecha
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
          title: Text('Seleccionar Hora de Inicio'),
          content: Container(
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
        endTime =
            null; // Reinicia el tiempo de salida al seleccionar uno nuevo de ingreso
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
          title: Text('Seleccionar Hora de Fin'),
          content: Container(
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiculoState = ref.watch(vehiculoProvider);
    final db = FirebaseFirestore.instance;

    return Scaffold(
        appBar: AppBar(title: Text('Reservar Garage')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () => selectDate(context),
                child: Text(selectedDate == null
                    ? 'Seleccionar Fecha'
                    : 'Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'), // Formatear la fecha
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => selectStartTime(context),
                child: Text(startTime == null
                    ? 'Seleccionar Hora de Inicio'
                    : 'Hora de Inicio: ${startTime!.hour}:${startTime!.minute.toString().padLeft(2, '0')}'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => selectEndTime(context),
                child: Text(endTime == null
                    ? 'Seleccionar Hora de Fin'
                    : 'Hora de Fin: ${endTime!.hour}:${endTime!.minute.toString().padLeft(2, '0')}'),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (selectedDate != null &&
                      startTime != null &&
                      endTime != null) {
                    final reserva = Reserva(
                        startTime: startTime!,
                        endTime: endTime!,
                        elvehiculo: vehiculoState,
                        usuarioId: vehiculoState.userId!);

                    await db
                        .collection('Reservas')
                        .doc()
                        .set(reserva.toFirestore());

                    context.goNamed(login_exitoso_home_user.name);
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.goNamed(login_exitoso_home_user.name);
          },
        ));
  }
}
