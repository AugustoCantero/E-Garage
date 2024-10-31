import 'package:cloud_firestore/cloud_firestore.dart';

class Vehiculo {
  String? userId;
  String? marca;
  String? modelo;
  String? patente;
  String? color;

  Vehiculo(
      {required this.userId,
      required this.marca,
      required this.modelo,
      required this.patente,
      required this.color});

  //Metodo para mandar los datos hacia firestore
  Map<String, dynamic> toFireStore() {
    return {
      'userId': this.userId,
      'marca': this.marca,
      'modelo': this.modelo,
      'patente': this.patente,
      'color': this.color
    };
  }

  //Metodo para trear los datos del vhiculo desde Firestore
  factory Vehiculo.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Vehiculo(
        userId: data?['userId'],
        marca: data?['marca'],
        modelo: data?['modelo'],
        patente: data?['patente'],
        color: data?['color']);
  }

  Vehiculo copywith(
      {String? modelo,
      String? marca,
      String? patente,
      String? userId,
      String? color}) {
    return Vehiculo(
        modelo: modelo ?? this.modelo,
        marca: marca ?? this.marca,
        patente: patente ?? this.patente,
        userId: userId ?? this.userId,
        color: color ?? this.color);
  }

  factory Vehiculo.fromMap(Map<String, dynamic> data) {
    return Vehiculo(
      userId: data['userId'],
      marca: data['marca'],
      modelo: data['modelo'],
      patente: data['patente'],
      color: data['color'],
    );
  }
}

// Método para convertir un Map a Vehiculo
 

/*enum TipoVehiculo {
  Auto,
  Camioneta,
  Moto,
}*/