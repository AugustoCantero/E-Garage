import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
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

enum Estado { Activa, Cancelada, Finalizada }
