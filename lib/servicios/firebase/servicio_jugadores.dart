/*
  Archivo: servicio_jugadores.dart
  Descripción:
    Servicio dedicado a la administración CRUD de la colección "jugadores".
    Incluye creación, edición, archivado, activación, eliminación y consulta
    de jugadores pertenecientes a un equipo.

  Dependencias:
    - cloud_firestore
    - modelos/jugador.dart
    - servicio_log.dart
    - textos_app.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ServicioJugadores {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Constantes internas: nombres de colección y campos
  // ---------------------------------------------------------------------------
  static const String _coleccion = "jugadores";

  static const String _campoIdEquipo = "idEquipo";
  static const String _campoActivo = "activo";

  // ---------------------------------------------------------------------------
  // Crear jugador
  // ---------------------------------------------------------------------------
  Future<Jugador> crearJugador(Jugador jugador) async {
    try {
      final doc = await _db.collection(_coleccion).add(jugador.aMapa());
      final nuevo = jugador.copiarCon(id: doc.id);

      _log.informacion("${TextosApp.LOG_JUGADORES_CREAR} ${nuevo.id}");
      return nuevo;
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Obtener todos los jugadores de un equipo
  // ---------------------------------------------------------------------------
  Future<List<Jugador>> obtenerJugadoresDeEquipo(String idEquipo) async {
    try {
      final query = await _db
          .collection(_coleccion)
          .where(_campoIdEquipo, isEqualTo: idEquipo)
          .get();

      _log.informacion("${TextosApp.LOG_JUGADORES_LISTAR} $idEquipo");

      return query.docs.map((d) => Jugador.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Editar jugador
  // ---------------------------------------------------------------------------
  Future<void> editarJugador(Jugador jugador) async {
    try {
      await _db.collection(_coleccion).doc(jugador.id).update(jugador.aMapa());
      _log.informacion("${TextosApp.LOG_JUGADORES_EDITAR} ${jugador.id}");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Archivar jugador (activo = false)
  // ---------------------------------------------------------------------------
  Future<void> archivarJugador(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: false});
      _log.informacion("${TextosApp.LOG_JUGADORES_ARCHIVAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Activar jugador (activo = true)
  // ---------------------------------------------------------------------------
  Future<void> activarJugador(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: true});
      _log.informacion("${TextosApp.LOG_JUGADORES_ACTIVAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar jugador
  // ---------------------------------------------------------------------------
  Future<void> eliminarJugador(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();
      _log.informacion("${TextosApp.LOG_JUGADORES_ELIMINAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }
}
