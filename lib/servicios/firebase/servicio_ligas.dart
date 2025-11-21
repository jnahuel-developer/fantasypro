/*
  Archivo: servicio_ligas.dart
  Descripción:
    Servicio responsable de administrar la colección "ligas" en Firebase Firestore.
    Permite crear, editar, recuperar y archivar ligas.
  Dependencias:
    - cloud_firestore
    - modelos/liga.dart
    - servicio_log.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioLigas {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog log = ServicioLog();

  /// Nombre de la colección principal.
  static const String _coleccion = "ligas";

  /*
    Nombre: crearLiga
    Descripción:
      Crea una nueva liga y la almacena en Firestore.
    Entradas:
      - Liga (sin ID, ya que Firestore lo asigna automáticamente)
    Salida:
      - Liga con ID asignado.
  */
  Future<Liga> crearLiga(Liga liga) async {
    try {
      final doc = await _db.collection(_coleccion).add(liga.aMapa());
      final nuevaLiga = liga.copiarCon(id: doc.id);

      log.informacion("Liga creada: ${nuevaLiga.id}");
      return nuevaLiga;
    } catch (e) {
      log.error("Error al crear liga: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerLiga
    Descripción:
      Recupera una liga por ID.
    Entradas:
      - id (String)
    Salida:
      - Liga o null
  */
  Future<Liga?> obtenerLiga(String id) async {
    try {
      final doc = await _db.collection(_coleccion).doc(id).get();

      if (!doc.exists) {
        log.advertencia("Liga no encontrada: $id");
        return null;
      }

      return Liga.desdeMapa(doc.id, doc.data()!);
    } catch (e) {
      log.error("Error al obtener liga: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerLigasActivas
    Descripción:
      Lista todas las ligas activas.
  */
  Future<List<Liga>> obtenerLigasActivas() async {
    try {
      final consulta = await _db
          .collection(_coleccion)
          .where('activa', isEqualTo: true)
          .get();

      return consulta.docs.map((d) => Liga.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      log.error("Error al cargar ligas activas: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerTodasLasLigas
    Descripción:
      Devuelve todas las ligas registradas en la colección,
      tanto activas como archivadas.
    Entradas:
      - Ninguna.
    Salidas:
      - Lista de instancias Liga.
  */
  Future<List<Liga>> obtenerTodasLasLigas() async {
    try {
      final consulta = await _db.collection(_coleccion).get();

      return consulta.docs
          .map((doc) => Liga.desdeMapa(doc.id, doc.data()))
          .toList();
    } catch (e) {
      log.error("Error al obtener todas las ligas: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarLiga
    Descripción:
      Actualiza una liga existente.
  */
  Future<void> editarLiga(Liga liga) async {
    try {
      await _db.collection(_coleccion).doc(liga.id).update(liga.aMapa());
      log.informacion("Liga actualizada: ${liga.id}");
    } catch (e) {
      log.error("Error al editar liga: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarLiga
    Descripción:
      Cambia el estado activa=false (sin borrar nada).
  */
  Future<void> archivarLiga(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({'activa': false});
      log.informacion("Liga archivada: $id");
    } catch (e) {
      log.error("Error al archivar liga: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarLiga
    Descripción:
      Cambia el estado activa=true.
  */
  Future<void> activarLiga(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({'activa': true});
      log.informacion("Liga activada: $id");
    } catch (e) {
      log.error("Error al activar liga: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarLiga
    Descripción:
      Borra definitivamente una liga.
      Se usará con cuidado y solo para administración.
  */
  Future<void> eliminarLiga(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();
      log.informacion("Liga eliminada: $id");
    } catch (e) {
      log.error("Error al eliminar liga: $e");
      rethrow;
    }
  }
}
