import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/modelos/jugador.dart';

void main() {
  group('Modelo Jugador - Pruebas', () {
    test('Constructor y valores obligatorios', () {
      final jugador = Jugador(
        id: 'j1',
        idEquipo: 'e1',
        nombre: 'Jugador Test',
        posicion: 'Delantero',
        nacionalidad: 'ARG',
        dorsal: 10,
        fechaCreacion: 1111,
        activo: true,
      );

      expect(jugador.id, 'j1');
      expect(jugador.idEquipo, 'e1');
      expect(jugador.nombre, 'Jugador Test');
      expect(jugador.posicion, 'Delantero');
      expect(jugador.nacionalidad, 'ARG');
      expect(jugador.dorsal, 10);
      expect(jugador.fechaCreacion, 1111);
      expect(jugador.activo, true);
    });

    test('toMap / fromMap', () {
      final jugador = Jugador(
        id: 'j2',
        idEquipo: 'e2',
        nombre: 'Nombre',
        posicion: 'Medio',
        nacionalidad: 'URU',
        dorsal: 8,
        fechaCreacion: 2222,
        activo: false,
      );

      final mapa = jugador.aMapa();
      final convertido = Jugador.desdeMapa('j2', mapa);

      expect(convertido.id, 'j2');
      expect(convertido.idEquipo, 'e2');
      expect(convertido.nombre, 'Nombre');
      expect(convertido.posicion, 'Medio');
      expect(convertido.nacionalidad, 'URU');
      expect(convertido.dorsal, 8);
      expect(convertido.fechaCreacion, 2222);
      expect(convertido.activo, false);
    });

    test('Método copiarCon funciona correctamente', () {
      final jugador = Jugador(
        id: 'j3',
        idEquipo: 'e3',
        nombre: 'Original',
        posicion: 'Defensa',
        nacionalidad: 'CHI',
        dorsal: 5,
        fechaCreacion: 3333,
        activo: true,
      );

      final copia = jugador.copiarCon(nombre: 'Editado', dorsal: 9);

      expect(copia.nombre, 'Editado');
      expect(copia.dorsal, 9);
      expect(copia.id, jugador.id);
      expect(copia.posicion, jugador.posicion);
    });

    test('Igualdad de modelos', () {
      final a = Jugador(
        id: 'x',
        idEquipo: '1',
        nombre: 'A',
        posicion: 'P',
        nacionalidad: 'N',
        dorsal: 1,
        fechaCreacion: 10,
        activo: true,
      );

      final b = Jugador(
        id: 'x',
        idEquipo: '1',
        nombre: 'A',
        posicion: 'P',
        nacionalidad: 'N',
        dorsal: 1,
        fechaCreacion: 10,
        activo: true,
      );

      expect(a == b, false); // No tiene operador == personalizado
      expect(a.aMapa(), b.aMapa());
    });
  });
}
