import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WidgetsPersonalizados/garage_marker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class OpenStreetMapScreen extends StatefulWidget {
  @override
  _OpenStreetMapScreenState createState() => _OpenStreetMapScreenState();
}

class _OpenStreetMapScreenState extends State<OpenStreetMapScreen> {
  late MapController _mapController;
  TextEditingController _addressController = TextEditingController();
  LatLng _initialPosition = LatLng(-34.6037, -58.3816); // Buenos Aires por defecto
  LatLng? _searchedPosition; // Coordenadas del destino buscado
  List<LatLng> _routePoints = []; // Lista de puntos para la ruta

  // Lista de garages
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
    _requestLocationPermission(); // Solicitar permisos de ubicación
    _mapController = MapController();
    _setInitialLocation(); // Intentamos centrar el mapa en la ubicación del usuario al iniciar
  }

  // Función para solicitar permisos
  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      _setInitialLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se necesita permiso de ubicación para mostrar tu posición')),
      );
    }
  }

  // Obtener la ubicación actual del usuario y centrar el mapa
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
  // Función para ir a la ubicación actual
  Future<void> _goToCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
    } catch (e) {
      print('Error al obtener la ubicación actual: $e');
    }
  }
  // Función que se ejecuta al presionar el botón "Generar ruta"
  Future<void> _generateRoute() async {
    if (_searchedPosition != null) {
      final start = "${_initialPosition.longitude},${_initialPosition.latitude}";
      final end = "${_searchedPosition!.longitude},${_searchedPosition!.latitude}";

      final url = Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/$start;$end?overview=full&geometries=geojson');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0]['geometry']['coordinates'];

        setState(() {
          _routePoints = route.map<LatLng>((coord) {
            return LatLng(coord[1], coord[0]);  // Latitud, Longitud
          }).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo generar la ruta')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se ha buscado ninguna dirección')),
      );
    }
  }

  // Función que se ejecuta al presionar el botón "Volver"
  void _goBack() {
    Navigator.of(context).pop();  // Volver a la pantalla anterior
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
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              // Agregar markers de garages
              MarkerLayer(
                markers: garageMarkers.map((garage) => garage.buildMarker(context)).toList(),
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
                      decoration: InputDecoration(
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
          FloatingActionButton(
            onPressed: _generateRoute,
            backgroundColor: Colors.green,
            child: Icon(Icons.directions),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _goToCurrentLocation,
            backgroundColor: Colors.blue,
            child: Icon(Icons.my_location),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _goBack,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ],
      ),
    );
  }

  // Función para buscar la dirección usando la API de Nominatim
  Future<void> _searchAddress() async {
    final address = _addressController.text;
    if (address.isEmpty) return;

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);
        setState(() {
          _searchedPosition = LatLng(lat, lon);
          _mapController.move(_searchedPosition!, 15.0);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró la dirección')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar la dirección')),
      );
    }
  }
}
