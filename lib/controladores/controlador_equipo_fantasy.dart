/*
  Archivo: controlador_equipo_fantasy.dart
  Descripción: Controlador para gestionar equipos fantasy del usuario final.
  Dependencias: servicio_equipos_fantasy.dart, equipo_fantasy.dart, servicio_log.dart
  Archivos que dependen de este archivo: vistas de usuario que gestionan su equipo fantasy.
*/

import 'package:fantasypro/modelos/equipo_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos_fantasy.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ControladorEquipoFantasy {
  /// Servicio para operaciones con equipos fantasy.
  final ServicioEquiposFantasy _servicio = ServicioEquiposFantasy();

  /// Servicio para registro de logs.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearEquipoFantasy
    Descripción: Crea un equipo fantasy asociado al usuario y la liga.
    Entradas: idUsuario (String), idLiga (String), nombre (String)
    Salidas: Future<EquipoFantasy>
  */
  Future<EquipoFantasy> crearEquipoFantasy(
    String idUsuario,
    String idLiga,
    String nombre,
  ) async {
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del equipo no puede estar vacío.");
    }

    _log.informacion(
      "Creando equipo fantasy: usuario=$idUsuario liga=$idLiga nombre=$nombre",
    );

    return await _servicio.crearEquipoFantasy(idUsuario, idLiga, nombre.trim());
  }

  /*
    Nombre: obtenerPorUsuarioYLiga
    Descripción: Obtiene equipos fantasy de un usuario en una liga específica.
    Entradas: idUsuario (String), idLiga (String)
    Salidas: Future<List<EquipoFantasy>>
  */
  Future<List<EquipoFantasy>> obtenerPorUsuarioYLiga(
    String idUsuario,
    String idLiga,
  ) async {
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }

    _log.informacion(
      "Listando equipos fantasy del usuario $idUsuario en liga $idLiga",
    );

    return await _servicio.obtenerPorUsuarioYLiga(idUsuario, idLiga);
  }

  /*
    Nombre: editarNombreEquipo
    Descripción: Edita el nombre de un equipo fantasy.
    Entradas: equipo (EquipoFantasy), nuevoNombre (String)
    Salidas: Future<void>
  */
  Future<void> editarNombreEquipo(
    EquipoFantasy equipo,
    String nuevoNombre,
  ) async {
    if (nuevoNombre.trim().isEmpty) {
      throw ArgumentError("El nombre no puede estar vacío.");
    }

    final actualizado = equipo.copiarCon(nombre: nuevoNombre.trim());

    _log.informacion("Editando nombre de equipo fantasy ${equipo.id}");

    await _servicio.editarEquipoFantasy(actualizado);
  }

  /*
    Nombre: activarEquipoFantasy
    Descripción: Activa un equipo fantasy archivado.
    Entradas: idEquipo (String)
    Salidas: Future<void>
  */
  Future<void> activarEquipoFantasy(String idEquipo) async {
    _log.informacion("Activando equipo fantasy $idEquipo");

    await _servicio.activarEquipoFantasy(idEquipo);
  }

  /*
    Nombre: archivarEquipoFantasy
    Descripción: Archiva un equipo fantasy.
    Entradas: idEquipo (String)
    Salidas: Future<void>
  */
  Future<void> archivarEquipoFantasy(String idEquipo) async {
    _log.advertencia("Archivando equipo fantasy $idEquipo");

    await _servicio.archivarEquipoFantasy(idEquipo);
  }

  /*
    Nombre: eliminarEquipoFantasy
    Descripción: Elimina un equipo fantasy.
    Entradas: idEquipo (String)
    Salidas: Future<void>
  */
  Future<void> eliminarEquipoFantasy(String idEquipo) async {
    _log.error("Eliminando equipo fantasy $idEquipo");

    await _servicio.eliminarEquipoFantasy(idEquipo);
  }
}
