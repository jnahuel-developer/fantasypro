import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/modelos/alineacion.dart';

void main() {
  group('Modelo Alineacion - Pruebas', () {
    test('Constructor y valores obligatorios', () {
      final a = Alineacion(
        id: 'a1',
        idLiga: 'l1',
        idUsuario: 'u1',
        jugadoresSeleccionados: ['j1', 'j2'],
        formacion: '4-4-2',
        puntosTotales: 10,
        fechaCreacion: 123,
        activo: true,
      );

      expect(a.id, 'a1');
      expect(a.idLiga, 'l1');
      expect(a.idUsuario, 'u1');
      expect(a.jugadoresSeleccionados.length, 2);
      expect(a.formacion, '4-4-2');
      expect(a.puntosTotales, 10);
      expect(a.fechaCreacion, 123);
      expect(a.activo, true);
    });

    test('toMap / fromMap', () {
      final a = Alineacion(
        id: 'a2',
        idLiga: 'l2',
        idUsuario: 'u2',
        jugadoresSeleccionados: ['p1', 'p2', 'p3'],
        formacion: '4-3-3',
        puntosTotales: 22,
        fechaCreacion: 555,
        activo: false,
      );

      final m = a.aMapa();
      final c = Alineacion.desdeMapa('a2', m);

      expect(c.id, 'a2');
      expect(c.idLiga, 'l2');
      expect(c.idUsuario, 'u2');
      expect(c.jugadoresSeleccionados, ['p1', 'p2', 'p3']);
      expect(c.formacion, '4-3-3');
      expect(c.puntosTotales, 22);
      expect(c.fechaCreacion, 555);
      expect(c.activo, false);
    });

    test('copiarCon modifica solo lo necesario', () {
      final base = Alineacion(
        id: 'a3',
        idLiga: 'l3',
        idUsuario: 'u3',
        jugadoresSeleccionados: ['j1'],
        formacion: '3-5-2',
        puntosTotales: 5,
        fechaCreacion: 222,
        activo: true,
      );

      final copia = base.copiarCon(formacion: '5-3-2', puntosTotales: 999);

      expect(copia.formacion, '5-3-2');
      expect(copia.puntosTotales, 999);
      expect(copia.id, base.id);
      expect(copia.jugadoresSeleccionados, base.jugadoresSeleccionados);
    });

    test('Igualdad de modelos (sin operador ==)', () {
      final a1 = Alineacion(
        id: 'x',
        idLiga: '1',
        idUsuario: '2',
        jugadoresSeleccionados: ['a', 'b'],
        formacion: '4-4-2',
        puntosTotales: 10,
        fechaCreacion: 100,
        activo: true,
      );

      final a2 = Alineacion(
        id: 'x',
        idLiga: '1',
        idUsuario: '2',
        jugadoresSeleccionados: ['a', 'b'],
        formacion: '4-4-2',
        puntosTotales: 10,
        fechaCreacion: 100,
        activo: true,
      );

      expect(a1 == a2, false);
      expect(a1.aMapa(), a2.aMapa());
    });
  });
}
