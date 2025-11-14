/*
  Archivo: prueba_logs_test.dart
  Descripción: Prueba básica del servicio de logs.
*/

import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('El servicio de logs se instancia sin errores', () {
    final log = ServicioLog();
    expect(log, isNotNull);
  });
}
