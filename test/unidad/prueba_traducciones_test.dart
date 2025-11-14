/*
  Archivo: prueba_traducciones_test.dart
  Descripción: Validación básica de carga de textos para el servicio de traducciones.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/servicios/utilidades/servicio_traducciones.dart';

void main() {
  // Inicializa el binding necesario para que rootBundle funcione en tests
  TestWidgetsFlutterBinding.ensureInitialized();

  test("Carga correcta de archivo de textos", () async {
    final servicio = ServicioTraducciones();

    final mapa = await servicio.cargarTextos(
      'assets/configuracion/textos/web/desktop.txt',
    );

    expect(mapa.containsKey("TEXTO_BIENVENIDA"), true);
    expect(mapa["TEXTO_BIENVENIDA"], isNotEmpty);
  });
}
