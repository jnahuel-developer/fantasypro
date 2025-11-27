/*
  Archivo: controlador_equipos.dart
  Descripción:
    Lógica de negocio y validación para la gestión de equipos.
*/

import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorEquipos {
  final ServicioEquipos _servicio = ServicioEquipos();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear equipo
  // ---------------------------------------------------------------------------
  Future<Equipo> crearEquipo(
    String idLiga,
    String nombre, [
    String descripcion = "",
  ]) async {
    if (idLiga.isEmpty) {
      throw ArgumentError(TextosApp.ERR_EQUIPO_ID_LIGA_VACIO);
    }

    if (nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_EQUIPO_NOMBRE_VACIO);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final equipo = Equipo(
      id: "",
      idLiga: idLiga,
      nombre: nombre.trim(),
      descripcion: descripcion.trim().isEmpty
          ? TextosApp.EQUIPO_DESCRIPCION_POR_DEFECTO
          : descripcion.trim(),
      fechaCreacion: timestamp,
      activo: true,
      escudoUrl: TextosApp.EQUIPO_ESCUDO_PENDIENTE,
    );

    _log.informacion("${TextosApp.LOG_EQUIPO_CREANDO} $idLiga ($nombre)");

    return await _servicio.crearEquipo(equipo);
  }

  // ---------------------------------------------------------------------------
  // Obtener equipos de una liga
  // ---------------------------------------------------------------------------
  Future<List<Equipo>> obtenerPorLiga(String idLiga) async {
    if (idLiga.isEmpty) {
      throw ArgumentError(TextosApp.ERR_EQUIPO_ID_LIGA_VACIO);
    }

    return await _servicio.obtenerEquiposDeLiga(idLiga);
  }

  // ---------------------------------------------------------------------------
  // Archivar
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idEquipo) async {
    _log.advertencia("${TextosApp.LOG_EQUIPO_ARCHIVANDO} $idEquipo");
    await _servicio.archivarEquipo(idEquipo);
  }

  // ---------------------------------------------------------------------------
  // Activar
  // ---------------------------------------------------------------------------
  Future<void> activar(String idEquipo) async {
    _log.informacion("${TextosApp.LOG_EQUIPO_ACTIVANDO} $idEquipo");
    await _servicio.activarEquipo(idEquipo);
  }

  // ---------------------------------------------------------------------------
  // Eliminar
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idEquipo) async {
    _log.error("${TextosApp.LOG_EQUIPO_ELIMINANDO} $idEquipo");
    await _servicio.eliminarEquipo(idEquipo);
  }

  // ---------------------------------------------------------------------------
  // Editar
  // ---------------------------------------------------------------------------
  Future<void> editar(Equipo equipo) async {
    if (equipo.nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_EQUIPO_NOMBRE_VACIO);
    }

    _log.informacion("${TextosApp.LOG_EQUIPO_EDITANDO} ${equipo.id}");
    await _servicio.editarEquipo(equipo);
  }
}
