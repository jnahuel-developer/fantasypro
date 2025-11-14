/*
  Archivo: prueba_logs_test.dart
  Descripción: Prueba básica del servicio de logs.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/servicios/servicio_log.dart';

void main() {
  test('El servicio de logs se instancia sin errores', () {
    final log = ServicioLog();
    expect(log, isNotNull);
  });
}
