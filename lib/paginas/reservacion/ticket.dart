import 'package:flutter/material.dart';

class ReservationConfirmationPage extends StatelessWidget {
  final String restaurantName;
  final String numPeople;
  final String date;
  final String time;
  final String comment;

  ReservationConfirmationPage({
    required this.restaurantName,
    required this.numPeople,
    required this.date,
    required this.time,
    required this.comment,
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
            Text('N° de Personas: $numPeople', style: TextStyle(fontSize: 18)),
            Text('Fecha: $date', style: TextStyle(fontSize: 18)),
            Text('Hora: $time', style: TextStyle(fontSize: 18)),
            if (comment.isNotEmpty) 
              Text('Comentario: $comment', style: TextStyle(fontSize: 18)),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/')); // Regresa al menú principal
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
