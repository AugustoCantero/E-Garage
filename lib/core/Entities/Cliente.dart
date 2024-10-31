import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/Entities/Usuario.dart';

class Cliente extends Usuario {
      Cliente({
    required String id,
    required String email,
    required String password,
    required String nombre,
    required String apellido,
    required String dni,
    required String telefono,
    
  }) : super(
          id: id,
          email: email,
          password: password,
          nombre: nombre,
          apellido: apellido,
          dni: dni,
          telefono: telefono,
        );
}