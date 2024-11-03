import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../reviews/user_reviews_page.dart';
import '../reviews/user_review.dart'; // Asegúrate de importar la nueva página

class UserProfilePage extends StatelessWidget {
  final List<String> userReviews;
  final String restaurantId;
  final String restaurantName;

  UserProfilePage({Key? key, required this.userReviews, required this.restaurantId, required this.restaurantName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    String name = user?.displayName ?? 'Usuario';
    String email = user?.email ?? 'Correo no disponible';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text(
          'Perfil de Usuario',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre: $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Correo: $email',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Botón para ver críticas
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => UserReviewsPage(restaurantId: restaurantId),
            //       ),
            //     );
            //   },
            //   child: Text('Ver Críticas del Restaurante'),
            // ),

            // Botón para ver críticas del usuario
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserReviewsListPage(
                    ), // Navega a la nueva página
                  ),
                );
              },
              child: Text('Ver Mis Críticas'),
              /* Prueba de componentes */ 
            ),
          ],
        ),
      ),
    );
  }
}
