class Lugar {

    int lugarID;
    bool ocupado;
    int garageID;
    int? reservaID;

    //agregar tema de faceID huella

  Lugar({
  required this.lugarID,
  this.ocupado = false,
  required this.garageID,
  this.reservaID
  });
  

}