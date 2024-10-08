import 'package:flutter/material.dart';
import 'menu.dart';

void main() {
  runApp(RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RestaurantMenuPage(),
    );
  }
}
