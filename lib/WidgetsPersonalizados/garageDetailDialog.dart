import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Providers/garage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class GarageDetailDialog extends ConsumerWidget {
  final String id;
  final LatLng location;
  final String name;
  final String imagePath;
  final String details;
  final double valorHora;
  final double valorFraccion;

  const GarageDetailDialog(
      {super.key,
      required this.id,
      required this.location,
      required this.name,
      required this.imagePath,
      required this.details,
      required this.valorHora,
      required this.valorFraccion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      decoration: TextDecoration.none),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  details,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(height: 20),
                Text(
                  'Valor hora: ${valorHora.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      decoration: TextDecoration.none),
                ),
                Text(
                  'Fracción: ${valorFraccion.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(garageProvider.notifier).setGarage(
                        this.id,
                        this.location,
                        this.name,
                        this.imagePath,
                        this.details,
                        this.valorHora,
                        this.valorFraccion);
                    // Obtener el estado actualizado del provider

                    context.goNamed('ReservationSelectVehicule');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Reservar',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
