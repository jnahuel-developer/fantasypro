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
import 'package:fantasypro/textos/textos_app.dart';

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
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_LIGA_VACIO);
    }

    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_USUARIO_VACIO);
    }

    if (idEquipoFantasy.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_EQUIPO_FANTASY_VACIO);
    }

    if (jugadoresSeleccionados.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_ALINEACIONES_ERROR_JUGADOR_REQUERIDO);
    }

    if (puntosTotales < 0) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_PUNTOS_NEGATIVOS);
    }

    if (!_validarFormacion(formacion)) {
      throw ArgumentError(
        TextosApp.CTRL_ALINEACIONES_ERROR_FORMACION_INVALIDA
            .replaceAll('{FORMACION}', formacion),
      );
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
      TextosApp.CTRL_ALINEACIONES_LOG_CREAR
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
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
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_LIGA_VACIO);
    }
    if (idUsuario.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_USUARIO_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_LISTAR_USUARIO_LIGA
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
    );

    return await _servicio.obtenerPorUsuarioEnLiga(idLiga, idUsuario);
  }

  // ---------------------------------------------------------------------------
  // Archivar
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idAlineacion) async {
    _log.advertencia(
      TextosApp.CTRL_ALINEACIONES_LOG_ARCHIVAR
          .replaceAll('{ALINEACION}', idAlineacion),
    );
    await _servicio.archivarAlineacion(idAlineacion);
  }

  // ---------------------------------------------------------------------------
  // Activar
  // ---------------------------------------------------------------------------
  Future<void> activar(String idAlineacion) async {
    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_ACTIVAR
          .replaceAll('{ALINEACION}', idAlineacion),
    );
    await _servicio.activarAlineacion(idAlineacion);
  }

  // ---------------------------------------------------------------------------
  // Eliminar
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idAlineacion) async {
    _log.error(
      TextosApp.CTRL_ALINEACIONES_LOG_ELIMINAR
          .replaceAll('{ALINEACION}', idAlineacion),
    );
    await _servicio.eliminarAlineacion(idAlineacion);
  }

  // ---------------------------------------------------------------------------
  // Editar
  // ---------------------------------------------------------------------------
  Future<void> editar(Alineacion alineacion) async {
    if (alineacion.id.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_ALINEACION_VACIO);
    }

    if (alineacion.jugadoresSeleccionados.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_ALINEACIONES_ERROR_JUGADOR_REQUERIDO);
    }

    if (alineacion.puntosTotales < 0) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_PUNTOS_NEGATIVOS);
    }

    if (!_validarFormacion(alineacion.formacion)) {
      throw ArgumentError(
        TextosApp.CTRL_ALINEACIONES_ERROR_FORMACION_INVALIDA
            .replaceAll('{FORMACION}', alineacion.formacion),
      );
    }

    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_EDITAR
          .replaceAll('{ALINEACION}', alineacion.id),
    );

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
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_LIGA_VACIO);
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_USUARIO_VACIO);
    }
    if (idEquipoFantasy.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_EQUIPO_FANTASY_VACIO);
    }
    if (!_validarFormacion(formacion)) {
      throw ArgumentError(
        TextosApp.CTRL_ALINEACIONES_ERROR_FORMACION_INVALIDA
            .replaceAll('{FORMACION}', formacion),
      );
    }
    if (idsJugadoresSeleccionados.length != 15) {
      throw ArgumentError(TextosApp.CTRL_ALINEACIONES_ERROR_PLANTEL_INICIAL);
    }

    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any((f) => f.activa && !f.cerrada);
    if (existeActiva) {
      throw Exception(TextosApp.CTRL_ALINEACIONES_ERROR_PLANTEL_CON_FECHA_ACTIVA);
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
      TextosApp.CTRL_ALINEACIONES_LOG_GUARDAR_PLANTEL
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
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
      throw ArgumentError(TextosApp.CTRL_ALINEACIONES_ERROR_CAMPOS_OBLIGATORIOS);
    }
    if (idsTitulares.length != 11) {
      throw ArgumentError(TextosApp.CTRL_ALINEACIONES_ERROR_TITULARES);
    }
    if (idsSuplentes.length != 4) {
      throw ArgumentError(TextosApp.CTRL_ALINEACIONES_ERROR_SUPLENTES);
    }

    final alineaciones = await _servicio.obtenerPorUsuarioEnLiga(
      idLiga,
      idUsuario,
    );
    final alineacion = alineaciones.firstWhere(
      (a) => a.id == idAlineacion,
      orElse: () =>
          throw Exception(TextosApp.CTRL_ALINEACIONES_ERROR_NO_ENCONTRADA),
    );

    final todos = {...idsTitulares, ...idsSuplentes};
    final setPlantel = alineacion.jugadoresSeleccionados.toSet();
    if (!setPlantel.containsAll(todos)) {
      throw ArgumentError(TextosApp.CTRL_ALINEACIONES_ERROR_JUGADORES_INVALIDOS);
    }

    final actualizada = alineacion.copiarCon(
      idsTitulares: idsTitulares,
      idsSuplentes: idsSuplentes,
    );

    await _servicio.editarAlineacion(actualizada);

    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_BUSCAR_PARTICIPACION
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
    );

    final participacion = await _servicioPart.obtenerParticipacion(
      idUsuario,
      idLiga,
    );

    if (participacion == null) {
      throw Exception(
        TextosApp.CTRL_ALINEACIONES_ERROR_PARTICIPACION_NO_ENCONTRADA,
      );
    }

    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_PARTICIPACION_ENCONTRADA
          .replaceAll('{PARTICIPACION}', participacion.id),
    );

    final actualizadaPart = participacion.copiarCon(plantelCompleto: true);

    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_PLANTEL_COMPLETO
          .replaceAll('{PARTICIPACION}', participacion.id),
    );

    await _servicioPart.editarParticipacion(actualizadaPart);

    _log.informacion(TextosApp.CTRL_ALINEACIONES_LOG_PARTICIPACION_ACTUALIZADA);

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
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_LIGA_VACIO);
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_USUARIO_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_BUSCAR_ACTIVA
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
    );

    final alineaciones = await _servicio.obtenerPorUsuarioEnLiga(
      idLiga,
      idUsuario,
    );
    if (alineaciones.isEmpty) return null;

    final alineacionesActivas = alineaciones.where((a) => a.activo).toList();
    if (alineacionesActivas.isNotEmpty) {
      final activa = alineacionesActivas.first;
      _log.informacion(
        TextosApp.CTRL_ALINEACIONES_LOG_ACTIVA_ENCONTRADA
            .replaceAll('{ALINEACION}', activa.id),
      );
      return activa;
    }

    // Si no hay activa, devolver la más reciente
    alineaciones.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    final reciente = alineaciones.first;
    _log.informacion(
      TextosApp.CTRL_ALINEACIONES_LOG_RECIENTE
          .replaceAll('{ALINEACION}', reciente.id),
    );
    return reciente;
  }
}
