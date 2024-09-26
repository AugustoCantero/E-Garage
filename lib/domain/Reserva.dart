import 'package:flutter/material.dart';

class Reserva {

    int reservaID;
    DateTime fechaReserva;
    TimeOfDay horaEntrada; 
    TimeOfDay horaSalida;
    bool servicioLavado;
    int pagoID;
    String patente;
    int lugarID;


  Reserva({
 required this.reservaID,
    DateTime? fechaReserva, 
    required this.horaEntrada,
    required this.horaSalida,
    required this.servicioLavado,
    required this.pagoID,
    required this.patente,
    required this.lugarID
  }) : this.fechaReserva = fechaReserva ?? DateTime.now(); 
}

enum Estado {
  Activa,
  Cancelada,
  Finalizada
}