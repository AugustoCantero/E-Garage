import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/Vehiculo.dart';

class Reserva {
  int fecha;
  int lote;
  Vehiculo elvehiculo;

  Reserva({required this.fecha, required this.lote, required this.elvehiculo});

  String getData() {
    return 'Dia reservado: $fecha, numero de lote $lote';
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.fecha.toString() +
        '' +
        this.lote.toString() +
        '' +
        elvehiculo.toString();
  }

  String getDatos() {
    return 'Fecha reservada: ${fecha.toString()}, Patente: ${elvehiculo.patente}, Propietario: ${elvehiculo.idDuenio}, Marca: ${elvehiculo.marca} ';
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fecha': this.fecha,
      'lote': this.lote,
      'elvehiculo': {
        'modelo': elvehiculo.modelo,
        'marca': elvehiculo.marca,
        'patente': elvehiculo.patente,
        'idDuenio': elvehiculo.idDuenio
      }
    };
  }

  factory Reserva.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Reserva(
      fecha: data['fecha'],
      lote: data['lote'],
      elvehiculo: Vehiculo.fromFirestore(data['elvehiculo']),
    );
  }
}


/*class Reserva {
  int reservaID;
  DateTime fechaReserva;
  TimeOfDay horaEntrada;
  TimeOfDay horaSalida;
  bool servicioLavado;
  int pagoID;
  String patente;
  int lugarID;

  Reserva(
      {required this.reservaID,
      DateTime? fechaReserva,
      required this.horaEntrada,
      required this.horaSalida,
      required this.servicioLavado,
      required this.pagoID,
      required this.patente,
      required this.lugarID})
      : this.fechaReserva = fechaReserva ?? DateTime.now();

  Map<String, dynamic> toFirestore() {
    return {
      'reservaID': reservaID,
      'fechaReserva': fechaReserva,
      'horaEntrada': horaEntrada,
      'horaSalida': horaSalida,
      'servicioLavado': servicioLavado,
      'pagoID': pagoID,
      'patente': patente,
      'lugarID': lugarID
    };
  }

  static Reserva fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Reserva(
        reservaID: data?['reservaID'],
        horaEntrada: data?['horaEntrada'],
        horaSalida: data?['horaSalida'],
        servicioLavado: data?['servicioLavado'],
        pagoID: data?['pagoID'],
        patente: data?['patente'],
        lugarID: data?['lugarID']);
  }
}

enum Estado { Activa, Cancelada, Finalizada }*/
