/*
  Archivo: prueba_servicio_equipos_test.dart
  Descripción:
    Prueba básica que valida que el servicio puede crearse sin errores.
    (Los tests efectivos requieren entorno Firebase real o mocks avanzados)
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos.dart';

void main() {
  test("ServicioEquipos puede instanciarse correctamente", () {
    final servicio = ServicioEquipos();
    expect(servicio, isA<ServicioEquipos>());
  });
}
