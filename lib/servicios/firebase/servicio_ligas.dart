/*
  Archivo: servicio_ligas.dart
  Descripción:
    Servicio que administra la colección "ligas" en Firestore.
    Permite crear, obtener, editar, activar, archivar y eliminar ligas.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ServicioLigas {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  /// Nombre de la colección principal.
  static const String _coleccion = "ligas";

  // ---------------------------------------------------------------------------
  // Crear liga
  // ---------------------------------------------------------------------------
  Future<Liga> crearLiga(Liga liga) async {
    try {
      final doc = await _db.collection(_coleccion).add(liga.aMapa());
      final nuevaLiga = liga.copiarCon(id: doc.id);

      _log.informacion("${TextosApp.LOG_LIGA_CREADA} ${nuevaLiga.id}");
      return nuevaLiga;
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_CREAR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener liga por ID
  // ---------------------------------------------------------------------------
  Future<Liga?> obtenerLiga(String id) async {
    try {
      final doc = await _db.collection(_coleccion).doc(id).get();

      if (!doc.exists) {
        _log.advertencia("${TextosApp.LOG_LIGA_NO_ENCONTRADA} $id");
        return null;
      }

      return Liga.desdeMapa(doc.id, doc.data()!);
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_OBTENER} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener solo ligas activas
  // ---------------------------------------------------------------------------
  Future<List<Liga>> obtenerLigasActivas() async {
    try {
      final consulta = await _db
          .collection(_coleccion)
          .where('activa', isEqualTo: true)
          .get();

      return consulta.docs.map((d) => Liga.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_LISTAR_ACTIVAS} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener todas las ligas
  // ---------------------------------------------------------------------------
  Future<List<Liga>> obtenerTodasLasLigas() async {
    try {
      final consulta = await _db.collection(_coleccion).get();

      return consulta.docs
          .map((doc) => Liga.desdeMapa(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_LISTAR_TODAS} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Editar liga
  // ---------------------------------------------------------------------------
  Future<void> editarLiga(Liga liga) async {
    try {
      await _db.collection(_coleccion).doc(liga.id).update(liga.aMapa());
      _log.informacion("${TextosApp.LOG_LIGA_EDITADA} ${liga.id}");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_EDITAR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Archivar liga
  // ---------------------------------------------------------------------------
  Future<void> archivarLiga(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({'activa': false});
      _log.informacion("${TextosApp.LOG_LIGA_ARCHIVADA} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_ARCHIVAR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Activar liga
  // ---------------------------------------------------------------------------
  Future<void> activarLiga(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({'activa': true});
      _log.informacion("${TextosApp.LOG_LIGA_ACTIVADA} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_ACTIVAR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar liga
  // ---------------------------------------------------------------------------
  Future<void> eliminarLiga(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();
      _log.informacion("${TextosApp.LOG_LIGA_ELIMINADA} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_ELIMINAR} $e");
      rethrow;
    }
  }
}
