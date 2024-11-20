import 'package:flutter/material.dart';
import 'login/iniciar_sesion.dart';
// import 'login/crear_usuario.dart';
import 'dart:async'; // Importa esta librería si decides usar el temporizador en el futuro

class PaginaCarga extends StatefulWidget {
  @override
  _PaginaCargaState createState() => _PaginaCargaState();
}

class _PaginaCargaState extends State<PaginaCarga> {
  double progreso = 0.0; // Inicializa el progreso
  late Timer _timer; // Define el temporizador

  @override
  void initState() {
    super.initState();
    iniciarTemporizador();
    // Configura el temporizador si decides usarlo en el futuro
    
    
  }
void iniciarTemporizador() {
    const duracion = Duration(seconds: 3); // Duración de 10 segundos
    _timer = Timer.periodic(Duration(milliseconds: 30), (Timer timer) {
      setState(() {
        if (progreso >= 1) {
          timer.cancel();
          // Navega a la siguiente pantalla
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => IniciarSesion()), 
          );
        } else {
          progreso += 0.01; // Incrementa el progreso
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancela el temporizador cuando el widget se destruye
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Color en la parte inferior
          Positioned.fill(
            top: MediaQuery.of(context).size.height * 0.3,
            bottom: 0,
            child: Container(
              color: Color(0xFF11212D), // Color inferior
            ),
          ),
          // Color oscuro en la parte superior
          Positioned.fill(
            top: 0,
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF06141B),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(MediaQuery.of(context).size.width * 0.5), // Radio para redondear la parte inferior
                ),
              ),
            ),
          ),
          // Imagen centrada verticalmente
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25, // Ajusta este valor para subir o bajar la imagen
            left: 0,
            right: 0,
            child: Image.asset(
              'images/icons.png', // Reemplaza con el nombre de tu imagen
              width: 350, // Ajusta el tamaño según sea necesario
            ),
          ),

          // Barra de progreso en la parte inferior
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: LinearProgressIndicator(
                value: progreso, // Valor del progreso actual
                backgroundColor: Colors.white24, // Color de fondo
                color: Color(0xFF9BA8AB), // Color de la barra de progreso
                minHeight: 2, // Altura de la barra de progreso
              ),
            ),
          ),
        ],
      ),
    );
  }
}
