/*
  Archivo: servicio_alineaciones.dart
  Descripción:
    Servicio CRUD para alineaciones de usuario dentro de una liga.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioAlineaciones {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Constantes internas
  // ---------------------------------------------------------------------------
  static const String _coleccion = "alineaciones";

  static const String _campoIdLiga = "idLiga";
  static const String _campoIdUsuario = "idUsuario";
  static const String _campoActivo = "activo";

  // ---------------------------------------------------------------------------
  // Crear alineación
  // ---------------------------------------------------------------------------
  Future<Alineacion> crearAlineacion(Alineacion alineacion) async {
    try {
      final doc = await _db.collection(_coleccion).add(alineacion.aMapa());
      final nueva = alineacion.copiarCon(id: doc.id);

      _log.informacion("Crear alineación: ${nueva.id}");
      return nueva;
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener alineaciones por usuario en liga
  // ---------------------------------------------------------------------------
  Future<List<Alineacion>> obtenerPorUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    try {
      final consulta = await _db
          .collection(_coleccion)
          .where(_campoIdLiga, isEqualTo: idLiga)
          .where(_campoIdUsuario, isEqualTo: idUsuario)
          .get();

      _log.informacion(
        "Listar alineaciones de usuario $idUsuario en liga $idLiga",
      );

      return consulta.docs
          .map((d) => Alineacion.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Editar alineación
  // ---------------------------------------------------------------------------
  Future<void> editarAlineacion(Alineacion alineacion) async {
    try {
      await _db
          .collection(_coleccion)
          .doc(alineacion.id)
          .update(alineacion.aMapa());

      _log.informacion("Editar alineación: ${alineacion.id}");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Archivar
  // ---------------------------------------------------------------------------
  Future<void> archivarAlineacion(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: false});

      _log.informacion("Archivar alineación: $id");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Activar
  // ---------------------------------------------------------------------------
  Future<void> activarAlineacion(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: true});

      _log.informacion("Activar alineación: $id");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar
  // ---------------------------------------------------------------------------
  Future<void> eliminarAlineacion(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();

      _log.informacion("Eliminar alineación: $id");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }
}
