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

  Archivos que dependen de este archivo:
    - Controladores y vistas relacionados al plantel fantasy del usuario
    - Flujos de armado de equipo y administración de plantilla
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ServicioJugadores {
  /// Instancia de Firestore para operaciones en la colección "jugadores".
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logs para registrar eventos y errores.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearJugador
    Descripción:
      Crea un nuevo jugador en la colección "jugadores".
    Entradas:
      - jugador (Jugador): instancia a almacenar.
    Salidas:
      - Future<Jugador>: instancia creada con ID asignado.
  */
  Future<Jugador> crearJugador(Jugador jugador) async {
    try {
      final doc = await _db.collection("jugadores").add(jugador.aMapa());
      final nuevo = jugador.copiarCon(id: doc.id);

      _log.informacion("${TextosApp.LOG_JUGADORES_CREAR} ${nuevo.id}");
      return nuevo;
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerJugadoresDeEquipo
    Descripción:
      Obtiene todos los jugadores asociados a un equipo dado.
    Entradas:
      - idEquipo (String): identificador del equipo.
    Salidas:
      - Future<List<Jugador>>: lista de jugadores encontrados.
  */
  Future<List<Jugador>> obtenerJugadoresDeEquipo(String idEquipo) async {
    try {
      final query = await _db
          .collection("jugadores")
          .where("idEquipo", isEqualTo: idEquipo)
          .get();

      _log.informacion("${TextosApp.LOG_JUGADORES_LISTAR} $idEquipo");

      return query.docs.map((d) => Jugador.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: editarJugador
    Descripción:
      Actualiza los datos de un jugador existente en Firestore.
    Entradas:
      - jugador (Jugador): instancia con datos actualizados.
    Salidas:
      - Future<void>
  */
  Future<void> editarJugador(Jugador jugador) async {
    try {
      await _db.collection("jugadores").doc(jugador.id).update(jugador.aMapa());
      _log.informacion("${TextosApp.LOG_JUGADORES_EDITAR} ${jugador.id}");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarJugador
    Descripción:
      Marca un jugador como inactivo (activo = false).
    Entradas:
      - id (String): identificador del jugador.
    Salidas:
      - Future<void>
  */
  Future<void> archivarJugador(String id) async {
    try {
      await _db.collection("jugadores").doc(id).update({"activo": false});
      _log.informacion("${TextosApp.LOG_JUGADORES_ARCHIVAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: activarJugador
    Descripción:
      Marca un jugador como activo (activo = true).
    Entradas:
      - id (String): identificador del jugador.
    Salidas:
      - Future<void>
  */
  Future<void> activarJugador(String id) async {
    try {
      await _db.collection("jugadores").doc(id).update({"activo": true});
      _log.informacion("${TextosApp.LOG_JUGADORES_ACTIVAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarJugador
    Descripción:
      Elimina definitivamente un jugador de Firestore.
    Entradas:
      - id (String): identificador del jugador.
    Salidas:
      - Future<void>
  */
  Future<void> eliminarJugador(String id) async {
    try {
      await _db.collection("jugadores").doc(id).delete();
      _log.informacion("${TextosApp.LOG_JUGADORES_ELIMINAR} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_JUGADORES_ERROR} $e");
      rethrow;
    }
  }
}
