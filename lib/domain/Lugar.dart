import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toFirestore(){
    return{
      'lugarID': lugarID,
      'ocupado': ocupado,
      'garageID': garageID,
      'reservaID': reservaID,
    };
  }
  
  static Lugar fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options
  ){
    final data = snapshot.data();

//ver si falta algo!!!
    return Lugar(
      lugarID: data?['lugarID'], 
      garageID: data?['garageID']);
  }

}