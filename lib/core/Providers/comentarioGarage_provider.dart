import 'package:flutter_application_1/core/Entities/ComentarioReserva.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usuarioProvider =
    StateNotifierProvider<ComentarioReservaNotifier, Comentarioreserva>((ref) {
  return ComentarioReservaNotifier();
});

class ComentarioReservaNotifier extends StateNotifier<Comentarioreserva> {
  ComentarioReservaNotifier()
      : super(Comentarioreserva(
            id: '',
            idGarage: '',
            idReserva: '',
            idUsuario: '',
            comentario: '',
            puntuacion: 0.0));

  void comentarioReservaUsuario(String id, String idGarage, String idReserva,
      String idUsuario, String comentario, double puntualcion) {
    state = state.copywith(
        id: id,
        idGarage: idGarage,
        idReserva: idReserva,
        idUsuario: idUsuario,
        comentario: comentario,
        puntuacion: puntualcion);
  }

  void clearComentarioreserva() {
    state = Comentarioreserva(
        id: '',
        idGarage: '',
        idReserva: '',
        idUsuario: '',
        comentario: '',
        puntuacion: 0.0);
  }
}
