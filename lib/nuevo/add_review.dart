import 'package:flutter/material.dart';
import 'profile.dart'; // Asegúrate de importar UserProfilePage

class AddReviewPage extends StatefulWidget {
  final List<String> userReviews; // Añadir el parámetro para críticas

  AddReviewPage({Key? key, required this.userReviews}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
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
            TextField(
              controller: _reviewController,
              decoration: InputDecoration(
                labelText: 'Escribe tu crítica',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Añadir la crítica a la lista
                setState(() {
                  widget.userReviews.add(_reviewController.text);
                  _reviewController.clear(); // Limpiar el campo de texto
                });

                // Mostrar un mensaje de éxito
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Crítica agregada exitosamente.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Agregar Crítica'),
            ),
          ],
        ),
      ),
    );
  }
}
