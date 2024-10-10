import 'package:cloud_firestore/cloud_firestore.dart';

class Vehiculo {
  String patente;
  TipoVehiculo tipoVehiculo;
  String marca;
  String modelo;
  String? autorizado;
  String? garageID;
  String usuarioID;

  Vehiculo({
    required this.patente,
    required this.tipoVehiculo,
    required this.marca,
    required this.modelo,
    required this.autorizado,
    this.garageID,
    required this.usuarioID,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'patente': patente,
      'tipoVehiculo': tipoVehiculo,
      'marca': marca,
      'modelo': modelo,
      'autorizado': autorizado,
      'garageID': garageID,
      'usuarioID': usuarioID
    };
  }

  static Vehiculo fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Vehiculo(
        patente: data?['patente'],
        tipoVehiculo: data?['tipoVehiculo'],
        marca: data?['marca'],
        modelo: data?['modelo'],
        autorizado: data?['autorizado'],
        usuarioID: data?['usuarioID']);
  }
}

enum TipoVehiculo {
  Auto,
  Camioneta,
  Moto,
}
