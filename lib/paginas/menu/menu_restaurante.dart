import 'package:flutter/material.dart';
import '../../menu/reservacion.dart'; // Importa el archivo de reservación para la navegación

class RestaurantMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text('Menu'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Lógica para regresar o salir
          },
        ),
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
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Image.asset(
                'assets/2.jpg',
                width: 200,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              'MENU',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.40,
                crossAxisSpacing: 70,
                mainAxisSpacing: 70,
                children: [
                  RestaurantMenuItem(
                    imageUrl: 'assets/1.jpg',
                    title: 'Alitas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(restaurantName: 'Alitas'),
                        ),
                      );
                    },
                  ),
                  RestaurantMenuItem(
                    imageUrl: 'assets/3.jpeg',
                    title: 'Micheladas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(restaurantName: 'Micheladas'),
                        ),
                      );
                    },
                  ),
                  RestaurantMenuItem(
                    imageUrl: 'assets/4.jpg',
                    title: 'Pizza',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(restaurantName: 'Pizza'),
                        ),
                      );
                    },
                  ),
                  RestaurantMenuItem(
                    imageUrl: 'assets/5.jpeg',
                    title: 'Nachos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(restaurantName: 'Nachos'),
                        ),
                      );
                    },
                  ),
                  RestaurantMenuItem(
                    imageUrl: 'assets/6.jpg',
                    title: 'Tacos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(restaurantName: 'Tacos'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantMenuItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Function onTap;

  const RestaurantMenuItem({
    required this.imageUrl,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        color: Color(0xFF1B1F3B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(imageUrl, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
