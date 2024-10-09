import 'package:cloud_firestore/cloud_firestore.dart';
class Pago {

    int pagoID;
    int monto;

    // implementar todo lo de metodos de pago

  

  Pago({
  required this.pagoID,
  required this.monto,
   });
  
  Map<String, dynamic> toFirestore(){
    return{
      'pagoID': pagoID,
      'monto': monto
    };
  }

  static Pago fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Pago(
      pagoID: data?['pagoID'], 
      monto: data?['monto']);
  }
}