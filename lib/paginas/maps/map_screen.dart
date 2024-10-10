import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import '../menu/menu_restaurante.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(20.48280502380763, -99.22416117701225);
  List<Marker> _markers = [];

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _fetchNearbyRestaurants();
  }

  Future<void> _fetchNearbyRestaurants() async {
    final apiKey = 'AIzaSyD62D5HVjjh-cTUeg9t_2OIqL7lV22mpns';
    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=20.48280502380763,-99.22416117701225&radius=1500&type=restaurant&key=$apiKey';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    final json = jsonDecode(response.body);

    if (json['results'] != null) {
      setState(() {
        _markers = (json['results'] as List).map((place) {
          return Marker(
            markerId: MarkerId(place['place_id']),
            position: LatLng(place['geometry']['location']['lat'], place['geometry']['location']['lng']),
            infoWindow: InfoWindow(
              title: place['name'],
              snippet: place['vicinity'],
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=>RestaurantMenuPage (
                      restaurantName: place['name'], 
                ),
                ),
                );
              }
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
        title: Text('Restaurantes Cercanos'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
        markers: Set<Marker>.of(_markers),
      ),
    );
  }
}
