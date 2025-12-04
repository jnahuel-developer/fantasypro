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
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (idLiga.isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (nombreEquipo.isEmpty) {
      throw ArgumentError("El nombre del equipo no puede estar vacío.");
    }

    _log.informacion(
      "Creando equipo fantasy para usuario $idUsuario en liga $idLiga",
    );

    final equipos = await _servicio.obtenerPorUsuarioYLiga(idUsuario, idLiga);
    if (equipos.isNotEmpty) {
      _log.advertencia("El usuario ya tiene un equipo en esta liga.");
      throw Exception(
        "Ya existe un equipo fantasy para este usuario en esta liga.",
      );
    }

    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any((f) => f.activa && !f.cerrada);

    if (existeActiva) {
      _log.advertencia(
        "No se puede crear equipo: ya existe una fecha activa en la liga.",
      );
      throw Exception(
        "No se puede crear un equipo con fechas activas en la liga.",
      );
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

    _log.informacion("Equipo fantasy creado exitosamente: ${equipo.id}");

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
      throw ArgumentError("El ID del usuario no puede estar vacío.");
    }

    _log.informacion("Listando equipos fantasy del usuario $idUsuario");

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
      throw ArgumentError(
        "El ID del usuario y el de la liga no pueden estar vacíos.",
      );
    }

    _log.informacion(
      "Listando equipos fantasy del usuario $idUsuario en liga $idLiga",
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
      throw ArgumentError("El ID del equipo no puede estar vacío.");
    }

    _log.informacion("Editando equipo fantasy ${equipo.id}");

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
      throw ArgumentError("El ID del equipo no puede estar vacío.");
    }

    _log.advertencia("Archivando equipo fantasy $idEquipo");

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
      throw ArgumentError("El ID del equipo no puede estar vacío.");
    }

    _log.informacion("Activando equipo fantasy $idEquipo");

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
      throw ArgumentError("El ID del equipo no puede estar vacío.");
    }

    _log.error("Eliminando equipo fantasy $idEquipo");

    await _servicio.eliminarEquipoFantasy(idEquipo);
  }
}
