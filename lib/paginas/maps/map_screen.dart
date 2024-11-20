import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:location/location.dart';
import '../menu/menu_restaurante.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  LocationData? _currentLocation;
  List<Marker> _markers = [];
  final Location location = Location();

  @override
  void initState() {
    super.initState();
    _initializeLocation(); // Verifica permisos y obtiene la ubicación inicial
  }

  // Método para verificar permisos y obtener la ubicación inicial
  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Verifica si el permiso de ubicación está concedido
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Obtén la ubicación actual del usuario
    final currentLocation = await location.getLocation();
    setState(() {
      _currentLocation = currentLocation;

      // Agrega un marcador en la ubicación actual del usuario
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          infoWindow: InfoWindow(
            title: 'Mi ubicación',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    // Inicia la obtención de restaurantes cercanos en segundo plano
    _fetchNearbyRestaurants();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentLocation != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          17.0,
        ),
      );
    }
  }

  // Obtiene los restaurantes cercanos usando la ubicación actual del usuario
  Future<void> _fetchNearbyRestaurants() async {
    if (_currentLocation == null) return;

    final apiKey = 'AIzaSyD62D5HVjjh-cTUeg9t_2OIqL7lV22mpns';
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentLocation!.latitude},${_currentLocation!.longitude}&radius=1500&type=restaurant&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        setState(() {
          _markers.addAll((json['results'] as List).map((place) {
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
          }).toList());
        });
      } else {
        print("Error al obtener datos de restaurantes: ${response.statusCode}");
      }
    } catch (error) {
      print("Error al cargar restaurantes cercanos: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurantes Cercanos'),
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
