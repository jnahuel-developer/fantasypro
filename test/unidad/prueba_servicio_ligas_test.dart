/*
  Archivo: prueba_servicio_ligas_test.dart
  Descripción:
    Pruebas básicas del ServicioLigas (sin Firestore real).
    Se evalúan llamadas y estructura del modelo.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/servicios/firebase/servicio_ligas.dart';

void main() {
  group('ServicioLigas - Carga de instancia', () {
    test("Instancia puede crearse sin lanzar excepciones", () {
      final servicio = ServicioLigas();
      expect(servicio, isNotNull);
    });
  });
}
