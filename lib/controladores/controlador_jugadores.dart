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
    String nacionalidad = "",
    int dorsal = 0,
  }) async {
    if (idEquipo.isEmpty) {
      throw ArgumentError("El idEquipo no puede estar vacío.");
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del jugador no puede estar vacío.");
    }

    if (posicion.trim().isEmpty) {
      throw ArgumentError("La posición del jugador no puede estar vacía.");
    }

    if (dorsal < 0) {
      throw ArgumentError("El dorsal no puede ser negativo.");
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

    _log.informacion("Creando jugador en equipo $idEquipo: ${jugador.nombre}");

    return await _servicio.crearJugador(jugador);
  }

  // ---------------------------------------------------------------------------
  // Obtener jugadores por equipo
  // ---------------------------------------------------------------------------
  Future<List<Jugador>> obtenerPorEquipo(String idEquipo) async {
    if (idEquipo.isEmpty) {
      throw ArgumentError("El idEquipo no puede estar vacío.");
    }

    _log.informacion("Solicitando jugadores del equipo $idEquipo");
    return await _servicio.obtenerJugadoresDeEquipo(idEquipo);
  }

  // ---------------------------------------------------------------------------
  // Archivar jugador
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idJugador) async {
    _log.advertencia("Archivando jugador $idJugador");
    await _servicio.archivarJugador(idJugador);
  }

  // ---------------------------------------------------------------------------
  // Activar jugador
  // ---------------------------------------------------------------------------
  Future<void> activar(String idJugador) async {
    _log.informacion("Activando jugador $idJugador");
    await _servicio.activarJugador(idJugador);
  }

  // ---------------------------------------------------------------------------
  // Eliminar jugador
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idJugador) async {
    _log.error("Eliminando jugador $idJugador");
    await _servicio.eliminarJugador(idJugador);
  }

  // ---------------------------------------------------------------------------
  // Editar jugador
  // ---------------------------------------------------------------------------
  Future<void> editar(Jugador jugador) async {
    if (jugador.nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del jugador no puede estar vacío.");
    }

    if (jugador.posicion.trim().isEmpty) {
      throw ArgumentError("La posición del jugador no puede estar vacía.");
    }

    if (jugador.dorsal < 0) {
      throw ArgumentError("El dorsal no puede ser negativo.");
    }

    _log.informacion("Editando jugador ${jugador.id}");
    await _servicio.editarJugador(jugador);
  }
}
