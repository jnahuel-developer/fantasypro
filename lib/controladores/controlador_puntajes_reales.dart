/*
  Archivo: controlador_puntajes_reales.dart
  Descripción:
    Controlador encargado de coordinar la obtención de jugadores reales
    y el almacenamiento de puntajes por FechaLiga.
  Dependencias:
    - controlador_equipos_reales.dart
    - controlador_jugadores_reales.dart
    - servicio_puntajes_reales.dart
    - puntaje_jugador_fecha.dart
    - jugador_real.dart
    - servicio_log.dart
  Archivos que dependen de este:
    - controlador_fechas.dart
*/

import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/modelos/puntaje_jugador_fecha.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/servicios/firebase/servicio_puntajes_reales.dart';
import 'package:fantasypro/controladores/controlador_equipos_reales.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';
import 'package:fantasypro/servicios/firebase/servicio_puntajes_reales.dart';

class ControladorPuntajesReales {
  /// Servicio para persistir puntajes reales.
  final ServicioPuntajesReales _servicioPuntajes = ServicioPuntajesReales();

  /// Controlador de equipos reales.
  final ControladorEquiposReales _controladorEquiposReales =
      ControladorEquiposReales();

  /// Controlador de jugadores reales.
  final ControladorJugadoresReales _controladorJugadoresReales =
      ControladorJugadoresReales();

  /// Logger interno.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: obtenerJugadoresPorEquipo
    Descripción:
      Obtiene todos los equipos reales activos de una liga y sus jugadores
      reales activos asociados.
    Entradas: idLiga (String)
    Salidas: Future<Map<String, List<JugadorReal>>>
  */
  Future<Map<String, List<JugadorReal>>> obtenerJugadoresPorEquipo(
    String idLiga,
  ) async {
    _log.informacion(
      "Obteniendo jugadores reales por equipo para liga $idLiga",
    );

    final Map<String, List<JugadorReal>> resultado = {};

    // Obtener equipos reales activos
    final equipos = await _controladorEquiposReales.obtenerPorLiga(idLiga);

    for (final equipo in equipos) {
      if (!equipo.activo) continue;

      final jugadores = await _controladorJugadoresReales.obtenerPorEquipoReal(
        equipo.id,
      );

      final jugadoresActivos = jugadores
          .where((j) => j.activo == true)
          .toList();

      resultado[equipo.id] = jugadoresActivos;
    }

    return resultado;
  }

  /*
    Nombre: guardarPuntajesDeFecha
    Descripción:
      Persiste los puntajes asignados a jugadores reales para una fecha.
      Evita duplicados consultando puntaje previo de cada jugador.
      Actualiza el puntaje si ya existe; lo crea si no existe.
    Entradas:
      - idLiga (String)
      - idFecha (String)
      - puntajesPorJugador (Map<String,int>) idJugadorReal -> puntaje
    Salidas: Future<void>
  */
  Future<void> guardarPuntajesDeFecha(
    String idLiga,
    String idFecha,
    Map<String, int> puntajesPorJugador,
  ) async {
    _log.informacion("Guardando puntajes para fecha $idFecha (Liga $idLiga)");

    final List<PuntajeJugadorFecha> listaFinal = [];
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Obtener todos los jugadores reales activos
    final mapaJugadores = await obtenerJugadoresPorEquipo(idLiga);
    final todosLosJugadores = mapaJugadores.values.expand((j) => j).toList();

    for (final entry in puntajesPorJugador.entries) {
      final idJugadorReal = entry.key;
      final puntaje = entry.value;

      // Validación de rango
      if (puntaje < 1 || puntaje > 10) {
        throw ArgumentError(
          "El puntaje del jugador real $idJugadorReal debe estar entre 1 y 10.",
        );
      }

      // Verificar que exista el jugador real activo
      final jugador = todosLosJugadores.firstWhere(
        (j) => j.id == idJugadorReal,
        orElse: () {
          throw Exception(
            "Jugador real no encontrado o no activo: $idJugadorReal",
          );
        },
      );

      // Verificar si ya existe un puntaje previo
      final existente = await _servicioPuntajes.obtenerPuntajeDeJugadorEnFecha(
        idFecha,
        idJugadorReal,
      );

      if (existente != null) {
        // Actualizar puntaje existente
        final actualizado = existente.copiarCon(
          puntuacion: puntaje,
          fechaCreacion: timestamp,
        );
        listaFinal.add(actualizado);
      } else {
        // Crear nuevo puntaje
        final nuevo = PuntajeJugadorFecha(
          id: "", // El servicio generará ID determinístico
          idFecha: idFecha,
          idLiga: idLiga,
          idEquipoReal: jugador.idEquipoReal,
          idJugadorReal: jugador.id,
          puntuacion: puntaje,
          fechaCreacion: timestamp,
        );
        listaFinal.add(nuevo);
      }
    }

    // Persistir la lista final sin duplicados
    await _servicioPuntajes.guardarPuntajesDeFecha(idLiga, idFecha, listaFinal);
  }

  /*
    Nombre: faltanPuntajes
    Descripción:
      Verifica si existen jugadores activos sin puntaje registrado para la fecha indicada.
    Entradas: idLiga (String), idFecha (String)
    Salidas: Future<bool>
  */
  Future<bool> faltanPuntajes(String idLiga, String idFecha) async {
    _log.informacion(
      "Verificando completitud de puntajes en fecha $idFecha (Liga $idLiga)",
    );

    // Jugadores activos requeridos
    final jugadoresMap = await obtenerJugadoresPorEquipo(idLiga);
    final jugadoresRequeridos = jugadoresMap.values
        .expand((e) => e)
        .map((e) => e.id)
        .toSet();

    // Puntajes existentes
    final puntajes = await _servicioPuntajes.obtenerPuntajesPorFecha(idFecha);
    final jugadoresConPuntaje = puntajes.map((p) => p.idJugadorReal).toSet();

    // Si falta alguno → true
    for (final idJugador in jugadoresRequeridos) {
      if (!jugadoresConPuntaje.contains(idJugador)) {
        return true;
      }
    }
    return false;
  }

  /*
    Nombre: obtenerMapaPorLigaYFecha
    Descripción:
      Recupera un mapa de puntajes reales de jugadores para una liga y fecha dadas.
      Devuelve un Map idJugadorReal → puntaje.
    Entradas:
      - idLiga: String — ID de la liga
      - idFecha: String — ID de la fecha
    Salidas:
      - Future<Map<String, int>>
  */
  Future<Map<String, int>> obtenerMapaPorLigaYFecha(
    String idLiga,
    String idFecha,
  ) async {
    _log.informacion(
      "Obteniendo mapa de puntajes reales para liga $idLiga, fecha $idFecha",
    );
    return await _servicioPuntajes.obtenerMapaPuntajesPorLigaYFecha(
      idLiga,
      idFecha,
    );
  }
}
