class Vehiculo {

    String patente;
    TipoVehiculo tipoVehiculo;
    String marca;
    String modelo;
    String? autorizado;
    int? garageID;
    int usuarioID;


    Vehiculo({
    required this.patente,
    required this.tipoVehiculo,
    required this.marca,
    required this.modelo,
    required this.autorizado,
    this.garageID,
    required this.usuarioID,
  });

}

enum TipoVehiculo {
  Auto,
  Camioneta,
  Moto,
}