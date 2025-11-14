/*
  Archivo: main.dart
  Descripción: Punto de entrada principal de la aplicación FantasyPro. Aquí se
               inicializan los servicios esenciales del sistema, se detecta la
               plataforma (Web Desktop o Web Mobile) y se carga el tema y los
               textos correspondientes.
  Dependencias: servicio_detector_plataforma.dart, servicio_traducciones.dart,
                servicio_log.dart.
  Notas: Este archivo sólo contiene la estructura base del proyecto. La lógica
         será ampliada en las futuras features del Sprint 1.
*/

import 'package:flutter/material.dart';

void main() {
  runApp(const AplicacionFantasyPro());
}

class AplicacionFantasyPro extends StatelessWidget {
  const AplicacionFantasyPro({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Placeholder(),
    );
  }
}
