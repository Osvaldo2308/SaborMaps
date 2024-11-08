import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_reviews_page.dart'; // Asegúrate de que la ruta sea correcta para UserReviewsPage

class AddReviewPage extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  AddReviewPage({Key? key, required this.restaurantId, required this.restaurantName}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _reviewController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  double _rating = 0;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _addReview() async {
    if (_reviewController.text.isEmpty || _rating == 0) return;

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, inicie sesión para agregar una crítica.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    await _firestore.collection('reviews').add({
      'restaurantId': widget.restaurantId,
      'review': _reviewController.text,
      'restaurantName': widget.restaurantName,
      'userId': user.uid,
      'rating': _rating,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _reviewController.clear();
    _rating = 0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Crítica agregada exitosamente.'),
        duration: Duration(seconds: 2),
      ),
    );

    // Redirige a la página de UserReviewsPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => UserReviewsPage(restaurantId: widget.restaurantId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Crítica', style: TextStyle(color: Colors.white)), // Título en blanco
        backgroundColor: Color(0xFF1B1F3B), // Color de fondo del AppBar
        iconTheme: IconThemeData(color: Colors.white), // Color blanco para la flecha
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Crítica para: ${widget.restaurantName}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
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
                      _rating = index + 1.0;
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
            SizedBox(height: 60),
            ElevatedButton(
              onPressed: _addReview,
              child: Text('Agregar Crítica', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF1B1F3B),
    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 100),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
            ),
          ],
        ),
      ),
    );
  }
}
