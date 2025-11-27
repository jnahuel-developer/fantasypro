/*
  Archivo: controlador_jugadores.dart
  Descripción:
    Lógica de negocio y validación para la gestión de jugadores.
    Provee métodos para crear, listar por equipo, archivar, activar,
    eliminar y editar jugadores.
*/

import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/servicios/firebase/servicio_jugadores.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorJugadores {
  final ServicioJugadores _servicio = ServicioJugadores();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear jugador
  // ---------------------------------------------------------------------------
  Future<Jugador> crearJugador(
    String idEquipo,
    String nombre,
    String posicion, {
    String nacionalidad = TextosApp.JUGADOR_NACIONALIDAD_POR_DEFECTO,
    int dorsal = TextosApp.JUGADOR_DORSAL_POR_DEFECTO,
  }) async {
    if (idEquipo.isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_ID_EQUIPO_VACIO);
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_NOMBRE_VACIO);
    }

    if (posicion.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_POSICION_VACIO);
    }

    if (dorsal < 0) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_DORSAL_NEGATIVO);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final jugador = Jugador(
      id: "",
      idEquipo: idEquipo,
      nombre: nombre.trim(),
      posicion: posicion.trim(),
      nacionalidad: nacionalidad.trim(),
      dorsal: dorsal,
      fechaCreacion: timestamp,
      activo: true,
    );

    _log.informacion("${TextosApp.LOG_JUGADOR_CREANDO} $idEquipo");

    return await _servicio.crearJugador(jugador);
  }

  // ---------------------------------------------------------------------------
  // Obtener jugadores por equipo
  // ---------------------------------------------------------------------------
  Future<List<Jugador>> obtenerPorEquipo(String idEquipo) async {
    if (idEquipo.isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_ID_EQUIPO_VACIO);
    }

    _log.informacion("${TextosApp.LOG_JUGADOR_LISTANDO} $idEquipo");

    return await _servicio.obtenerJugadoresDeEquipo(idEquipo);
  }

  // ---------------------------------------------------------------------------
  // Archivar jugador
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idJugador) async {
    _log.advertencia("${TextosApp.LOG_JUGADOR_ARCHIVANDO} $idJugador");
    await _servicio.archivarJugador(idJugador);
  }

  // ---------------------------------------------------------------------------
  // Activar jugador
  // ---------------------------------------------------------------------------
  Future<void> activar(String idJugador) async {
    _log.informacion("${TextosApp.LOG_JUGADOR_ACTIVANDO} $idJugador");
    await _servicio.activarJugador(idJugador);
  }

  // ---------------------------------------------------------------------------
  // Eliminar jugador
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idJugador) async {
    _log.error("${TextosApp.LOG_JUGADOR_ELIMINANDO} $idJugador");
    await _servicio.eliminarJugador(idJugador);
  }

  // ---------------------------------------------------------------------------
  // Editar jugador
  // ---------------------------------------------------------------------------
  Future<void> editar(Jugador jugador) async {
    if (jugador.nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_NOMBRE_VACIO);
    }

    if (jugador.posicion.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_POSICION_VACIO);
    }

    if (jugador.dorsal < 0) {
      throw ArgumentError(TextosApp.ERR_JUGADOR_DORSAL_NEGATIVO);
    }

    _log.informacion("${TextosApp.LOG_JUGADOR_EDITANDO} ${jugador.id}");

    await _servicio.editarJugador(jugador);
  }
}
