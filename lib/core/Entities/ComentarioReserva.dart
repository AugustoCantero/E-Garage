import 'package:cloud_firestore/cloud_firestore.dart';

class cometarioReserva {
  String? idReserva;
  String? idGarage;
  String? idUsuario;
  String? comentario;
  double? puntuacion;

  cometarioReserva(
      {required this.idGarage,
      required this.idReserva,
      required this.idUsuario,
      required this.comentario,
      required this.puntuacion});

  Map<String, dynamic> toFirestore() {
    return {
      if (idGarage != null) "idGarage": idGarage,
      if (idReserva != null) "idReserva": idReserva,
      if (idUsuario != null) "idUsuario": idUsuario,
      if (comentario != null) "comentario": comentario,
      if (puntuacion != null) "puntuacion": puntuacion,
    };
  }

  factory cometarioReserva.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return cometarioReserva(
      idGarage: data?['idGarage'],
      idReserva: data?['idReserva'],
      idUsuario: data?['idUsuario'],
      comentario: data?['comentario'],
      puntuacion: data?['puntuacion'],
    );
  }
}
