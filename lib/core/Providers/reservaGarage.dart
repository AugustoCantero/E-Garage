import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reservaEnGarageProvider =
    StateNotifierProvider<reservaNotifier, Reserva>((ref) {
  return reservaNotifier();
});

class reservaNotifier extends StateNotifier<Reserva> {
  reservaNotifier()
      : super(Reserva(
          id: 'ERROR',
          startTime: DateTime(1999, 1, 1, 01, 00, 00),
          endTime: DateTime(1999, 1, 1, 23, 59, 59),
          elvehiculo: Vehiculo(
              userId: 'userId',
              marca: 'marca',
              modelo: 'modelo',
              patente: 'patente',
              color: 'color'),
          garajeId: '999999',
          usuarioId: '999999999',
          duracionEstadia: -5.0,
          medioDePago: '',
          monto: -1,
          valorHoraAlMomentoDeReserva: 1000000,
          valorFraccionAlMomentoDeReserva: 100000000,
          estaPago: false,
        ));

  void setReserva(Reserva reserva) {
    state = state.copywith(
        id: reserva.id,
        startTime: reserva.startTime,
        endTime: reserva.endTime,
        elvehiculo: reserva.elvehiculo,
        usuarioId: reserva.usuarioId,
        garajeId: reserva.garajeId,
        fueAlGarage: reserva.fueAlGarage,
        seRetiro: reserva.seRetiro,
        monto: reserva.monto,
        estaPago: false,
        duracionEstadia: reserva.duracionEstadia,
        valorHoraAlMomentoDeReserva: reserva.valorHoraAlMomentoDeReserva,
        valorFraccionAlMomentoDeReserva:
            reserva.valorFraccionAlMomentoDeReserva);
  }

  // Método para limpiar los datos del usuario (cierre de sesión)
  void clearReserva() {
    state = Reserva(
      id: 'LIMPIEZA PROVIDER',
      startTime: DateTime(1999, 1, 1, 01, 00, 00),
      endTime: DateTime(1999, 1, 1, 01, 00, 00),
      elvehiculo: Vehiculo(
          userId: 'userId',
          marca: 'marca',
          modelo: 'modelo',
          patente: 'patente',
          color: 'color'),
      usuarioId: '',
      garajeId: '',
      fueAlGarage: false,
      seRetiro: false,
      monto: -1,
      duracionEstadia: -5.0,
      medioDePago: 'Efectivo',
      estaPago: false,
      valorHoraAlMomentoDeReserva: -9999999,
      valorFraccionAlMomentoDeReserva: -99999999,
    );
  }
}
