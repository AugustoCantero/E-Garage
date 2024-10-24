import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:intl/intl.dart';

class Reserva {
  DateTime startTime;
  DateTime endTime;
  Vehiculo elvehiculo;
  String usuarioId;

  Reserva({
    required this.startTime,
    required this.endTime,
    required this.elvehiculo,
    required this.usuarioId,
  });

  factory Reserva.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Reserva(
      startTime: (data['fechaHoraInicio'] as Timestamp).toDate(),
      endTime: (data['fechaHoraFin'] as Timestamp).toDate(),
      elvehiculo: Vehiculo.fromMap(data['elvehiculo']), // Usar el nuevo método
      usuarioId: data['idUsuario'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fechaHoraInicio': this.startTime,
      'fechaHoraFin': this.endTime,
      'elvehiculo': {
        'modelo': elvehiculo.modelo,
        'marca': elvehiculo.marca,
        'patente': elvehiculo.patente,
        'idDuenio': elvehiculo.userId,
      },
      'idUsuario': usuarioId,
    };
  }
}
