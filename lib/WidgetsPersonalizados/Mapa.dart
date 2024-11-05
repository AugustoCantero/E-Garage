import 'dart:convert';
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

  // Lista de garages con marcadores
  final List<GarageMarker> garageMarkers = [
    GarageMarker(
      location: LatLng(-34.6035711449937, -58.377600745441114),
      name: 'Garage Odeon',
      imagePath: 'assets/images/frenteOdeon.png',
      details: 'Ubicación: Centro, Precio: 10/hora, Abierto las 24 horas',
    ),
    GarageMarker(
      location: LatLng(-34.604554116354365, -58.37733976545885),
      name: 'Estacionamiento Sarmiento',
      imagePath: 'assets/images/garage2.png',
      details: 'Ubicación: Norte, Precio: 8/hora, Seguridad 24/7',
    ),
    GarageMarker(
      location: LatLng(-34.604300230161876, -58.37810419503197),
      name: 'Esmeralda 333',
      imagePath: 'assets/images/garage3.png',
      details: 'Ubicación: Sur, Precio: 7/hora, Servicio de lavado incluido',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _mapController = MapController();
    _setInitialLocation();
  }

  // Solicita permisos
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

  // Configura la ubicación inicial
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

  // Calcula la ruta entre A y B
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

  // Actualiza la ubicación de búsqueda y calcula la ruta
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

  // Función para buscar la dirección
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

  // Marca la ubicación actual en el mapa
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
    Navigator.of(context).pop(); // Volver a la pantalla anterior
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
                  ...garageMarkers
                      .map((garage) => garage.buildMarker(context))
                      ,
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
