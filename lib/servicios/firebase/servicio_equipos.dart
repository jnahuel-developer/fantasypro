/*
  Archivo: servicio_equipos.dart
  Descripción:
    Servicio responsable de administrar la colección "equipos" en Firestore.
    Relación directa: cada equipo pertenece a una liga (idLiga).
    Permite crear, obtener, editar, activar, archivar y eliminar equipos.
  Dependencias:
    - cloud_firestore
    - modelos/equipo.dart
    - servicio_log.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioEquipos {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog log = ServicioLog();

  /// Nombre de la colección principal.
  static const String _coleccion = "equipos";

  /*
    Nombre: crearEquipo
    Descripción:
      Crea un equipo y lo almacena en Firestore.
    Entradas:
      - equipo (sin ID asignado)
    Salida:
      - Equipo con ID asignado por Firestore.
  */
  Future<Equipo> crearEquipo(Equipo equipo) async {
    try {
      final doc = await _db.collection(_coleccion).add(equipo.aMapa());
      final nuevoEquipo = equipo.copiarCon(id: doc.id);

      log.informacion("Equipo creado: ${nuevoEquipo.id}");
      return nuevoEquipo;
    } catch (e) {
      log.error("Error al crear equipo: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerEquiposDeLiga
    Descripción:
      Devuelve todos los equipos asociados a una liga por idLiga.
  */
  Future<List<Equipo>> obtenerEquiposDeLiga(String idLiga) async {
    try {
      final consulta = await _db
          .collection(_coleccion)
          .where('idLiga', isEqualTo: idLiga)
          .get();

      return consulta.docs
          .map((doc) => Equipo.desdeMapa(doc.id, doc.data()))
          .toList();
    } catch (e) {
      log.error("Error al obtener equipos de liga: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarEquipo
    Descripción:
      Actualiza un equipo existente.
  */
  Future<void> editarEquipo(Equipo equipo) async {
    try {
      await _db.collection(_coleccion).doc(equipo.id).update(equipo.aMapa());
      log.informacion("Equipo actualizado: ${equipo.id}");
    } catch (e) {
      log.error("Error al editar equipo: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarEquipo
    Descripción:
      Cambia estado activo=false.
  */
  Future<void> archivarEquipo(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({'activo': false});
      log.informacion("Equipo archivado: $id");
    } catch (e) {
      log.error("Error al archivar equipo: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarEquipo
    Descripción:
      Cambia estado activo=true.
  */
  Future<void> activarEquipo(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({'activo': true});
      log.informacion("Equipo activado: $id");
    } catch (e) {
      log.error("Error al activar equipo: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarEquipo
    Descripción:
      Elimina un equipo de forma permanente.
  */
  Future<void> eliminarEquipo(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();
      log.informacion("Equipo eliminado: $id");
    } catch (e) {
      log.error("Error al eliminar equipo: $e");
      rethrow;
    }
  }
}
