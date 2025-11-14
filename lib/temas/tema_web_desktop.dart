/*
  Archivo: tema_web_desktop.dart
  Descripción: Define el tema visual para la versión Web Desktop.
*/

import 'package:flutter/material.dart';

ThemeData obtenerTemaWebDesktop() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueGrey[900],
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 18)),
  );
}
