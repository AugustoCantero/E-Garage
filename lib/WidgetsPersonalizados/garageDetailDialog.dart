import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/Entities/ComentarioReserva.dart';
import 'package:flutter_application_1/core/Providers/futureProvider.dart';
import 'package:flutter_application_1/core/Providers/garage_provider.dart';
import 'package:flutter_application_1/screens/comentariosGarage.dart';
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

  const GarageDetailDialog({
    super.key,
    required this.id,
    required this.location,
    required this.name,
    required this.imagePath,
    required this.details,
    required this.valorHora,
    required this.valorFraccion,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puntajeAsync = ref.watch(puntajeProvider(id));

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
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  details,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Valor hora: ${valorHora.toString()}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Fracción: ${valorFraccion.toString()}\n',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Text(
                  'Puntaje promedio:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
                puntajeAsync.when(
                  data: (puntaje) => Text(
                    puntaje > 0
                        ? '⭐ ${puntaje.toStringAsFixed(2)}'
                        : 'Aun sin puntaje',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text(
                    'Error: $error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ref.read(garageProvider.notifier).setGarage(
                          id,
                          location,
                          name,
                          imagePath,
                          details,
                          valorHora,
                          valorFraccion,
                        );
                    context.goNamed('ReservationSelectVehicule');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 24.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Reservar',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(garageProvider.notifier).setGarage(
                          id,
                          location,
                          name,
                          imagePath,
                          details,
                          valorHora,
                          valorFraccion,
                        );
                    context.goNamed(ComentariosGarage.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 24.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Comentarios',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
