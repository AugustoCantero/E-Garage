import 'package:flutter_application_1/WidgetsPersonalizados/GarageMarker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final garageProvider =
    StateNotifierProvider<UsuarioNotifier, GarageMarker>((ref) {
  return UsuarioNotifier();
});

class UsuarioNotifier extends StateNotifier<GarageMarker> {
  UsuarioNotifier()
      : super(GarageMarker(
            id: '',
            location: LatLng(0.0, 0.0),
            name: '',
            imagePath: '',
            details: '',
            valorHora: 0.0,
            valorFraccion: 0.0));

  void setGarage(String id, LatLng location, String imagePath, String details,
      String name, double valorHora, double valorFraccion) {
    state = state.copywith(
        id: id,
        location: location,
        imagePath: imagePath,
        details: details,
        name: name,
        valorHora: valorHora,
        valorFraccion: valorFraccion);
  }

  // Método para limpiar los datos del usuario (cierre de sesión)
  void clearGarage() {
    state = GarageMarker(
        id: '',
        location: LatLng(0.0, 0.0),
        imagePath: '',
        details: '',
        name: '',
        valorHora: 0.0,
        valorFraccion: 0.0);
  }
}
