import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/TestReservaSeleccionVehic.dart';

class GarageDetailDialog extends StatelessWidget {
  final String name;
  final String imagePath;
  final String details;

  const GarageDetailDialog({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(16.0),
        height: 400, // Altura del diálogo
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 200), // Imagen personalizada del garage
            SizedBox(height: 10),
            Text(
              'Características de $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              details, // Detalles personalizados del garage
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GestionVehiculosScreen()),
                );
              },
              child: Text('Reservar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
