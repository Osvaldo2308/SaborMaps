import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserReviewsListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Obtén el usuario autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Si no hay un usuario autenticado, redirige a la página de inicio de sesión
      return Scaffold(
        appBar: AppBar(
          title: Text('Críticas del Usuario'),
        ),
        body: Center(child: Text('Por favor, inicie sesión.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text(
          'Mis Críticas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, // Cambia el color de la flecha de retroceso a blanco
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('userId', isEqualTo: user.uid) // Filtra solo las críticas del usuario autenticado
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            print('No hay críticas disponibles para el usuario: ${user.uid}');
            return Center(child: Text('No hay críticas disponibles.'));
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final reviewData = reviews[index];
              // final restaurantId = reviewData['restaurantId'];
              final restaurantName = reviewData['restaurantName'];
              final reviewText = reviewData['review'];
              final rating = reviewData['rating']?.toDouble() ?? 0;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
                    children: [
                      // Muestra el rating en forma de estrellas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center, // Centrar las estrellas
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < rating ? Icons.star : Icons.star_border,
                            color: Colors.yellow[600],
                          );
                        }),
                      ),
                      SizedBox(height: 10),
                      // Texto de la crítica
                      Text(
                        reviewText,
                        textAlign: TextAlign.center, // Centrar el texto
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      // Muestra el nombre del restaurante
                      Text(
                        'Restaurante: $restaurantName', // Usa el nombre del restaurante
                        textAlign: TextAlign.center, // Centrar el texto del nombre del restaurante
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
