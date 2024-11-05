import 'package:flutter/services.dart';
import 'package:flutter_application_1/utils/globals.dart';

class MercadoPagoService {
  static const MethodChannel _channel = MethodChannel("com.e_garage/mercadoPago");

  Future<void> iniciarPago(String publicKey, String preferenceId) async {
    try {
      final result = await _channel.invokeMethod('mercadoPago', {
        "publicKey": mpPublicKey,
        "preferenceId": preferenceId,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Error al iniciar Mercado Pago: ${e.message}");
    }
  }
}
