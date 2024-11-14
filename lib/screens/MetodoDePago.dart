import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonAtras.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/MenuUsuario.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/BotonBot.dart';
import 'package:flutter_application_1/core/Entities/Garage.dart';
import 'package:flutter_application_1/core/Entities/Reserva.dart';
import 'package:flutter_application_1/core/Providers/garage_provider.dart';
import 'package:flutter_application_1/core/Providers/reservaGarage.dart';
import 'package:flutter_application_1/screens/LoginUsuario.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class MetodoPagoScreen extends ConsumerStatefulWidget {
  static const String routename = 'MetodoPagoScreen';
  const MetodoPagoScreen({super.key});

  @override
  _MetodoPagoScreenState createState() => _MetodoPagoScreenState();
}

class _MetodoPagoScreenState extends ConsumerState<MetodoPagoScreen> {
  int _selectedOption = -1; // Ninguna opción seleccionada por defecto

  void _onOptionSelected(int option) {
    setState(() {
      _selectedOption = option;
    });
  }

  Future<void> _guardarReserva() async {
    final db = FirebaseFirestore.instance;
    Reserva ReservaCargada = ref.watch(reservaEnGarageProvider);

    print(ReservaCargada.toString());

    db
        .collection('Reservas')
        .doc(ReservaCargada.id)
        .set(ReservaCargada.toFirestore());
  }

  Future<void> _confirmSelection() async {
    if (_selectedOption == 0) {
      //COMENTADO SOLO PARA PROBAR LA RESERVA
      //Navigator.pushNamed(context, '/efectivoScreen'); // Redirige a Efectivo
      await _guardarReserva();
      context.goNamed(LoginUsuario.name);
    } else if (_selectedOption == 1) {
      Navigator.pushNamed(context, '/modoScreen'); // Redirige a MODO
    } else if (_selectedOption == 2) {
      await _launchMercadoPagoURL(); // Redirige a URL de Mercado Pago
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un método de pago')),
      );
    }
  }

  Future<void> _launchMercadoPagoURL() async {
    final dio = Dio();
    try {
      Response<Map> response =
          await dio.post('http://127.0.0.1:8080/create_preferences');
      //response = await dio.post('http://127.0.0.1:8080/create_preferences');
      var res = response.data;
      String? url = res?["url"];
      if (url != null) {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'No se pudo abrir el enlace $url';
        }
      } else {
        print("URL no disponible en la respuesta.");
      }
    } catch (e) {
      print("Error al abrir la URL: $e");
    }
  }
  /*  print(res?["url"]);
    if (context.mounted) {
      context.go('/aprobado', extra: {
    'url': res?["url"],
  });
}
    } catch (e){
      print(e);
    }
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const MenuUsuario(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/car_logo.png',
                height: 150,
              ),
              const SizedBox(height: 20),
              const Text(
                "Método de Pago",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  _buildPaymentOption(
                    index: 0,
                    label: "Efectivo",
                    imagePath: 'assets/images/efectivo.png',
                  ),
                  _buildPaymentOption(
                    index: 1,
                    label: "MODO",
                    imagePath: 'assets/images/modo.png',
                  ),
                  _buildPaymentOption(
                    index: 2,
                    label: "Mercado Pago",
                    imagePath: 'assets/images/mercado.png',
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _confirmSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Confirmar',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 20,
            left: 20,
            child: BackButtonWidget(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Positioned(
            bottom: 20,
            right: 20,
            child: BotLogoButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      {required int index, required String label, required String imagePath}) {
    return GestureDetector(
      onTap: () => _onOptionSelected(index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _selectedOption == index ? Colors.blue : Colors.white,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Icon(
              _selectedOption == index
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: _selectedOption == index ? Colors.blue : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
