import 'package:flutter_application_1/domain/Reserva.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reservaProvider = StateProvider<List<Reserva>>((ref) {
  return [
    /*Reserva(fecha: "2024-05-31 00:00:00", lote: 1),
    Reserva(fecha: "2024-05-31 00:00:00", lote: 2),
    Reserva(fecha: "2024-05-31 00:00:00", lote: 3),
    Reserva(fecha: "2024-05-31 00:00:00", lote: 4),*/
  ];
});

final indexButton = StateProvider<int>((ref) {
  return 0;
});

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/Reserva.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reservaProvider = StateNotifierProvider<ReservasNotifier, List<Reserva>>(
  (ref) => ReservasNotifier(FirebaseFirestore.instance),
);

class ReservasNotifier extends StateNotifier<List<Reserva>> {
  final FirebaseFirestore db;

  ReservasNotifier(this.db) : super([]);

  Future<void> addReserva(Reserva reserva) async {
    final doc = db.collection('reservas').doc();
    try {
      await doc.set(reserva.toFirestore());
      state = [...state, reserva];
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllReservas() async {
    final docs = db.collection('reservas').withConverter(
        fromFirestore: Reserva.fromFirestore,
        toFirestore: (Reserva reserva, _) => reserva.toFirestore());
    final reservas = await docs.get();
    state = [...state, ...reservas.docs.map((d) => d.data())];
  }
}*/