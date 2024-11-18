import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:intl/intl.dart';

class Reserva {
  String id;
  DateTime startTime;
  DateTime endTime;
  Vehiculo elvehiculo;
  String garajeId;
  String usuarioId;
  String medioDePago;
  double monto;
  int valorHoraAlMomentoDeReserva;
  int valorFraccionAlMomentoDeReserva;
  double duracionEstadia;
  bool estaPago;
  bool? fueAlGarage;
  bool? seRetiro;

  Reserva({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.elvehiculo,
    required this.usuarioId,
    required this.garajeId,
    required this.medioDePago,
    required this.valorHoraAlMomentoDeReserva,
    required this.valorFraccionAlMomentoDeReserva,
    required this.monto,
    required this.duracionEstadia,
    required this.estaPago,
    this.fueAlGarage,
    this.seRetiro,
  });

  factory Reserva.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Reserva(
      id: data['id'],
      startTime: (data['fechaHoraInicio'] as Timestamp).toDate(),
      endTime: (data['fechaHoraFin'] as Timestamp).toDate(),
      elvehiculo: Vehiculo.fromMap(data['elvehiculo']),
      usuarioId: data['idUsuario'],
      garajeId: data['garajeId'],
      medioDePago: data['medioDePago'],
      valorHoraAlMomentoDeReserva: data['valorHoraAlMomentoDeReserva'],
      valorFraccionAlMomentoDeReserva: data['valorFraccionAlMomentoDeReserva'],
      monto: (data['monto'] as num).toDouble(),
      duracionEstadia: (data['duracionEstadia'] as num).toDouble(),
      estaPago: data['estaPago'],
      fueAlGarage: data['fueAlGarage'],
      seRetiro: data['seRetiro'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fechaHoraInicio': startTime,
      'fechaHoraFin': endTime,
      'elvehiculo': {
        'modelo': elvehiculo.modelo,
        'marca': elvehiculo.marca,
        'patente': elvehiculo.patente,
        'idDuenio': elvehiculo.userId,
      },
      'idUsuario': usuarioId,
      'garajeId': garajeId,
      'medioDePago': medioDePago,
      'monto': monto,
      'valorHoraAlMomentoDeReserva': valorHoraAlMomentoDeReserva,
      'valorFraccionAlMomentoDeReserva': valorFraccionAlMomentoDeReserva,
      'duracionEstadia': duracionEstadia,
      'estaPago': estaPago,
      'fueAlGarage': fueAlGarage,
      'seRetiro': seRetiro,
    };
  }

  Reserva copywith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    Vehiculo? elvehiculo,
    String? garajeId,
    String? usuarioId,
    String? medioDePago,
    double? monto,
    int? valorHoraAlMomentoDeReserva,
    int? valorFraccionAlMomentoDeReserva,
    double? duracionEstadia,
    bool? estaPago,
    bool? fueAlGarage,
    bool? seRetiro,
  }) {
    return Reserva(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      elvehiculo: elvehiculo ?? this.elvehiculo,
      usuarioId: usuarioId ?? this.usuarioId,
      garajeId: garajeId ?? this.garajeId,
      medioDePago: medioDePago ?? this.medioDePago,
      monto: monto ?? this.monto,
      valorHoraAlMomentoDeReserva:
          valorHoraAlMomentoDeReserva ?? this.valorHoraAlMomentoDeReserva,
      valorFraccionAlMomentoDeReserva: valorFraccionAlMomentoDeReserva ??
          this.valorFraccionAlMomentoDeReserva,
      duracionEstadia: duracionEstadia ?? this.duracionEstadia,
      estaPago: estaPago ?? this.estaPago,
      fueAlGarage: fueAlGarage ?? this.fueAlGarage,
      seRetiro: seRetiro ?? this.seRetiro,
    );
  }

  @override
  String toString() {
    return 'Reserva{id: $id, startTime: $startTime, endTime: $endTime, '
        'elvehiculo: ${elvehiculo.toString()}, garajeId: $garajeId, '
        'usuarioId: $usuarioId, medioDePago: $medioDePago, monto: $monto, '
        'valorHoraAlMomentoDeReserva: $valorHoraAlMomentoDeReserva, '
        'valorFraccionAlMomentoDeReserva: $valorFraccionAlMomentoDeReserva, '
        'duracionEstadia: $duracionEstadia, estaPago: $estaPago, '
        'fueAlGarage: $fueAlGarage, seRetiro: $seRetiro}';
  }

  String infoReserva() {
    return 'Reserva para vehículo ${elvehiculo.patente}\n'
    'Fecha inicio: ${DateFormat('dd-MM-yyyy HH:mm').format(startTime)}\n'
    'Fecha fin: ${DateFormat('dd-MM-yyyy HH:mm').format(endTime)}\n'
    'Costo estadia: $monto';
  }
}
