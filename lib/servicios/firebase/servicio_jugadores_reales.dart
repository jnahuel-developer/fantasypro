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
import 'servicio_base_de_datos.dart';

class ServicioJugadoresReales {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logs para auditoría.
  final ServicioLog _log = ServicioLog();

  /// Cache temporal de nombres de equipos reales.
  final Map<String, String> _cacheEquipos = {};

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
      final doc = await _db
          .collection(ColFirebase.jugadoresReales)
          .add(jugador.aMapa());
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
      _log.informacion("Obteniendo jugadores reales del equipo $idEquipoReal");

      final query = await _db
          .collection(ColFirebase.jugadoresReales)
          .where(CamposFirebase.idEquipoReal, isEqualTo: idEquipoReal)
          .get();

      final nombreEquipo = await _obtenerNombreEquipoReal(idEquipoReal);

      return query.docs.map((d) {
        final jugador = JugadorReal.desdeMapa(d.id, d.data());
        return jugador.copiarCon(nombreEquipoReal: nombreEquipo);
      }).toList();
    } catch (e) {
      _log.error("Error al obtener jugadores reales: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorIds
    Descripción:
      Obtiene una lista de jugadores reales activos según sus IDs.
      Usa paginación para evitar límites de Firestore y cachea nombres de equipos.
    Entradas:
      - ids (List<String>): lista de IDs de jugadores reales.
    Salidas:
      - Lista de instancias JugadorReal.
  */
  Future<List<JugadorReal>> obtenerPorIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];

      final idsFiltrados = ids.toSet().toList(); // Quitar duplicados
      final List<JugadorReal> jugadores = [];

      _log.informacion(
        "Obteniendo jugadores reales por IDs (total=${idsFiltrados.length})",
      );

      for (var i = 0; i < idsFiltrados.length; i += 10) {
        final batch = idsFiltrados.skip(i).take(10).toList();

        final query = await _db
            .collection(ColFirebase.jugadoresReales)
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (var doc in query.docs) {
          final jugador = JugadorReal.desdeMapa(doc.id, doc.data());

          if (jugador.activo) {
            final nombreEquipo = await _obtenerNombreEquipoReal(
              jugador.idEquipoReal,
            );
            jugadores.add(jugador.copiarCon(nombreEquipoReal: nombreEquipo));
          }
        }
      }

      jugadores.sort((a, b) => a.id.compareTo(b.id)); // Orden alfabético por ID
      return jugadores;
    } catch (e) {
      _log.error("Error al obtener jugadores por IDs: $e");
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
          .collection(ColFirebase.jugadoresReales)
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
      await _db.collection(ColFirebase.jugadoresReales).doc(idJugador).update({
        CamposFirebase.activo: false,
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
      await _db.collection(ColFirebase.jugadoresReales).doc(idJugador).update({
        CamposFirebase.activo: true,
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
      await _db.collection(ColFirebase.jugadoresReales).doc(idJugador).delete();

      _log.informacion("Eliminar jugador real: $idJugador");
    } catch (e) {
      _log.error("Error al eliminar jugador real: $e");
      rethrow;
    }
  }

  /*
    Nombre: _obtenerNombreEquipoReal
    Descripción:
      Consulta Firestore (o cache) para obtener el nombre del equipo real.
    Entradas:
      - idEquipo (String): ID del equipo real.
    Salidas:
      - String con el nombre del equipo (o vacío si no existe).
  */
  Future<String> _obtenerNombreEquipoReal(String idEquipo) async {
    if (_cacheEquipos.containsKey(idEquipo)) {
      return _cacheEquipos[idEquipo]!;
    }

    try {
      _log.informacion("Consultando nombre del equipo real $idEquipo");

      final doc =
          await _db.collection(ColFirebase.equiposReales).doc(idEquipo).get();

      final nombre = doc.exists
          ? (doc.data()?[CamposFirebase.nombre] ?? "")
          : "";
      _cacheEquipos[idEquipo] = nombre;
      return nombre;
    } catch (e) {
      _log.error("Error al obtener nombre del equipo $idEquipo: $e");
      _cacheEquipos[idEquipo] = "";
      return "";
    }
  }
}
