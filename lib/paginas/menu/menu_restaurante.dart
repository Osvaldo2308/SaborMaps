import 'package:flutter/material.dart';
import '../menu/reservacion.dart';
import '../profile/profile.dart';
import '../reviews/add_review.dart';
import '../reviews/user_reviews_page.dart';

class RestaurantMenuPage extends StatelessWidget {
  final String restaurantName;
  final String restaurantId;
  final List<String> userReviews = [];

  RestaurantMenuPage({required this.restaurantName, required this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text(
          '$restaurantName Menu',
          style: TextStyle(color: Colors.white),
          ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfilePage(
                  userReviews: userReviews, // Asegúrate de que aquí se pase la lista de críticas
                  restaurantId: restaurantId,
                  restaurantName: restaurantName, // Pasa también el restaurantId
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF06141B), Color(0xFF11212D), Color(0xFF253745)],
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
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  RestaurantMenuItem(
                    imageUrl: 'assets/1.jpg',
                    title: 'Alitas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationPage(restaurantName: restaurantName,
                          selectedMenuItem:'Alitas'),
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
                          builder: (context) => ReservationPage(restaurantName:restaurantName,
                          selectedMenuItem:'Micheladas' ),
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
                          builder: (context) => ReservationPage(restaurantName: restaurantName,
                          selectedMenuItem: 'Pizza'),
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
                          builder: (context) => ReservationPage(restaurantName: restaurantName,
                          selectedMenuItem: 'Nachos'),
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
                          builder: (context) => ReservationPage(restaurantName: restaurantName,
                          selectedMenuItem: 'Tacos'),
                        ),
                      );
                    },
                  ),
                  // Agrega más items si es necesario
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addReview',
            backgroundColor: Colors.green,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReviewPage(restaurantId: restaurantId,
                  restaurantName: restaurantName,),
                ),
              );
            },
            child: Icon(Icons.add_comment),
            tooltip: 'Agregar Crítica',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'viewReviews',
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserReviewsPage(restaurantId: restaurantId,
                  ),
                ),
              );
            },
            child: Icon(Icons.reviews),
            tooltip: 'Ver Críticas',
          ),
        ],
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

class RestaurantReviewsPage extends StatelessWidget {
  final List<String> userReviews;

  RestaurantReviewsPage({required this.userReviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text('Críticas de Restaurantes'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: userReviews.isEmpty
            ? Center(
                child: Text(
                  'No hay críticas disponibles',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: userReviews.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Color(0xFF253745),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        userReviews[index],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
      ),
      backgroundColor: Color(0xFF06141B),
    );
  }
}
