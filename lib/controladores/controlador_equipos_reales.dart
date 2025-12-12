/*
  Archivo: controlador_equipos_reales.dart
  Descripción: Controlador para administrar equipos reales (uso administrativo).
  Dependencias: servicio_equipos_reales.dart, equipo_real.dart, servicio_log.dart
  Archivos que dependen de este archivo: vistas admin que gestionan equipos reales.
*/

import 'package:fantasypro/modelos/equipo_real.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos_reales.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorEquiposReales {
  /// Servicio para operaciones con equipos reales.
  final ServicioEquiposReales _servicio = ServicioEquiposReales();

  /// Servicio para registro de logs.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearEquipoReal
    Descripción: Crea un equipo real en la liga indicada.
    Entradas: idLiga (String), nombre (String), descripcion (String), escudoUrl (String)
    Salidas: Future<EquipoReal>
  */
  Future<EquipoReal> crearEquipoReal(
    String idLiga,
    String nombre,
    String descripcion, {
    String escudoUrl = "",
  }) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_NOMBRE_VACIO);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final equipo = EquipoReal(
      id: "",
      idLiga: idLiga,
      nombre: nombre.trim(),
      descripcion: descripcion.trim(),
      escudoUrl: escudoUrl.trim(),
      fechaCreacion: timestamp,
      activo: true,
    );

    _log.informacion("${TextosApp.LOG_CTRL_EQUIPO_REAL_CREAR} $idLiga ($nombre)");

    return await _servicio.crearEquipoReal(equipo);
  }

  /*
    Nombre: obtenerPorLiga
    Descripción: Obtiene equipos reales de una liga específica.
    Entradas: idLiga (String)
    Salidas: Future<List<EquipoReal>>
  */
  Future<List<EquipoReal>> obtenerPorLiga(String idLiga) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }

    _log.informacion("${TextosApp.LOG_CTRL_EQUIPO_REAL_LISTAR} $idLiga");

    return await _servicio.obtenerEquiposDeLiga(idLiga);
  }

  /*
    Nombre: editarEquipoReal
    Descripción: Edita un equipo real existente.
    Entradas: equipo (EquipoReal)
    Salidas: Future<void>
  */
  Future<void> editarEquipoReal(EquipoReal equipo) async {
    if (equipo.nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_NOMBRE_VACIO);
    }

    _log.informacion("${TextosApp.LOG_CTRL_EQUIPO_REAL_EDITAR} ${equipo.id}");

    await _servicio.editarEquipoReal(equipo);
  }

  /*
    Nombre: activarEquipoReal
    Descripción: Activa un equipo real previamente archivado.
    Entradas: idEquipo (String)
    Salidas: Future<void>
  */
  Future<void> activarEquipoReal(String idEquipo) async {
    _log.informacion("${TextosApp.LOG_CTRL_EQUIPO_REAL_ACTIVAR} $idEquipo");

    await _servicio.activarEquipoReal(idEquipo);
  }

  /*
    Nombre: archivarEquipoReal
    Descripción: Archiva un equipo real.
    Entradas: idEquipo (String)
    Salidas: Future<void>
  */
  Future<void> archivarEquipoReal(String idEquipo) async {
    _log.advertencia("${TextosApp.LOG_CTRL_EQUIPO_REAL_ARCHIVAR} $idEquipo");

    await _servicio.archivarEquipoReal(idEquipo);
  }

  /*
    Nombre: eliminarEquipoReal
    Descripción: Elimina un equipo real.
    Entradas: idEquipo (String)
    Salidas: Future<void>
  */
  Future<void> eliminarEquipoReal(String idEquipo) async {
    _log.error("${TextosApp.LOG_CTRL_EQUIPO_REAL_ELIMINAR} $idEquipo");

    await _servicio.eliminarEquipoReal(idEquipo);
  }
}
