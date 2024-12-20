import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'paginas/pagina_carga.dart'; // Importa la pantalla de carga desde su ubicación
//import 'paginas/login/iniciar_sesion.dart'; // Importa la pantalla de inicio de sesión (cámbiala por la tuya)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializar Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(); // Inicialización de Firebase

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initialization, // Usa el Future correcto
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PaginaCarga(); // Muestra la página de carga mientras espera
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error al cargar Firebase'),
              ),
            );
          } else {
            // Redirigir a la pantalla de inicio de sesión después de la inicialización
            return PaginaCarga(); // Cambia esta pantalla por la tuya
          }
        },
      ),
    );
  }
}
