import 'package:cloud_firestore/cloud_firestore.dart';

class Vehiculo {
  String? modelo;
  String? marca;
  String? patente;
  String? idDuenio;

  Vehiculo(
      {required this.patente,
      required this.marca,
      required this.modelo,
      required this.idDuenio});

  Map<String, dynamic> toFireStore() {
    return {
      if (modelo != null) "modelo": modelo,
      if (marca != null) "marca": marca,
      if (patente != null) "patente": patente,
      if (idDuenio != null) "idDuenio": idDuenio, // Convertir a Map
    };
  }

  /*factory Vehiculo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Vehiculo(
        modelo: data?['modelo'],
        marca: data?['marca'],
        patente: data?['patente'],
        idDuenio: data?['patente']);
  }*/

  factory Vehiculo.fromFirestore(Map<String, dynamic>? data) {
    return Vehiculo(
        modelo: data?['modelo'],
        marca: data?['marca'],
        patente: data?['patente'],
        idDuenio: data?['idDuenio']);
  }

  Vehiculo copywith(
      {String? modelo, String? marca, String? patente, String? idDuenio}) {
    return Vehiculo(
        modelo: modelo ?? this.modelo,
        marca: marca ?? this.marca,
        patente: patente ?? this.patente,
        idDuenio: idDuenio ?? this.idDuenio);
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.marca.toString();
  }
}


/*class Vehiculo {

    String patente;
    TipoVehiculo tipoVehiculo;
    String marca;
    String modelo;
    String? autorizado;
    int? garageID;
    int usuarioID;


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
}*/