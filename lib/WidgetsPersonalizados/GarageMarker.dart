import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/garageDetailDialog.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GarageMarker {
  final LatLng location;
  final String name;
  final String imagePath;
  final String details;
  final String id;
  final double valorHora;
  final double valorFraccion;

  GarageMarker({
    required this.id,
    required this.valorHora,
    required this.valorFraccion,
    required this.location,
    required this.name,
    required this.imagePath,
    required this.details,
  });
  Marker buildMarker(BuildContext context) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: location,
      builder: (ctx) => GestureDetector(
        onTap: () {
          showGarageDetailDialog(context);
        },
        child: const Icon(
          Icons.local_parking_sharp,
          color: Colors.black,
          size: 25.0,
        ),
      ),
    );
  }

  void showGarageDetailDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: GarageDetailDialog(
            id: id,
            location: location,
            name: name,
            imagePath: imagePath,
            details: details,
            valorHora: valorHora,
            valorFraccion: valorFraccion,
          ),
        );
      },
    );
  }

  GarageMarker copywith(
      {String? id,
      LatLng? location,
      String? imagePath,
      String? details,
      String? name,
      double? valorHora,
      double? valorFraccion}) {
    return GarageMarker(
        id: id ?? this.id,
        location: location ?? this.location,
        imagePath: imagePath ?? this.imagePath,
        details: details ?? this.details,
        name: name ?? this.name,
        valorHora: valorHora ?? this.valorHora,
        valorFraccion: valorFraccion ??
            this.valorFraccion); // Usa false si esAdmin es null
  }
}
