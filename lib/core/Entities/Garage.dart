import 'package:cloud_firestore/cloud_firestore.dart';

class Garage {
  String id;
  String nombre;
  String direccion;
  int lugaresTotales;
  int lugaresDisponibles;
  double valorHora;
  double valorFraccion;

  Garage({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.valorHora,
    required this.valorFraccion,
    required this.lugaresTotales,
  }) : lugaresDisponibles =
            lugaresTotales; // Inicialmente todos los lugares están disponibles.

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "nombre": nombre,
      "direccion": direccion,
      "valorHora": valorHora,
      "valorFraccion": valorFraccion,
      "lugaresTotales": lugaresTotales,
      "lugaresDisponibles": lugaresDisponibles,
    };
  }

  factory Garage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Garage(
      id: data?['id'],
      nombre: data?['nombre'],
      direccion: data?['direccion'],
      valorHora: data?['valorHora'],
      valorFraccion: data?['valorFraccion'],
      lugaresTotales: data?['lugaresTotales'],
    )..lugaresDisponibles =
        data?['lugaresDisponibles'] ?? data?['lugaresTotales'];
  }

  Garage copyWith({
    String? id,
    String? nombre,
    String? direccion,
    double? valorHora,
    double? valorFraccion,
    int? lugaresTotales,
    int? lugaresDisponibles,
  }) {
    return Garage(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      valorHora: valorHora ?? this.valorHora,
      valorFraccion: valorFraccion ?? this.valorFraccion,
      lugaresTotales: lugaresTotales ?? this.lugaresTotales,
    )..lugaresDisponibles = lugaresDisponibles ?? this.lugaresDisponibles;
  }

  String get garageId => id;
}
