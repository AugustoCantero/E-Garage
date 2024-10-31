import 'package:cloud_firestore/cloud_firestore.dart';


class Garage {
  String id;
  String nombre;
  String direccion;
  int lugaresTotales;
  int lugaresDisponibles;

  Garage({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.lugaresTotales,
  }) : lugaresDisponibles = lugaresTotales; 
  
  }// Inicialmente todos los lugares están disponibles