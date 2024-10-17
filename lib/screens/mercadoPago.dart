/*import 'package:flutter/material.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  final String accessToken = 'dev_24c65fb163bf11ea96500242ac130004';

  void _createPayment(BuildContext context) async {
    var mp = MP(accessToken);

    var preference = {
      "items": [
        {
          "title": "Producto de prueba",
          "quantity": 1,
          "currency_id": "ARS", // Peso argentino
          "unit_price": 100.0,
        }
      ],
      "payer": {
        "email": "test_user@example.com",  // Email del usuario que paga
      },
      "back_urls": {
        "success": "tuapp://success",
        "failure": "tuapp://failure",
        "pending": "tuapp://pending"
      },
      "auto_return": "approved",  // Redireccionar automáticamente si el pago es aprobado
    };

    try {
      var result = await mp.createPreference(preference);
      var preferenceId = result['response']['id'];

      // Redirigir a la URL de pago de Mercado Pago
      _redirectToMercadoPago(preferenceId);
    } catch (e) {
      print('Error al crear la preferencia de pago: $e');
    }
  }

  void _redirectToMercadoPago(String preferenceId) async {
  final paymentUrl =
      "https://www.mercadopago.com.ar/checkout/v1/redirect?preference-id=$preferenceId";

  if (await canLaunch(paymentUrl)) {
    await launch(paymentUrl);
  } else {
    throw 'No se pudo abrir la URL de pago: $paymentUrl';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pago con Mercado Pago"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _createPayment(context),
          child: Text("Abonar"),
        ),
      ),
    );
  }
}
*/