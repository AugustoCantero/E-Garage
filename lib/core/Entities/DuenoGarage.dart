import 'package:flutter_application_1/core/Entities/Garage.dart';
import 'package:flutter_application_1/core/Entities/Usuario.dart';

class DuenoGarage extends Usuario {
  List<Garage> garages;
  String razonSocial;
  String CUIT;

  DuenoGarage({
    required String id,
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String dni,
    required String telefono,
    required this.garages,
    required this.razonSocial,
    required this.CUIT
  }) : super (
          id: id,
          email: email,
          password: password,
          nombre: nombre,
          apellido: apellido,
          dni: dni,
          telefono: telefono,
          esAdmin: true,
        );
}