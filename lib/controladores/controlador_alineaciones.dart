/*
  Archivo: controlador_alineaciones.dart
  Descripción:
    Lógica de negocio y validación para gestión de alineaciones.
    Se añaden métodos para guardar plantel inicial y confirmar alineación (titulares + suplentes).
*/

import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/servicios/firebase/servicio_alineaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_fechas.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ControladorAlineaciones {
  final ServicioAlineaciones _servicio = ServicioAlineaciones();
  final ServicioParticipaciones _servicioPart = ServicioParticipaciones();
  final ServicioFechas _servicioFechas = ServicioFechas();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear alineación
  // ---------------------------------------------------------------------------
  Future<Alineacion> crearAlineacion(
    String idLiga,
    String idUsuario,
    String idEquipoFantasy,
    List<String> jugadoresSeleccionados, {
    String formacion = "4-4-2",
    int puntosTotales = 0,
    List<String> idsTitulares = const [],
    List<String> idsSuplentes = const [],
  }) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El ID de la liga no puede estar vacío.");
    }

    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El ID del usuario no puede estar vacío.");
    }

    if (idEquipoFantasy.trim().isEmpty) {
      throw ArgumentError("El ID del equipo fantasy no puede estar vacío.");
    }

    if (jugadoresSeleccionados.isEmpty) {
      throw ArgumentError("Debe seleccionar al menos un jugador.");
    }

    if (puntosTotales < 0) {
      throw ArgumentError("Los puntos no pueden ser negativos.");
    }

    if (!_validarFormacion(formacion)) {
      throw ArgumentError("Formación no válida: $formacion");
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final alineacion = Alineacion(
      id: "",
      idLiga: idLiga,
      idUsuario: idUsuario,
      idEquipoFantasy: idEquipoFantasy,
      jugadoresSeleccionados: jugadoresSeleccionados,
      formacion: formacion,
      puntosTotales: puntosTotales,
      fechaCreacion: timestamp,
      activo: true,
      idsTitulares: idsTitulares,
      idsSuplentes: idsSuplentes,
    );

    _log.informacion(
      "Creando alineación para usuario $idUsuario en liga $idLiga",
    );

    return await _servicio.crearAlineacion(alineacion);
  }

  // ---------------------------------------------------------------------------
  // Obtener alineaciones por usuario en liga
  // ---------------------------------------------------------------------------
  Future<List<Alineacion>> obtenerPorUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    if (idLiga.isEmpty) {
      throw ArgumentError("El ID de la liga no puede estar vacío.");
    }
    if (idUsuario.isEmpty) {
      throw ArgumentError("El ID del usuario no puede estar vacío.");
    }

    _log.informacion(
      "Listando alineaciones de usuario $idUsuario en liga $idLiga",
    );

    return await _servicio.obtenerPorUsuarioEnLiga(idLiga, idUsuario);
  }

  // ---------------------------------------------------------------------------
  // Archivar
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idAlineacion) async {
    _log.advertencia("Archivando alineación $idAlineacion");
    await _servicio.archivarAlineacion(idAlineacion);
  }

  // ---------------------------------------------------------------------------
  // Activar
  // ---------------------------------------------------------------------------
  Future<void> activar(String idAlineacion) async {
    _log.informacion("Activando alineación $idAlineacion");
    await _servicio.activarAlineacion(idAlineacion);
  }

  // ---------------------------------------------------------------------------
  // Eliminar
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idAlineacion) async {
    _log.error("Eliminando alineación $idAlineacion");
    await _servicio.eliminarAlineacion(idAlineacion);
  }

  // ---------------------------------------------------------------------------
  // Editar
  // ---------------------------------------------------------------------------
  Future<void> editar(Alineacion alineacion) async {
    if (alineacion.id.isEmpty) {
      throw ArgumentError("El ID de la alineación no puede estar vacío.");
    }

    if (alineacion.jugadoresSeleccionados.isEmpty) {
      throw ArgumentError("Debe seleccionar al menos un jugador.");
    }

    if (alineacion.puntosTotales < 0) {
      throw ArgumentError("Los puntos no pueden ser negativos.");
    }

    if (!_validarFormacion(alineacion.formacion)) {
      throw ArgumentError("Formación no válida: ${alineacion.formacion}");
    }

    _log.informacion("Editando alineación ${alineacion.id}");

    await _servicio.editarAlineacion(alineacion);
  }

  // ---------------------------------------------------------------------------
  // Validación FORMACIONES
  // ---------------------------------------------------------------------------
  bool _validarFormacion(String f) {
    return f == "4-4-2" || f == "4-3-3";
  }

  // ---------------------------------------------------------------------------
  // Guardar plantel inicial (15 jugadores, sin titulares/suplentes)
  // ---------------------------------------------------------------------------
  Future<Alineacion> guardarPlantelInicial(
    String idLiga,
    String idUsuario,
    String idEquipoFantasy,
    List<String> idsJugadoresSeleccionados,
    String formacion,
  ) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (idEquipoFantasy.trim().isEmpty) {
      throw ArgumentError("El idEquipoFantasy no puede estar vacío.");
    }
    if (!_validarFormacion(formacion)) {
      throw ArgumentError("Formación no válida: $formacion");
    }
    if (idsJugadoresSeleccionados.length != 15) {
      throw ArgumentError("Debe seleccionar exactamente 15 jugadores.");
    }

    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any((f) => f.activa && !f.cerrada);
    if (existeActiva) {
      throw Exception(
        "No se puede armar el plantel: la liga tiene una fecha activa.",
      );
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final alineacion = Alineacion(
      id: "",
      idLiga: idLiga,
      idUsuario: idUsuario,
      idEquipoFantasy: idEquipoFantasy,
      jugadoresSeleccionados: idsJugadoresSeleccionados,
      formacion: formacion,
      puntosTotales: 0,
      fechaCreacion: timestamp,
      activo: true,
      idsTitulares: const [],
      idsSuplentes: const [],
    );

    _log.informacion(
      "Guardando plantel inicial para usuario $idUsuario en liga $idLiga",
    );

    return await _servicio.crearAlineacion(alineacion);
  }

  // ---------------------------------------------------------------------------
  // Guardar alineación inicial (titulares y suplentes)
  // ---------------------------------------------------------------------------
  Future<Alineacion> guardarAlineacionInicial(
    String idLiga,
    String idUsuario,
    String idAlineacion,
    List<String> idsTitulares,
    List<String> idsSuplentes,
  ) async {
    if (idLiga.trim().isEmpty ||
        idUsuario.trim().isEmpty ||
        idAlineacion.trim().isEmpty) {
      throw ArgumentError(
        "Los campos idLiga, idUsuario y idAlineacion son obligatorios.",
      );
    }
    if (idsTitulares.length != 11) {
      throw ArgumentError("Debe seleccionar exactamente 11 titulares.");
    }
    if (idsSuplentes.length != 4) {
      throw ArgumentError("Debe seleccionar exactamente 4 suplentes.");
    }

    final alineaciones = await _servicio.obtenerPorUsuarioEnLiga(
      idLiga,
      idUsuario,
    );
    final alineacion = alineaciones.firstWhere(
      (a) => a.id == idAlineacion,
      orElse: () => throw Exception("Alineación no encontrada."),
    );

    final todos = {...idsTitulares, ...idsSuplentes};
    final setPlantel = alineacion.jugadoresSeleccionados.toSet();
    if (!setPlantel.containsAll(todos)) {
      throw ArgumentError(
        "Jugadores seleccionados no coinciden con el plantel.",
      );
    }

    final actualizada = alineacion.copiarCon(
      idsTitulares: idsTitulares,
      idsSuplentes: idsSuplentes,
    );

    await _servicio.editarAlineacion(actualizada);

    _log.informacion(
      "Buscando participación del usuario $idUsuario en liga $idLiga",
    );

    final participacion = await _servicioPart.obtenerParticipacion(
      idUsuario,
      idLiga,
    );

    if (participacion == null) {
      throw Exception("Participación no encontrada.");
    }

    _log.informacion("Participación encontrada: ${participacion.id}");

    final actualizadaPart = participacion.copiarCon(plantelCompleto: true);

    _log.informacion(
      "Marcando participación como plantelCompleto=true para ${participacion.id}",
    );

    await _servicioPart.editarParticipacion(actualizadaPart);

    _log.informacion("Participación actualizada correctamente.");

    return actualizada;
  }

  /*
    Nombre: obtenerAlineacionActivaDeUsuarioEnLiga
    Descripción:
      Recupera la alineación activa de un usuario en una liga. Si no hay activa,
      devuelve la más reciente (por fechaCreacion).
    Entradas:
      - idLiga: String — ID de la liga
      - idUsuario: String — ID del usuario
    Salidas:
      - Future<Alineacion?> — Alineación encontrada o null si ninguna
  */
  Future<Alineacion?> obtenerAlineacionActivaDeUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }

    _log.informacion(
      "Buscando alineación activa o más reciente para usuario $idUsuario en liga $idLiga",
    );

    final alineaciones = await _servicio.obtenerPorUsuarioEnLiga(
      idLiga,
      idUsuario,
    );
    if (alineaciones.isEmpty) return null;

    final alineacionesActivas = alineaciones.where((a) => a.activo).toList();
    if (alineacionesActivas.isNotEmpty) {
      final activa = alineacionesActivas.first;
      _log.informacion("Alineación activa encontrada: ${activa.id}");
      return activa;
    }

    // Si no hay activa, devolver la más reciente
    alineaciones.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    final reciente = alineaciones.first;
    _log.informacion(
      "No hay alineación activa — devolviendo la más reciente: ${reciente.id}",
    );
    return reciente;
  }
}
