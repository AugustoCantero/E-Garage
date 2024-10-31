import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GarageDetailDialog extends StatelessWidget {
  final String name;
  final String imagePath;
  final String details;

  const GarageDetailDialog({
    super.key,
    required this.name,
    required this.imagePath,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo semi-transparente para dar efecto de modal
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(), // Cerrar el diálogo al tocar fuera del cuadro
            child: Container(
              color: Colors.black.withOpacity(0.5), // Fondo semi-transparente
            ),
          ),
        ),
        // Contenedor flotante en el centro
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5, // Ancho del 80% de la pantalla
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imagePath, height: 150, fit: BoxFit.cover),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black, decoration: TextDecoration.none),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  details,
                  textAlign: TextAlign.center,
                  style: const TextStyle( fontSize: 16, color:Colors.black54, decoration: TextDecoration.none),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      context.goNamed('ReservationSelectVehicule'); // Navegar a `vehiculosUsuario`
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),  
                    ),
                    child: const Text('Reservar', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}