import 'package:flutter/material.dart';
import '../../paginas/maps/map_screen.dart';
class ReservationConfirmationPage extends StatelessWidget {
  final String restaurantName;
  final String selectedMenuItem;
  final String numPeople;
  final String date;
  final String time;
  final String comment;
  final List<String> additionalProducts; // Nuevo parámetro

  ReservationConfirmationPage({
    required this.restaurantName,
    required this.numPeople,
    required this.date,
    required this.time,
    required this.comment,
    required this.selectedMenuItem,
    required this.additionalProducts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text('Confirmación de Reservación'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reservación Exitosa',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            Text('Restaurante: $restaurantName', style: TextStyle(fontSize: 18)),
            Text('Alimentos: $selectedMenuItem', style: TextStyle(fontSize: 18)),
            // Mostrar productos adicionales solo si hay elementos seleccionados
            if (additionalProducts.isNotEmpty) 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text('Productos adicionales:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...additionalProducts.map((product) => Text(product, style: TextStyle(fontSize: 18))).toList(),
                ],
              ),
            Text('N° de Personas: $numPeople', style: TextStyle(fontSize: 18)),
            Text('Fecha: $date', style: TextStyle(fontSize: 18)),
            Text('Hora: $time', style: TextStyle(fontSize: 18)),
            if (comment.isNotEmpty) 
              Text('Comentario: $comment', style: TextStyle(fontSize: 18)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()), // Asegúrate de que MapScreen esté bien importado
                    (Route<dynamic> route) => false, // Remover todas las rutas anteriores
                  );// Regresa al menú principal
                },
                child: Text('OK'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1B1F3B),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
