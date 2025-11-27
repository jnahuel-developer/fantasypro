/*
  Archivo: servicio_participaciones.dart
  Descripción:
    Servicio dedicado a la administración CRUD de la colección "participaciones_liga".
    Permite crear, obtener, editar, activar, archivar y eliminar participaciones
    de usuarios dentro de una liga.

  Dependencias:
    - cloud_firestore
    - modelos/participacion_liga.dart
    - servicio_log.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioParticipaciones {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Constantes internas
  // ---------------------------------------------------------------------------

  static const String _coleccion = "participaciones_liga";

  static const String _campoIdLiga = "idLiga";
  static const String _campoIdUsuario = "idUsuario";
  static const String _campoActivo = "activo";

  // ---------------------------------------------------------------------------
  // Crear participación
  // ---------------------------------------------------------------------------
  Future<ParticipacionLiga> crearParticipacion(
    ParticipacionLiga participacion,
  ) async {
    try {
      final doc = await _db.collection(_coleccion).add(participacion.aMapa());
      final nueva = participacion.copiarCon(id: doc.id);

      _log.informacion("Crear participación: ${nueva.id}");
      return nueva;
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones de una liga
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorLiga(String idLiga) async {
    try {
      final consulta = await _db
          .collection(_coleccion)
          .where(_campoIdLiga, isEqualTo: idLiga)
          .get();

      _log.informacion("Listar participaciones de liga: $idLiga");

      return consulta.docs
          .map((d) => ParticipacionLiga.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones de un usuario en alguna liga
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorUsuario(String idUsuario) async {
    try {
      final consulta = await _db
          .collection(_coleccion)
          .where(_campoIdUsuario, isEqualTo: idUsuario)
          .get();

      _log.informacion("Listar participaciones del usuario: $idUsuario");

      return consulta.docs
          .map((d) => ParticipacionLiga.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Editar participación
  // ---------------------------------------------------------------------------
  Future<void> editarParticipacion(ParticipacionLiga participacion) async {
    try {
      await _db
          .collection(_coleccion)
          .doc(participacion.id)
          .update(participacion.aMapa());

      _log.informacion("Editar participación: ${participacion.id}");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Archivar participación (activo = false)
  // ---------------------------------------------------------------------------
  Future<void> archivarParticipacion(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: false});

      _log.informacion("Archivar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Activar participación (activo = true)
  // ---------------------------------------------------------------------------
  Future<void> activarParticipacion(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: true});

      _log.informacion("Activar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar participación
  // ---------------------------------------------------------------------------
  Future<void> eliminarParticipacion(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();

      _log.informacion("Eliminar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }
}
