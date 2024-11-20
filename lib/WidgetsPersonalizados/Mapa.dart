// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/GarageMarker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenStreetMapScreen extends StatefulWidget {
  const OpenStreetMapScreen({super.key});

  @override
  _OpenStreetMapScreenState createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  late MapController _mapController;
  final TextEditingController _addressController = TextEditingController();
  LatLng _initialPosition =
      LatLng(-34.6037, -58.3816); // Buenos Aires por defecto
  LatLng? _searchedPosition;
  List<LatLng> _routePoints = [];
  Marker? _currentLocationMarker;
  Marker? _searchResultMarker;
  final db = FirebaseFirestore.instance;
  List<GarageMarker> garageMarkers = [];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _mapController = MapController();
    _setInitialLocation();
    _obtenerGaragesDeBase();
  }

Future<void> _obtenerGaragesDeBase() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection('garages').get();

    List<GarageMarker> garages = snapshot.docs.map((doc) {
      var data = doc.data();
      var lat = data['latitude'];
      var lon = data['longitude'];

      if (lat != null && lon != null) {
        return GarageMarker(
          id: data['id'] ?? '',
          location: LatLng(lat, lon),
          name: data['nombre'] ?? 'Garage',
          imagePath: data['imagePath'] ?? '',
          details: data['direccion'] ?? '',
        );
      } else {
        return null;
      }
    }).whereType<GarageMarker>().toList();

    setState(() {
      garageMarkers = garages;
    });
  } catch (e) {
    print('Error al obtener garages de Firebase: $e');
  }
}

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      _setInitialLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Se necesita permiso de ubicación para mostrar tu posición')),
      );
    }
  }

  Future<void> _setInitialLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _mapController.move(_initialPosition, 15.0);
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _calculateRoute(LatLng start, LatLng end) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'];

      setState(() {
        _routePoints = route.map<LatLng>((coord) {
          return LatLng(coord[1], coord[0]); // lat, lon
        }).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al calcular la ruta')),
      );
    }
  }

  Future<void> _updateSearchLocation(double lat, double lon) async {
    final searchPosition = LatLng(lat, lon);
    setState(() {
      _searchedPosition = searchPosition;
      _searchResultMarker = Marker(
        width: 80.0,
        height: 80.0,
        point: searchPosition,
        builder: (ctx) => const Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 30.0,
        ),
      );
    });
    await _calculateRoute(_initialPosition, searchPosition);
  }

  Future<void> _searchAddress() async {
    final address = _addressController.text;
    if (address.isEmpty) return;

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        _mapController.move(LatLng(lat, lon), 15.0);
        await _updateSearchLocation(lat, lon);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró la dirección')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al buscar la dirección')),
      );
    }
  }

  Future<void> _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      LatLng currentPosition = LatLng(position.latitude, position.longitude);
      _mapController.move(currentPosition, 15.0);

      setState(() {
        _currentLocationMarker = Marker(
          width: 80.0,
          height: 80.0,
          point: currentPosition,
          builder: (ctx) => const Icon(
            Icons.my_location,
            color: Colors.blue,
            size: 30.0,
          ),
        );
      });
    } catch (e) {
      print('Error al obtener la ubicación actual: $e');
    }
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Lugar - OpenStreetMap'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _initialPosition,
              zoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_currentLocationMarker != null) _currentLocationMarker!,
                  if (_searchResultMarker != null) _searchResultMarker!,
                  ...garageMarkers.map((garage) => garage.buildMarker(context)),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        hintText: 'Buscar dirección',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _searchAddress,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildFloatingActionButton(
            icon: Icons.my_location,
            color: Colors.blue,
            onPressed: _goToCurrentLocation,
          ),
          const SizedBox(height: 10),
          _buildFloatingActionButton(
            icon: Icons.directions,
            color: Colors.green,
            onPressed: () => _calculateRoute(
                _initialPosition, _searchedPosition ?? _initialPosition),
          ),
          const SizedBox(height: 10),
          _buildFloatingActionButton(
            icon: Icons.arrow_back,
            color: Colors.white,
            iconColor: Colors.black,
            onPressed: _goBack,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    Color iconColor = Colors.white,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      shape: const CircleBorder(),
      child: Icon(icon, color: iconColor),
    );
  }
}
