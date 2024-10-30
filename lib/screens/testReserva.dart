import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_application_1/screens/login_exitoso_home_user.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/mercadoPago.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
  List<Reserva> lasReservas = [];
  final Garage garage = Garage();
  DateTime? selectedDate;
  DateTime? startTime;
  DateTime? endTime;

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

    final List<DateTime> availableTimes = garage.getAvailableTimes(selectedDate!);
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
        endTime = null;
      });
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    if (selectedDate == null || startTime == null) return;

    final List<DateTime> availableTimes = garage.getAvailableDepartureTimes(selectedDate!, startTime!);
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          title: Center(
            child: Text(
              'Reservar Garage',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        drawer: _buildDrawer(context), // Agregar el Drawer
        body: Center( // Centra todo el contenido de la columna
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
              crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
              children: [
                Image.asset(
                  'assets/images/car_logo.png', // Asegúrate de tener esta imagen en tus assets
                  height: 120,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => selectDate(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    selectedDate == null
                        ? 'Seleccionar Fecha'
                        : 'Fecha: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}',
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
  onPressed: () async {
    if (selectedDate != null && startTime != null && endTime != null) {
      final reserva = Reserva(
        startTime: startTime!,
        endTime: endTime!,
        elvehiculo: vehiculoState,
        usuarioId: vehiculoState.userId!,
      );

      // Guardar la reserva en Firestore
      await db.collection('Reservas').doc().set(reserva.toFirestore());

      // Redirigir a la pantalla de pago de Mercado Pago
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MercadoPagoScreen(
            //reserva: reserva,  // Pasa los detalles de la reserva si es necesario
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione una fecha y un lote')),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.goNamed('ReservationSelectVehicule');
          }, 
          backgroundColor: Colors.white,
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }
}
Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[200],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Menú',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, size: 40, color: Colors.black),
              title: const Text('Editar Datos', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Lógica de navegación a Editar Datos
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer, size: 40, color: Colors.black),
              title: const Text('Gestión de Vehiculos', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Lógica de navegación o acción para Gestión de Reservas
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, size: 40, color: Colors.black),
              title: const Text('Historial y Registro', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Lógica de navegación o acción para Historial y Registro
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, size: 40, color: Colors.black),
              title: const Text('Salir', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }