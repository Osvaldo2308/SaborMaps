import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'package:flutter/services.dart'; // Para controlar las entradas de texto

class ReservationPage extends StatefulWidget {
  final String restaurantName;

  ReservationPage({required this.restaurantName});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  TextEditingController _numPeopleController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1F3B),
        title: Text(widget.restaurantName),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView( // Permite el desplazamiento
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 120,
              backgroundImage: AssetImage('assets/2.jpg'), // Imagen del restaurante
            ),
            SizedBox(height: 20),
            Text(
              'Reservación',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),

            // Campo de Número de Personas
            TextFormField(
              controller: _numPeopleController,
              decoration: InputDecoration(
                labelText: 'N° de Personas:',
                prefixIcon: Icon(Icons.people),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              maxLength: 3, // Limita a 3 dígitos
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Solo permite números
              ],
            ),
            SizedBox(height: 15),

            // Campo de Fecha (Selector de Calendario)
            TextFormField(
              controller: _dateController,
              readOnly: true, // Solo permite seleccionar desde el calendario
              decoration: InputDecoration(
                labelText: 'Fecha:',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(), // No permite fechas anteriores
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                  setState(() {
                    _dateController.text = formattedDate; // Muestra la fecha seleccionada
                  });
                }
              },
            ),
            SizedBox(height: 15),

            // Campo de Hora (Selector de Hora con AM/PM)
            TextFormField(
              controller: _timeController,
              readOnly: true, // Solo permite seleccionar desde el picker de hora
              decoration: InputDecoration(
                labelText: 'Hora:',
                prefixIcon: Icon(Icons.access_time),
                border: OutlineInputBorder(),
              ),
              onTap: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  String formattedTime = pickedTime.format(context); // Formato de 12 horas con AM/PM
                  setState(() {
                    _timeController.text = formattedTime; // Muestra la hora seleccionada
                  });
                }
              },
            ),
           SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Comentario:',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
                style: TextStyle(fontSize: 6),
            ),
            SizedBox(height: 20),

            // Botón de Reservar
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reservación realizada en ${widget.restaurantName}')),
                );
              },
              child: Text('Reservar'),
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
