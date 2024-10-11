import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String id;
  String email;
  String contrasenia;
  String nombre;
  String apellido;
  String dni;
  bool? esAdmin;

  Usuario(
      {required this.id,
      required this.email,
      required this.contrasenia,
      required this.nombre,
      required this.apellido,
      required this.dni,
      this.esAdmin});

  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "email": email,
      "contrasenia": contrasenia,
      "nombre": nombre,
      "apellido": apellido,
      "apellido": dni,
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
        contrasenia: data?['contrasenia'],
        nombre: data?['nombre'],
        apellido: data?['apellido'],
        dni: data?['dni'],
        esAdmin: data?['esAdmin']);
  }

  //Sirve para editar datos // es basicamente otro constructor
}
