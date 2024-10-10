import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/domain/Reserva.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reservaProvider = StateNotifierProvider<ReservasNotifier, List<Reserva>>(
  (ref) => ReservasNotifier(FirebaseFirestore.instance),
);

class ReservasNotifier extends StateNotifier<List<Reserva>> {
  final FirebaseFirestore db;

  ReservasNotifier(this.db) : super([]);

//revisar!!!
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

//revisar!!!
  Future<void> deleteReserva(String id) async {
    try {
      await db.collection('reservas').doc(id).delete();
      state = state.where((reserva) => reserva.reservaID != id).toList();
    } catch (e) {
      print(e);
    }
  }
}