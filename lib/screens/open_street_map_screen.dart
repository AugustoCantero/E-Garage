import 'dart:convert';
import 'package:flutter/material.dart';
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
  LatLng _initialPosition =
      LatLng(-34.6037, -58.3816); // Buenos Aires por defecto
  LatLng? _searchedPosition; // Coordenadas del destino buscado
  List<Marker> _markers = []; // Lista de marcadores
  List<LatLng> _routePoints = []; // Lista de puntos para la ruta

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
      // Solicitar permisos si no están concedidos
      status = await Permission.location.request();
    }

    if (status.isGranted) {
      // Los permisos fueron otorgados, obtener la ubicación
      _setInitialLocation();
    } else {
      // Mostrar un mensaje indicando que se necesita el permiso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Se necesita permiso de ubicación para mostrar tu posición')),
      );
    }
  }

  // Obtener la ubicación actual del usuario y centrar el mapa
  Future<void> _setInitialLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Centrar el mapa en la ubicación actual del usuario y agregar un marcador
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _markers = [
          Marker(
            width: 80.0,
            height: 80.0,
            point: _initialPosition,
            builder: (ctx) => Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 40.0,
            ),
          ),
        ];
        _mapController.move(
            _initialPosition, 15.0); // Mover el mapa a la ubicación del usuario
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
      final start =
          "${_initialPosition.longitude},${_initialPosition.latitude}";
      final end =
          "${_searchedPosition!.longitude},${_searchedPosition!.latitude}";

      final url = Uri.parse(
          'https://router.project-osrm.org/route/v1/driving/$start;$end?overview=full&geometries=geojson');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route = data['routes'][0]['geometry']['coordinates'];

        setState(() {
          _routePoints = route.map<LatLng>((coord) {
            return LatLng(coord[1], coord[0]); // Latitud, Longitud
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
              // Capa de marcadores
              if (_markers.isNotEmpty)
                MarkerLayer(
                  markers: _markers,
                ),
              // Capa de ruta
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue, // Color de la línea de la ruta
                    ),
                  ],
                ),
            ],
          ),
          // Cuadro de búsqueda de direcciones
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
                  // Campo de texto para la dirección
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
      // Botones flotantes
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _generateRoute, // Botón para generar la ruta
            backgroundColor: Colors.green,
            child: Icon(Icons.directions), // Ícono de "Ruta"
          ),
          SizedBox(height: 10), // Espaciado entre los botones
          FloatingActionButton(
            onPressed:
                _goToCurrentLocation, // Botón para ir a la ubicación actual
            backgroundColor: Colors.blue,
            child: Icon(Icons.my_location), // Ícono de "Mi ubicación"
          ),
          SizedBox(height: 10), // Espaciado entre los botones
          FloatingActionButton(
            onPressed: _goBack, // Botón para volver
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            child: Icon(Icons.arrow_back), // Ícono de "Volver"
          ),
        ],
      ),
    );
  }

  // Función para buscar la dirección usando la API de Nominatim
  Future<void> _searchAddress() async {
    final address = _addressController.text;

    if (address.isEmpty) {
      return;
    }

    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$address&format=json&addressdetails=1&limit=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lon = double.parse(data[0]['lon']);

        // Centrar el mapa en la ubicación obtenida
        setState(() {
          _searchedPosition = LatLng(lat, lon);
          _markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: _searchedPosition!,
              builder: (ctx) => Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          );
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
