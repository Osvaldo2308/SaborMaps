import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserReviewsPage extends StatelessWidget {
  final String restaurantId; // Asegúrate de que el restaurantId se pase

  UserReviewsPage({Key? key, required this.restaurantId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text(
          'Críticas sobre el restaurante',
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
            .where('restaurantId', isEqualTo: restaurantId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay críticas disponibles.'));
          }

          final reviews = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final reviewData = reviews[index];
              final reviewText = reviewData['review'];
              final rating = reviewData['rating']?.toDouble() ?? 0;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                    crossAxisAlignment: CrossAxisAlignment.center, // Centrar horizontalmente
                    children: [
                      // Muestra el rating en forma de estrellas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
