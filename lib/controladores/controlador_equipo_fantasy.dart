/*
  Archivo: controlador_equipo_fantasy.dart
  Descripción:
    Controlador encargado de la gestión de equipos fantasy creados por usuarios dentro de una liga.
    Aplica validaciones de negocio antes de interactuar con los servicios y asegura consistencia del flujo.
  Dependencias:
    - servicio_equipos_fantasy.dart
    - servicio_fechas.dart
    - controlador_participaciones.dart
    - modelo/equipo_fantasy.dart
  Archivos que dependen de este:
    - Flujo de creación de equipo fantasy en la UI.
*/

import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/modelos/equipo_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_fechas.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorEquipoFantasy {
  /// Servicio para operaciones de equipo fantasy.
  final ServicioEquiposFantasy _servicio = ServicioEquiposFantasy();

  /// Servicio para acceder a las fechas de liga.
  final ServicioFechas _servicioFechas = ServicioFechas();

  /// Servicio para registrar logs.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearEquipoParaLiga
    Descripción:
      Crea un nuevo equipo fantasy para un usuario en una liga determinada.
      Aplica reglas de negocio:
        - Un usuario solo puede tener un equipo por liga.
        - No se puede crear un equipo si la liga ya tiene una fecha activa.
    Entradas:
      - idUsuario: String → ID del usuario
      - idLiga: String → ID de la liga
      - nombreEquipo: String → Nombre del equipo fantasy
    Salidas: Future<EquipoFantasy>
  */
  Future<EquipoFantasy> crearEquipoParaLiga(
    String idUsuario,
    String idLiga,
    String nombreEquipo,
  ) async {
    if (idUsuario.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_USUARIO_VACIO);
    }
    if (idLiga.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_LIGA_VACIO);
    }
    if (nombreEquipo.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_NOMBRE_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_CREAR
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
    );

    final equipos = await _servicio.obtenerPorUsuarioYLiga(idUsuario, idLiga);
    if (equipos.isNotEmpty) {
      _log.advertencia(TextosApp.CTRL_EQUIPO_FANTASY_LOG_YA_EXISTE);
      throw Exception(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_YA_EXISTE);
    }

    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any((f) => f.activa && !f.cerrada);

    if (existeActiva) {
      _log.advertencia(TextosApp.CTRL_EQUIPO_FANTASY_LOG_FECHA_ACTIVA);
      throw Exception(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_FECHA_ACTIVA);
    }

    final equipo = await _servicio.crearEquipoFantasy(
      idUsuario,
      idLiga,
      nombreEquipo,
    );

    await ControladorParticipaciones().registrarParticipacionUsuario(
      idLiga,
      idUsuario,
      nombreEquipo,
    );

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_CREADO
          .replaceAll('{EQUIPO}', equipo.id),
    );

    return equipo;
  }

  /*
    Nombre: obtenerEquiposDeUsuario
    Descripción:
      Devuelve todos los equipos fantasy registrados por un usuario.
    Entradas:
      - idUsuario: String → ID del usuario
    Salidas: Future<List<EquipoFantasy>>
  */
  Future<List<EquipoFantasy>> obtenerEquiposDeUsuario(String idUsuario) async {
    if (idUsuario.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_USUARIO_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_LISTAR_USUARIO
          .replaceAll('{USUARIO}', idUsuario),
    );

    return await _servicio.obtenerPorUsuarioYLiga(idUsuario, "");
  }

  /*
    Nombre: obtenerEquiposPorUsuarioYLiga
    Descripción:
      Obtiene los equipos fantasy de un usuario en una liga específica.
    Entradas:
      - idUsuario: String → ID del usuario
      - idLiga: String → ID de la liga
    Salidas: Future<List<EquipoFantasy>>
  */
  Future<List<EquipoFantasy>> obtenerEquiposPorUsuarioYLiga(
    String idUsuario,
    String idLiga,
  ) async {
    if (idUsuario.isEmpty || idLiga.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_IDS_OBLIGATORIOS);
    }

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_LISTAR_USUARIO_LIGA
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
    );

    return await _servicio.obtenerPorUsuarioYLiga(idUsuario, idLiga);
  }

  /*
    Nombre: editar
    Descripción:
      Modifica los datos de un equipo fantasy.
    Entradas:
      - equipo: EquipoFantasy → Instancia con los datos actualizados
    Salidas: Future<void>
  */
  Future<void> editar(EquipoFantasy equipo) async {
    if (equipo.id.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_ID_EQUIPO_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_EDITAR
          .replaceAll('{EQUIPO}', equipo.id),
    );

    await _servicio.editarEquipoFantasy(equipo);
  }

  /*
    Nombre: archivar
    Descripción:
      Archiva un equipo fantasy, marcándolo como inactivo.
    Entradas:
      - idEquipo: String → ID del equipo fantasy
    Salidas: Future<void>
  */
  Future<void> archivar(String idEquipo) async {
    if (idEquipo.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_ID_EQUIPO_VACIO);
    }

    _log.advertencia(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_ARCHIVAR
          .replaceAll('{EQUIPO}', idEquipo),
    );

    await _servicio.archivarEquipoFantasy(idEquipo);
  }

  /*
    Nombre: activar
    Descripción:
      Reactiva un equipo fantasy previamente archivado.
    Entradas:
      - idEquipo: String → ID del equipo fantasy
    Salidas: Future<void>
  */
  Future<void> activar(String idEquipo) async {
    if (idEquipo.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_ID_EQUIPO_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_ACTIVAR
          .replaceAll('{EQUIPO}', idEquipo),
    );

    await _servicio.activarEquipoFantasy(idEquipo);
  }

  /*
    Nombre: eliminar
    Descripción:
      Elimina un equipo fantasy de forma permanente.
    Entradas:
      - idEquipo: String → ID del equipo fantasy
    Salidas: Future<void>
  */
  Future<void> eliminar(String idEquipo) async {
    if (idEquipo.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_ID_EQUIPO_VACIO);
    }

    _log.error(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_ELIMINAR
          .replaceAll('{EQUIPO}', idEquipo),
    );

    await _servicio.eliminarEquipoFantasy(idEquipo);
  }

  /*
    Nombre: obtenerEquipoUsuarioEnLiga
    Descripción:
      Recupera el equipo fantasy de un usuario en una liga. Si hay más de uno, devuelve el primero.
    Entradas:
      - idUsuario: String — ID del usuario
      - idLiga: String — ID de la liga
    Salidas:
      - Future<EquipoFantasy?> — el equipo si existe, null si no hay ninguno
  */
  Future<EquipoFantasy?> obtenerEquipoUsuarioEnLiga(
    String idUsuario,
    String idLiga,
  ) async {
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_USUARIO_VACIO);
    }
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.CTRL_COMUN_ERROR_ID_LIGA_VACIO);
    }

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_OBTENER
          .replaceAll('{USUARIO}', idUsuario)
          .replaceAll('{LIGA}', idLiga),
    );
    final lista = await _servicio.obtenerPorUsuarioYLiga(idUsuario, idLiga);
    if (lista.isEmpty) return null;
    return lista.first;
  }

  Future<void> guardarPlantelInicial(
    String idEquipoFantasy,
    List<String> ids,
    int presupuestoRestante,
  ) async {
    if (idEquipoFantasy.isEmpty) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_ID_EQUIPO_VACIO);
    }
    if (ids.length != 15) {
      throw ArgumentError(TextosApp.CTRL_EQUIPO_FANTASY_ERROR_PLANTEL_TAMANIO);
    }

    _log.informacion(
      TextosApp.CTRL_EQUIPO_FANTASY_LOG_GUARDAR_PLANTEL
          .replaceAll('{EQUIPO}', idEquipoFantasy)
          .replaceAll('{CANTIDAD}', ids.length.toString())
          .replaceAll('{PRESUPUESTO}', presupuestoRestante.toString()),
    );

    await _servicio.actualizarPlantel(
      idEquipoFantasy,
      ids,
      presupuestoRestante,
    );

    _log.informacion(TextosApp.CTRL_EQUIPO_FANTASY_LOG_PLANTEL_GUARDADO);
  }
}
