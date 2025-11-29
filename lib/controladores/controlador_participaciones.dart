/*
  Archivo: controlador_participaciones.dart
  Descripción:
    Lógica de negocio y validación para la gestión de participaciones
    de usuarios en una liga.
    Permite:
      - Crear participación
      - Listar por liga
      - Listar por usuario
      - Archivar / Activar
      - Eliminar
      - Editar
*/

import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ControladorParticipaciones {
  final ServicioParticipaciones _servicio = ServicioParticipaciones();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear participación
  // ---------------------------------------------------------------------------
  Future<ParticipacionLiga> crearParticipacion(
    String idLiga,
    String idUsuario,
    String nombreEquipoFantasy, {
    int puntos = 0,
  }) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (nombreEquipoFantasy.trim().isEmpty) {
      throw ArgumentError("El nombre del equipo fantasy no puede estar vacío.");
    }
    if (puntos < 0) {
      throw ArgumentError("Los puntos no pueden ser negativos.");
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final participacion = ParticipacionLiga(
      id: "",
      idLiga: idLiga,
      idUsuario: idUsuario,
      nombreEquipoFantasy: nombreEquipoFantasy.trim(),
      puntos: puntos,
      fechaCreacion: timestamp,
      activo: true,
    );

    _log.informacion(
      "Creando participación en liga $idLiga para usuario $idUsuario",
    );

    return await _servicio.crearParticipacion(participacion);
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones por liga
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorLiga(String idLiga) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El ID de la liga no puede estar vacío.");
    }

    _log.informacion("Listando participaciones de liga $idLiga");

    return await _servicio.obtenerPorLiga(idLiga);
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones por usuario
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorUsuario(String idUsuario) async {
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El ID del usuario no puede estar vacío.");
    }

    _log.informacion("Listando participaciones del usuario $idUsuario");

    return await _servicio.obtenerPorUsuario(idUsuario);
  }

  // ---------------------------------------------------------------------------
  // Archivar
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idParticipacion) async {
    _log.advertencia("Archivando participación $idParticipacion");
    await _servicio.archivarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Activar
  // ---------------------------------------------------------------------------
  Future<void> activar(String idParticipacion) async {
    _log.informacion("Activando participación $idParticipacion");
    await _servicio.activarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Eliminar
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idParticipacion) async {
    _log.error("Eliminando participación $idParticipacion");
    await _servicio.eliminarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Editar
  // ---------------------------------------------------------------------------
  Future<void> editar(ParticipacionLiga participacion) async {
    if (participacion.id.isEmpty) {
      throw ArgumentError("El ID de la participación no puede estar vacío.");
    }

    if (participacion.puntos < 0) {
      throw ArgumentError("Los puntos no pueden ser negativos.");
    }

    _log.informacion("Editando participación ${participacion.id}");

    await _servicio.editarParticipacion(participacion);
  }
}
