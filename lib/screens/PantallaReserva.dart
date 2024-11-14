import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/garage_provider.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/Providers/reserva_provider.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_application_1/screens/MetodoDePago.dart';
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
  // Tengo que llenar esta array con las reservas
  final String idGarage = 'PruebaIdGarage';
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
    DateTime now = DateTime.now(); // Obtener la hora actual

    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        DateTime time = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, hour, minute);

        // Solo agregar el tiempo si es después de la hora actual y está disponible
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
  List<Reserva> lasReservas = [];
  final Garage garage = Garage();
  DateTime? selectedDate;
  DateTime? startTime;
  DateTime? endTime;
  double? totalHoras;
  double? importeAbonar;
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
      });
    }
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
                  height: 100, // Tamaño más pequeño para el auto
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reservar Garage',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24, // Ajusta el tamaño del texto
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
                  'Total de horas: ${totalHoras}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                Text(
                  'Importe a abonar: ${importeAbonar}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedDate != null &&
                        startTime != null &&
                        endTime != null) {
                      //MOMENTANEAMENTE ESTO VA A IR ACA, LA IDEA ES QUE SE GENERE TODO UNA VEZ CONFIRMADO EL PAGO.
                      DocumentReference docRef =
                          db.collection('Reservas').doc();
                      String idParaReserva = docRef.id;
                      //--------------------------------------------------------------------------------------------

                      final reserva = Reserva(
                          id: idParaReserva,
                          startTime: startTime!,
                          endTime: endTime!,
                          elvehiculo: vehiculoState,
                          usuarioId: vehiculoState.userId!,
                          garajeId: garageSeleccionado.id,
                          duracionEstadia: totalHoras!,
                          medioDePago: 'Efectivo',
                          estaPago: false,
                          fueAlGarage: false,
                          seRetiro: false,
                          monto: importeAbonar!,
                          valorHoraAlMomentoDeReserva: VALOR_HORA,
                          valorFraccionAlMomentoDeReserva:
                              VALOR_FRACCION_5_MINUTOS);

                      ref
                          .read(reservaEnGarageProvider.notifier)
                          .setReserva(reserva);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MetodoPagoScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Seleccione una fecha y un lote')),
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
                  child: const Text(
                    'Reservar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: BackButtonWidget(
          onPressed: () {
            context.goNamed('ReservationSelectVehicule');
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
