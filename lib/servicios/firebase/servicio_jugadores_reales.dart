/*
  Archivo: servicio_jugadores_reales.dart
  Descripción:
    Servicio dedicado a la administración CRUD de la colección "jugadores_reales".
    Permite crear, obtener, editar, activar, archivar y eliminar jugadores reales
    pertenecientes a un equipo real.

  Dependencias:
    - cloud_firestore
    - modelos/jugador_real.dart
    - servicio_log.dart

  Archivos que dependen de este:
    - Controladores y vistas que gestionen jugadores reales.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioJugadoresReales {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logs para auditoría.
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Métodos públicos
  // ---------------------------------------------------------------------------

  /*
    Nombre: crearJugadorReal
    Descripción:
      Crea un nuevo jugador real en la colección "jugadores_reales".
    Entradas:
      - jugador (JugadorReal): instancia a almacenar.
    Salidas:
      - Futuro que devuelve la instancia creada con el ID asignado.
  */
  Future<JugadorReal> crearJugadorReal(JugadorReal jugador) async {
    try {
      final doc = await _db.collection("jugadores_reales").add(jugador.aMapa());
      final nuevo = jugador.copiarCon(id: doc.id);

      _log.informacion("Crear jugador real: ${nuevo.id}");
      return nuevo;
    } catch (e) {
      _log.error("Error al crear jugador real: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorEquipoReal
    Descripción:
      Obtiene la lista de jugadores reales pertenecientes a un equipo real.
    Entradas:
      - idEquipoReal (String): identificador del equipo real.
    Salidas:
      - Futuro que devuelve una lista de JugadorReal.
  */
  Future<List<JugadorReal>> obtenerPorEquipoReal(String idEquipoReal) async {
    try {
      final query = await _db
          .collection("jugadores_reales")
          .where("idEquipoReal", isEqualTo: idEquipoReal)
          .get();

      _log.informacion("Listar jugadores reales de equipo: $idEquipoReal");

      return query.docs
          .map((d) => JugadorReal.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error al obtener jugadores reales: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarJugadorReal
    Descripción:
      Actualiza la información de un jugador real existente.
    Entradas:
      - jugador (JugadorReal): instancia con datos actualizados.
    Salidas:
      - Futuro void.
  */
  Future<void> editarJugadorReal(JugadorReal jugador) async {
    try {
      await _db
          .collection("jugadores_reales")
          .doc(jugador.id)
          .update(jugador.aMapa());

      _log.informacion("Editar jugador real: ${jugador.id}");
    } catch (e) {
      _log.error("Error al editar jugador real: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarJugadorReal
    Descripción:
      Marca un jugador real como inactivo (activo = false).
    Entradas:
      - idJugador (String): identificador del jugador real.
    Salidas:
      - Futuro void.
  */
  Future<void> archivarJugadorReal(String idJugador) async {
    try {
      await _db.collection("jugadores_reales").doc(idJugador).update({
        "activo": false,
      });

      _log.informacion("Archivar jugador real: $idJugador");
    } catch (e) {
      _log.error("Error al archivar jugador real: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarJugadorReal
    Descripción:
      Marca un jugador real como activo (activo = true).
    Entradas:
      - idJugador (String): identificador del jugador real.
    Salidas:
      - Futuro void.
  */
  Future<void> activarJugadorReal(String idJugador) async {
    try {
      await _db.collection("jugadores_reales").doc(idJugador).update({
        "activo": true,
      });

      _log.informacion("Activar jugador real: $idJugador");
    } catch (e) {
      _log.error("Error al activar jugador real: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarJugadorReal
    Descripción:
      Elimina definitivamente un jugador real de la colección.
    Entradas:
      - idJugador (String): identificador del jugador real.
    Salidas:
      - Futuro void.
  */
  Future<void> eliminarJugadorReal(String idJugador) async {
    try {
      await _db.collection("jugadores_reales").doc(idJugador).delete();

      _log.informacion("Eliminar jugador real: $idJugador");
    } catch (e) {
      _log.error("Error al eliminar jugador real: $e");
      rethrow;
    }
  }
}
