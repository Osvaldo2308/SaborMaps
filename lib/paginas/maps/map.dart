import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/iniciar_sesion.dart'; // Asegúrate de importar tu archivo de inicio de sesión

class PantallaEjemplo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Ejemplo'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Hola, Flutter!',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Cerrar sesión y redirigir a la pantalla de inicio de sesión
          try {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => IniciarSesion()),
            );
          } catch (e) {
            print('Error al cerrar sesión: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al cerrar sesión. Inténtalo de nuevo.')),
            );
          }
        },
        child: Icon(Icons.logout),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: PantallaEjemplo(),
    ));
