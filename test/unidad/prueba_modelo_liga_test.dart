/*
  Archivo: prueba_modelo_liga_test.dart
  Descripción:
    Pruebas unitarias del modelo Liga para validar serialización,
    deserialización y métodos auxiliares.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/modelos/liga.dart';

void main() {
  group('Modelo Liga - Pruebas', () {
    test('Serialización y deserialización básica', () {
      final ligaOriginal = Liga(
        id: 'abc123',
        nombre: 'Liga Pro',
        temporada: '2024/2025',
        descripcion: 'Competencia de prueba',
        fechaCreacion: 1234567890,
        activa: true,
      );

      final mapa = ligaOriginal.aMapa();
      final ligaConvertida = Liga.desdeMapa('abc123', mapa);

      expect(ligaConvertida.nombre, 'Liga Pro');
      expect(ligaConvertida.temporada, '2024/2025');
      expect(ligaConvertida.descripcion, 'Competencia de prueba');
      expect(ligaConvertida.fechaCreacion, 1234567890);
      expect(ligaConvertida.activa, true);
    });

    test('Método copiarCon modifica solo lo necesario', () {
      final ligaBase = Liga(
        id: 'id1',
        nombre: 'Liga Base',
        temporada: '2024',
        descripcion: 'Desc',
        fechaCreacion: 1111,
        activa: true,
      );

      final ligaNueva = ligaBase.copiarCon(nombre: 'Liga Editada');

      expect(ligaNueva.nombre, 'Liga Editada');
      expect(ligaNueva.temporada, ligaBase.temporada);
      expect(ligaNueva.id, ligaBase.id);
    });
  });
}
