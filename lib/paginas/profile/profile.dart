import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import '../reviews/user_review.dart'; // Asegúrate de importar la nueva página
=======
import '../reviews/user_reviews_page.dart';
import '../reviews/user_review.dart';
import '../login/iniciar_sesion.dart'; // Asegúrate de importar la página de inicio de sesión
>>>>>>> de7bfa72a131c44e7e834f5722b27c49db6973a0

class UserProfilePage extends StatelessWidget {
  final List<String> userReviews;
  final String restaurantId;
  final String restaurantName;

  UserProfilePage({
    Key? key,
    required this.userReviews,
    required this.restaurantId,
    required this.restaurantName,
  }) : super(key: key);

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => IniciarSesion()),
    );
  }

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
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'Cerrar sesión') {
                _signOut(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Cerrar sesión'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Nombre: $name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Correo: $email',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
<<<<<<< HEAD
            SizedBox(height: 30),


            // Botón para ver críticas del usuario
=======
            SizedBox(height: 40),
>>>>>>> de7bfa72a131c44e7e834f5722b27c49db6973a0
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserReviewsListPage(),
                  ),
                );
              },
              child: Text(
                'Ver Mis Críticas',
                style: TextStyle(color: Colors.white),
              ),
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
