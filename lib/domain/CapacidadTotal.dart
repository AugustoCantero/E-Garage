import 'package:cloud_firestore/cloud_firestore.dart';

class CapacidadTotal {
  int? cantTotalLugares;

  CapacidadTotal({this.cantTotalLugares});

  Map<String, dynamic> toFirestore() {
    return {"cantTotalLugares": cantTotalLugares};
  }

  factory CapacidadTotal.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return CapacidadTotal(cantTotalLugares: data!['cantTotalLugares']);
  }
}
