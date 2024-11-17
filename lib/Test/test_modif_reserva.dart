import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Test/testGesionarReserva.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Entities/Usuario.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_application_1/core/Providers/garage_provider.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/core/Providers/user_provider.dart';
import 'package:flutter_application_1/core/Providers/vehiculo_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ModificacionReservationScreen extends ConsumerStatefulWidget {
  static const String name = "ModificacionReservationScreen";

  const ModificacionReservationScreen({super.key});

  @override
  _ModificacionReservationScreenState createState() =>
      _ModificacionReservationScreenState();
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

class _ModificacionReservationScreenState
    extends ConsumerState<ModificacionReservationScreen> {
  List<Reserva> lasReservas = [];
  final Garage garage = Garage();
  DateTime? selectedDate;
  DateTime? startTime;
  DateTime? endTime;
  double? totalHoras = 0.0;
  double? importeAbonar = 0.0;
  final int VALOR_HORA = 500;
  final int VALOR_FRACCION_5_MINUTOS = 100;
  final db = FirebaseFirestore.instance;
  String? nombreGarage;
  String? direccionGarage;
  String? selectedVehicle;
  Vehiculo? vehiculoSeleccionado;

  void initState() {
    super.initState();
    _fetchReservas();
    _obtenerDatosGarage(db);
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

  Future<void> _obtenerDatosGarage(FirebaseFirestore db) async {
    print('Entre');
    DocumentSnapshot<Map<String, dynamic>> documentGarage =
        await db.collection('GaragePrueba').doc('bRe87UgleeGpBlC1wSUv').get();

    setState(() {
      nombreGarage = documentGarage.data()!['name'];
      direccionGarage = documentGarage.data()!['Direccion'];
    });

    print('sali');
  }

  void _showVehiclePicker(BuildContext context, Usuario usuarioLogueado) {
    final db = FirebaseFirestore.instance;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300, // Definir altura de la ventana emergente
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: db
                .collection('Vehiculos')
                .where('userId', isEqualTo: usuarioLogueado.id)
                .get(), // Obtener datos de Firestore
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error al cargar vehículos'));
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No se encontraron vehículos'));
              }

              // Mostrar la lista de vehículos
              List<DocumentSnapshot<Map<String, dynamic>>> vehicles =
                  snapshot.data!.docs;

              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (BuildContext context, int index) {
                  // Crear el objeto Vehiculo usando fromFirestore
                  final vehiculo =
                      Vehiculo.fromFirestore(vehicles[index], null);

                  return ListTile(
                    title: Text(vehiculo.patente ??
                        'Sin patente'), // Usar el campo marca
                    subtitle: Text(vehiculo.modelo ?? 'Sin Modelo'),
                    trailing: Text(vehiculo.marca ?? 'Sin Marca'),
                    // Mostrar modelo
                    onTap: () {
                      setState(() {
                        selectedVehicle = vehiculo
                            .marca; // Guardar el nombre del vehículo seleccionado
                        vehiculoSeleccionado = vehiculo;
                      });
                      Navigator.pop(context); // Cerrar la ventana modal
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehiculoState = ref.watch(vehiculoProvider);
    final garageSeleccionado = ref.watch(garageProvider);
    final userLogueado = ref.watch(usuarioProvider);
    final reservaAModificar = ref.watch(reservaEnGarageProvider);

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
                const SizedBox(height: 10),
                const Text(
                  'Modificar Reserva \n\n Reserva actual',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24, // Ajusta el tamaño del texto
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  'Vehiculo: ${reservaAModificar.elvehiculo.marca} ${reservaAModificar.elvehiculo.modelo} patente: ${reservaAModificar.elvehiculo.patente} \n'
                  'Garage: ${nombreGarage}\n'
                  'Direccion: ${direccionGarage}\n'
                  'Fecha inicio: ${DateFormat('dd-MM-yyyy HH:mm').format(reservaAModificar.startTime)}\n'
                  'Fecha fin: ${DateFormat('dd-MM-yyyy HH:mm').format(reservaAModificar.endTime)}\n'
                  'cantidad de horas: ${reservaAModificar.duracionEstadia} \n'
                  'Costo estadia: ${reservaAModificar.monto}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 50),
                Text(
                  '¿QUE DESEA CAMBIAR DE LA RESERVA?',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (userLogueado != null) {
                      _showVehiclePicker(context, userLogueado);
                    } else {
                      // Manejar el caso cuando usuarioState es null
                      print('Usuario no encontrado');
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Text(
                      vehiculoSeleccionado == null
                          ? 'Seleccionar Vehículo'
                          : 'Vehículo: ${vehiculoSeleccionado!.patente}',
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 20),
                Text(
                  'Total de horas: ${totalHoras}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Importe a abonar: ${importeAbonar}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    /*  if (selectedDate != null &&
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

                      print(reserva.toString());

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
                    }*/
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
            context.goNamed(editarReserva.name);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      ),
    );
  }
}
