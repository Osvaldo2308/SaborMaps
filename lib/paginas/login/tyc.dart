import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos y Condiciones'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Términos y Condiciones',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bienvenido/a a nuestra aplicación de recomendaciones de restaurantes. Al utilizar esta aplicación, aceptas los siguientes términos y condiciones:',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '1. Uso de la ubicación:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'La aplicación utilizará tu ubicación para mostrar restaurantes cercanos. Asegúrate de otorgar los permisos necesarios para una experiencia óptima.',
                      ),
                      SizedBox(height: 12),
                      Text(
                        '2. Publicación de comentarios:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Puedes publicar comentarios sobre los restaurantes que visitas. Sin embargo, estos serán anónimos y no se asociarán a tu identidad.',
                      ),
                      SizedBox(height: 12),
                      Text(
                        '3. Responsabilidad del contenido:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Nos reservamos el derecho de eliminar contenido ofensivo, inapropiado o que incumpla las políticas de uso de la aplicación.',
                      ),
                      SizedBox(height: 12),
                      Text(
                        '4. Propósito de la aplicación:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'La aplicación tiene un propósito exclusivamente informativo. No garantizamos la calidad o disponibilidad de los servicios de los restaurantes recomendados.',
                      ),
                      SizedBox(height: 12),
                      Text(
                        '5. Privacidad:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Los datos que recopilamos se utilizan únicamente para mejorar la experiencia de la aplicación. Consulta nuestra política de privacidad para más detalles.',
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Si tienes preguntas o inquietudes, puedes contactarnos a través de nuestro soporte técnico.',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Regresa a la pantalla anterior
                },
                child: Text('Aceptar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
