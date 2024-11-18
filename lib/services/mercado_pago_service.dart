import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MercadoPagoService {
  static Future<void> crearPreferenciaDePago(
      double monto, BuildContext context) async {
    final url = Uri.parse("http://127.0.0.1:8080/create_preferences");
    final headers = {"Content-Type": "application/json"};

    final body = jsonEncode({
      "title": "Reserva de Estacionamiento",
      "quantity": 1,
      "unit_price": monto,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final urlPago = data['url'];

        if (await canLaunch(urlPago)) {
          await launch(urlPago);
        } else {
          throw Exception("No se pudo abrir la URL de pago");
        }
      } else {
        throw Exception("Error al crear la preferencia de pago");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al iniciar el pago con MercadoPago'),
        ),
      );
    }
  }
}
