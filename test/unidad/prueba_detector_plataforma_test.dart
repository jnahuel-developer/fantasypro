/*
  Archivo: prueba_detector_plataforma_test.dart
  Descripción: Pruebas unitarias del servicio de detección de plataforma.
*/

import 'package:fantasypro/servicios/utilidades/servicio_detector_plataforma.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final detector = ServicioDetectorPlataforma();

  test('Detectar modo escritorio correctamente', () {
    expect(detector.esEscritorio(1200), true);
  });

  test('Detectar modo móvil correctamente', () {
    expect(detector.esMovil(500), true);
  });
}
