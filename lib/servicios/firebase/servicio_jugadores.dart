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
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

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

      _log.informacion("Jugador creado: ${nuevo.id}");
      return nuevo;
    } catch (e) {
      _log.error("Error al crear jugador: $e");
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

      _log.informacion("Listado de jugadores para equipo $idEquipo");

      return query.docs.map((d) => Jugador.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      _log.error("Error al obtener jugadores: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Editar jugador
  // ---------------------------------------------------------------------------
  Future<void> editarJugador(Jugador jugador) async {
    try {
      await _db.collection(_coleccion).doc(jugador.id).update(jugador.aMapa());
      _log.informacion("Jugador editado: ${jugador.id}");
    } catch (e) {
      _log.error("Error al editar jugador: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Archivar jugador (activo = false)
  // ---------------------------------------------------------------------------
  Future<void> archivarJugador(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: false});
      _log.informacion("Jugador archivado: $id");
    } catch (e) {
      _log.error("Error al archivar jugador: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Activar jugador (activo = true)
  // ---------------------------------------------------------------------------
  Future<void> activarJugador(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).update({_campoActivo: true});
      _log.informacion("Jugador activado: $id");
    } catch (e) {
      _log.error("Error al activar jugador: $e");
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Eliminar jugador
  // ---------------------------------------------------------------------------
  Future<void> eliminarJugador(String id) async {
    try {
      await _db.collection(_coleccion).doc(id).delete();
      _log.informacion("Jugador eliminado: $id");
    } catch (e) {
      _log.error("Error al eliminar jugador: $e");
      rethrow;
    }
  }
}
