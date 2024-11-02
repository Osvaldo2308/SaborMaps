import 'package:flutter/material.dart';
import 'user_reviews_page.dart'; // Importa la nueva página para ver críticas

class UserProfilePage extends StatelessWidget {
  final String name = 'Juan';
  final String lastName = 'Pérez';
  final int age = 28;
  final List<String> userReviews; // Lista de críticas recibidas

  UserProfilePage({Key? key, required this.userReviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text('Perfil de Usuario'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del usuario
            Text(
              'Nombre: $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Apellido: $lastName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Edad: $age',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Botón para ver críticas
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserReviewsPage(userReviews: userReviews), // Navega a la página de críticas
                  ),
                );
              },
              child: Text('Ver Críticas'),
            ),
          ],
        ),
      ),
    );
  }
}
