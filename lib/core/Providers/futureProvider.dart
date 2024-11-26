import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/core/Entities/ComentarioReserva.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final puntajeProvider =
    FutureProvider.family<double, String>((ref, garageId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Obtén los documentos que coinciden con el idGarage
  QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
      .collection('ComentarioReserva')
      .where('idGarage', isEqualTo: garageId)
      .get();

  // Convierte los documentos en una lista de objetos Comentarioreserva
  List<Comentarioreserva> listaComentarios =
      snapshot.docs.map((doc) => Comentarioreserva.fromFirestore(doc)).toList();

  // Calcula el puntaje total sumando los puntajes individuales
  double puntaje = 0.0;
  for (var comentario in listaComentarios) {
    puntaje += comentario.traerElPuntaje ?? 0.0;
  }

  if (puntaje > 0) {
    return puntaje / listaComentarios.length;
  } else {
    return 0.0;
  }
});
