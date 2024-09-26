
import 'Lugar.dart';

class Garage {

    int garageID;
    String direccion;
    int espaciosTotales;
    int espaciosDisponibles;
    int usuarioID;  
    List<Lugar> lugares;

   

  Garage({
  required this.garageID,
  required this.direccion,
  required this.espaciosTotales,
  required this.espaciosDisponibles,
  required this.usuarioID,
  }) : lugares = List.generate(
        espaciosTotales, 
        (index) => Lugar(lugarID: index + 1, garageID: garageID), // Pasar garageID
      ) {
        marcarLugaresOcupados();
  }

  // Método para marcar los lugares ocupados
  void marcarLugaresOcupados() {
    int lugaresOcupados = espaciosTotales - espaciosDisponibles;
    for (int i = 0; i < lugaresOcupados; i++) {
      lugares[i].ocupado = true; // Marca los primeros lugares como ocupados
    }
  }
}



