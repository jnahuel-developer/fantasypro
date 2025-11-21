/*
  Archivo: prueba_modelo_equipo_test.dart
  Descripción:
    Pruebas unitarias para el modelo Equipo.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:fantasypro/modelos/equipo.dart';

void main() {
  test("El modelo Equipo se construye correctamente", () {
    final equipo = Equipo(
      id: "123",
      idLiga: "liga001",
      nombre: "Tiburones FC",
      descripcion: "Equipo de prueba",
      escudoUrl: "http://url.com/escudo.png",
      fechaCreacion: 111111111,
      activo: true,
    );

    expect(equipo.id, "123");
    expect(equipo.idLiga, "liga001");
    expect(equipo.nombre, "Tiburones FC");
    expect(equipo.descripcion, "Equipo de prueba");
    expect(equipo.escudoUrl, "http://url.com/escudo.png");
    expect(equipo.fechaCreacion, 111111111);
    expect(equipo.activo, true);
  });

  test("desdeMapa y aMapa funcionan correctamente", () {
    final datos = {
      'idLiga': 'liga001',
      'nombre': 'Ejemplo FC',
      'descripcion': 'Descripción test',
      'escudoUrl': '',
      'fechaCreacion': 222222222,
      'activo': false,
    };

    final equipo = Equipo.desdeMapa("abc", datos);

    expect(equipo.id, "abc");
    expect(equipo.idLiga, "liga001");
    expect(equipo.nombre, "Ejemplo FC");
    expect(equipo.activo, false);

    final mapa = equipo.aMapa();
    expect(mapa['nombre'], "Ejemplo FC");
    expect(mapa['idLiga'], "liga001");
  });

  test("copiarCon permite modificar solo los campos deseados", () {
    final original = Equipo(
      id: "id1",
      idLiga: "ligaX",
      nombre: "Original",
      descripcion: "Desc",
      escudoUrl: "",
      fechaCreacion: 333333333,
      activo: true,
    );

    final modificado = original.copiarCon(nombre: "Modificado");

    expect(modificado.nombre, "Modificado");
    expect(modificado.id, "id1");
    expect(modificado.idLiga, "ligaX");
  });
}
