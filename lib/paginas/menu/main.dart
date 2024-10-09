import 'package:flutter/material.dart';
import '../../menu/map_screen.dart'; // Pantalla de Mapa
import '../../menu/main1.dart'; // Pantalla de Restaurante

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(), // Menú inicial
    );
  }
}

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text('Menú Principal'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Lógica para cuenta o perfil
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF06141B), // Color más claro
              Color(0xFF11212D), // Color intermedio
              Color(0xFF253745), // Color más fuerte
            ],
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Imagen en la parte superior
            Container(
              margin: EdgeInsets.all(10),
              child: Image.asset(
                'assets/2.jpg',
                width: 200,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            // Título del menú
            Text(
              'MENÚ PRINCIPAL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40),
            // Botón de Mapa
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                 // Fondo del botón
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              child: Text('Mapa', style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            // Botón de Restaurante
            ElevatedButton(
              style: ElevatedButton.styleFrom(
         // Fondo del botón
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RestaurantApp()),
                );
              },
              child: Text('Restaurante', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
