import 'package:flutter_application_1/core/Entities/Vehiculo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vehiculoProvider =
    StateNotifierProvider<vehiculoNotifier, Vehiculo>((ref) {
  return vehiculoNotifier();
});

class vehiculoNotifier extends StateNotifier<Vehiculo> {
  vehiculoNotifier()
      : super(Vehiculo(
            patente: 'xxx123',
            marca: 'xxx123',
            modelo: 'xxx123',
            color: 'blanco',
            userId: 'RIWofZj3xzRRHeMRg73YUZCG89m2'));

  void setVehiculo(Vehiculo vehiculo) {
    state = state.copywith(
      patente: vehiculo.patente,
      marca: vehiculo.marca,
      modelo: vehiculo.modelo,
      color: vehiculo.color,
      userId: vehiculo.userId,
    );
  }
}
