import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String id;
  String email;
  String password;
  String nombre;
  String apellido;
  String dni;
  bool? esAdmin;

  Usuario(
      {required this.id,
      required this.email,
      required this.password,
      required this.nombre,
      required this.apellido,
      required this.dni,
      this.esAdmin});

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (email != null) "email": email,
      if (password != null) "password": password,
      if (nombre != null) "nombre": nombre,
      if (apellido != null) "apellido": apellido,
      if (dni != null) "dni": dni,
      'esAdmin': false
    };
  }

  factory Usuario.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Usuario(
        id: data?['id'],
        email: data?['email'],
        password: data?['password'],
        nombre: data?['nombre'],
        apellido: data?['apellido'],
        dni: data?['dni'],
        esAdmin: data?['esAdmin']);
  }

  Usuario copywith(
      {String? id,
      String? email,
      String? password,
      String? nombre,
      String? apellido,
      String? dni,
      bool? esAdmin}) {
    return Usuario(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        dni: dni ?? this.dni,
        esAdmin: esAdmin ?? false);
  }
}