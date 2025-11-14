/*
  Archivo: tema_web_mobile.dart
  Descripción: Define el tema visual para la versión Web Mobile.
*/

import 'package:flutter/material.dart';

ThemeData obtenerTemaWebMobile() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 16)),
  );
}
