import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart'; // Para obtener la ubicación actual
import '../menu/menu_restaurante.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LocationData? _currentLocation;  // Guardar la ubicación actual
  List<Marker> _markers = [];
  final Location location = Location();  // Instancia para obtener la ubicación

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();  // Obtener la ubicación actual al iniciar la app
  }

  // Obtener la ubicación del usuario
  Future<void> _fetchUserLocation() async {
    final currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;
      
      // Crear un marcador en la ubicación actual
    _markers.add(
      Marker(
        markerId: MarkerId('currentLocation'),  // ID único del marcador
        position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        infoWindow: InfoWindow(
          title: 'Mi ubicación',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),  // Cambiar color del marcador
      ),
    );  // Almacenar la ubicación actual
    });
    _fetchNearbyRestaurants();  // Luego de obtener la ubicación, buscar restaurantes cercanos
  }

  // Al crear el mapa, centrar en la ubicación actual
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      if (_currentLocation != null) {
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            17.0,
          ),
        );
      }
    });
  }

  // Función para obtener restaurantes cercanos a la ubicación actual del usuario
  Future<void> _fetchNearbyRestaurants() async {
    if (_currentLocation == null) return;

    final apiKey = 'AIzaSyD62D5HVjjh-cTUeg9t_2OIqL7lV22mpns';
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation!.latitude},${_currentLocation!.longitude}&radius=1500&type=restaurant&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    if (json['results'] != null) {
      setState(() {
        _markers = (json['results'] as List).map((place) {
          return Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(
              place['geometry']['location']['lat'],
              place['geometry']['location']['lng'],
            ),
            infoWindow: InfoWindow(
              title: place['name'],
              snippet: place['vicinity'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantMenuPage(
                      restaurantName: place['name'],
                      restaurantId: place['place_id'],
                    ),
                  ),
                );
              },
            ),
          );
        }).toList();
      });
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.center,
          children: [
            // Contorno de texto con el color especificado
            Text(
              'Restaurantes Cercanos',
              style: TextStyle(
                color: Color(0xFF1B1F3B),  // Contorno de color
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color(0xFF1B1F3B), // Color del contorno
                  ),
                ],
              ),
            ),
            // Texto principal blanco con contorno
            Text(
              'Restaurantes Cercanos',
              style: TextStyle(
                color: Colors.white,  // Texto blanco
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF1B1F3B),  // Fondo del AppBar
        elevation: 0,  // Eliminar sombra
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!.latitude!,
                  _currentLocation!.longitude!,
                ),
                zoom: 17.0,
              ),
              markers: Set<Marker>.of(_markers),
            ),
    );
  }
}
