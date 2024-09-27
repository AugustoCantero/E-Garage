import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String usuarioID;
  String nombre;
  String apellido;
  String dni;
  String email;
  String password;
  String telefono;
  bool? esAdmin;

  //agregar tema de faceID huella

  Usuario(
      {required this.usuarioID,
      required this.email,
      required this.password,
      required this.nombre,
      required this.apellido,
      required this.dni,
      required this.telefono,
      this.esAdmin});

  Map<String, dynamic> toFirestore() {
    return {
      if (usuarioID != null) "id": usuarioID,
      if (email != null) "email": email,
      if (password != null) "password": password,
      if (nombre != null) "nombre": nombre,
      if (apellido != null) "apellido": apellido,
      if (dni != null) "apellido": dni,
      if (telefono != null) "telefono": telefono,
      'esAdmin': false
    };
  }

  factory Usuario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Usuario(
        usuarioID: data?['usuarioID'],
        email: data?['email'],
        password: data?['password'],
        nombre: data?['nombre'],
        apellido: data?['apellido'],
        dni: data?['dni'],
        telefono: data?['telefono'],
        esAdmin: data?['esAdmin']);
  }
}
