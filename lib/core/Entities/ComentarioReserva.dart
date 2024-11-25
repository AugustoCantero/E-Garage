import 'package:cloud_firestore/cloud_firestore.dart';

class cometarioReserva {
  String? id;
  String? idReserva;
  String? idGarage;
  String? idUsuario;
  String? comentario;
  double? puntuacion;

  cometarioReserva({
    required this.id,
    required this.idGarage,
    required this.idReserva,
    required this.idUsuario,
    required this.comentario,
    required this.puntuacion,
  });

  // Método para convertir la clase a un Map<String, dynamic> para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (idGarage != null) "idGarage": idGarage,
      if (idReserva != null) "idReserva": idReserva,
      if (idUsuario != null) "idUsuario": idUsuario,
      if (comentario != null) "comentario": comentario,
      if (puntuacion != null) "puntuacion": puntuacion,
    };
  }

  // Constructor para crear una instancia desde los datos de Firestore
  factory cometarioReserva.fromFirestore(Map<String, dynamic> data, String id) {
    return cometarioReserva(
      id: id, // El id del documento de Firestore
      idGarage: data['idGarage'] ?? '',
      idReserva: data['idReserva'] ?? '',
      idUsuario: data['idUsuario'] ?? '',
      comentario: data['comentario'] ?? '',
      puntuacion: (data['puntuacion'] ?? 0).toDouble(),
    );
  }
}
