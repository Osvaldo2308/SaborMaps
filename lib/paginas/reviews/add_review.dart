import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddReviewPage extends StatefulWidget {
  final String restaurantId; // ID del restaurante
  final String restaurantName; // Nombre del restaurante
  
  AddReviewPage({Key? key, required this.restaurantId, required this.restaurantName}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _reviewController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double _rating = 0; // Puntuación en estrellas

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _addReview() async {
    if (_reviewController.text.isEmpty || _rating == 0) return; // Verifica que la crítica y la puntuación sean válidas

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, inicie sesión para agregar una crítica.'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // No continuar si no hay usuario autenticado
    }

    // Añadir la crítica a la colección "reviews"
    await _firestore.collection('reviews').add({
      'restaurantId': widget.restaurantId, // ID del restaurante
      'review': _reviewController.text,
      'restaurantName': widget.restaurantName,
      'userId': user.uid,
      'rating': _rating, // Agregar la puntuación
      'timestamp': FieldValue.serverTimestamp(),
    });

    _reviewController.clear();
    _rating = 0; // Reiniciar la puntuación

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Crítica agregada exitosamente.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Crítica'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Muestra el nombre del restaurante
            Text(
              'Crítica para: ${widget.restaurantName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Selector de estrellas
            Text('Rating: ${_rating.toStringAsFixed(1)} ⭐'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0; // Las estrellas van de 1 a 5
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 20),

            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Escribe tu crítica',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addReview,
              child: Text('Agregar Crítica'),
            ),
          ],
        ),
      ),
    );
  }
}
