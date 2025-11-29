import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';

void main() {
  group('Modelo ParticipacionLiga - Pruebas', () {
    test('Constructor y valores obligatorios', () {
      final p = ParticipacionLiga(
        id: 'p1',
        idLiga: 'l1',
        idUsuario: 'u1',
        nombreEquipoFantasy: 'Equipo1',
        puntos: 100,
        fechaCreacion: 999,
        activo: true,
      );

      expect(p.id, 'p1');
      expect(p.idLiga, 'l1');
      expect(p.idUsuario, 'u1');
      expect(p.nombreEquipoFantasy, 'Equipo1');
      expect(p.puntos, 100);
      expect(p.fechaCreacion, 999);
      expect(p.activo, true);
    });

    test('toMap / fromMap', () {
      final p = ParticipacionLiga(
        id: 'p2',
        idLiga: 'l2',
        idUsuario: 'u2',
        nombreEquipoFantasy: 'TeamX',
        puntos: 55,
        fechaCreacion: 111,
        activo: false,
      );

      final m = p.aMapa();
      final c = ParticipacionLiga.desdeMapa('p2', m);

      expect(c.id, 'p2');
      expect(c.idLiga, 'l2');
      expect(c.idUsuario, 'u2');
      expect(c.nombreEquipoFantasy, 'TeamX');
      expect(c.puntos, 55);
      expect(c.fechaCreacion, 111);
      expect(c.activo, false);
    });

    test('copiarCon modifica solo lo necesario', () {
      final base = ParticipacionLiga(
        id: 'p3',
        idLiga: 'l3',
        idUsuario: 'u3',
        nombreEquipoFantasy: 'Base',
        puntos: 20,
        fechaCreacion: 222,
        activo: true,
      );

      final copia = base.copiarCon(
        nombreEquipoFantasy: 'Modificado',
        puntos: 999,
      );

      expect(copia.nombreEquipoFantasy, 'Modificado');
      expect(copia.puntos, 999);
      expect(copia.id, base.id);
      expect(copia.idLiga, base.idLiga);
    });

    test('Igualdad de modelos (sin operador ==)', () {
      final a = ParticipacionLiga(
        id: 'x',
        idLiga: '1',
        idUsuario: '2',
        nombreEquipoFantasy: 'A',
        puntos: 1,
        fechaCreacion: 10,
        activo: true,
      );

      final b = ParticipacionLiga(
        id: 'x',
        idLiga: '1',
        idUsuario: '2',
        nombreEquipoFantasy: 'A',
        puntos: 1,
        fechaCreacion: 10,
        activo: true,
      );

      expect(a == b, false);
      expect(a.aMapa(), b.aMapa());
    });
  });
}
