/*
  Archivo: servicio_equipos.dart
  Descripción:
    Servicio dedicado a la administración CRUD de la colección "equipos".
    Incluye creación, edición, archivado, activación, eliminación y consulta
    de equipos pertenecientes a una liga.

  Dependencias:
    - cloud_firestore
    - modelos/equipo.dart
    - servicio_log.dart
    - textos_app.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ServicioEquipos {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Constantes internas: nombres de colección y campos
  // ---------------------------------------------------------------------------

  static const String _coleccion = "equipos";

  static const String _campoIdLiga = "idLiga";
  static const String _campoActivo = "activo";

  // ---------------------------------------------------------------------------
  // Crear equipo
  // ---------------------------------------------------------------------------
  Future<Equipo> crearEquipo(Equipo equipo) async {
    try {
      final doc = await _db.collection(_coleccion).add(equipo.aMapa());
      final nuevo = equipo.copiarCon(id: doc.id);

      _log.informacion("${TextosApp.LOG_EQUIPOS_CREAR} ${nuevo.id}");
      return nuevo;
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPOS_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener todos los equipos de una liga
  // ---------------------------------------------------------------------------
  Future<List<Equipo>> obtenerEquiposDeLiga(String idLiga) async {
    try {
      final query = await _db
          .collection(_coleccion)
          .where(_campoIdLiga, isEqualTo: idLiga)
          .get();

      _log.informacion("${TextosApp.LOG_EQUIPOS_LISTAR} $idLiga");

      return query.docs.map((d) => Equipo.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPOS_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Editar equipo
  // ---------------------------------------------------------------------------
  Future<void> editarEquipo(Equipo equipo) async {
    try {
      await _db.collection(_coleccion).doc(equipo.id).update(equipo.aMapa());
      _log.informacion("${TextosApp.LOG_EQUIPOS_EDITAR} ${equipo.id}");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPOS_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Archivar equipo (activo = false)
  // ---------------------------------------------------------------------------
  Future<void> archivarEquipo(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: false});
      _log.informacion("${TextosApp.LOG_EQUIPOS_ARCHIVAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPOS_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Activar equipo (activo = true)
  // ---------------------------------------------------------------------------
  Future<void> activarEquipo(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: true});
      _log.informacion("${TextosApp.LOG_EQUIPOS_ACTIVAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPOS_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar equipo
  // ---------------------------------------------------------------------------
  Future<void> eliminarEquipo(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();
      _log.informacion("${TextosApp.LOG_EQUIPOS_ELIMINAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPOS_ERROR} $e");
      rethrow;
    }
  }
}
