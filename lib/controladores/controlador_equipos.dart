/*
  Archivo: controlador_equipos.dart
  Descripción:
    Lógica de negocio y validación para la gestión de equipos.
*/

import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ControladorEquipos {
  final ServicioEquipos servicio = ServicioEquipos();
  final ServicioLog log = ServicioLog();

  Future<Equipo> crearEquipo(
    String idLiga,
    String nombre, [
    String descripcion = "",
  ]) async {
    if (idLiga.isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío");
    }
    if (nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del equipo no puede estar vacío");
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    final equipo = Equipo(
      id: "",
      idLiga: idLiga,
      nombre: nombre.trim(),
      descripcion: descripcion.trim().isEmpty
          ? "Equipo creado por el administrador."
          : descripcion.trim(),
      fechaCreacion: timestamp,
      activo: true,
      escudoUrl: "pendiente",
    );

    log.informacion("Creando equipo en liga $idLiga con nombre $nombre");

    return await servicio.crearEquipo(equipo);
  }

  Future<List<Equipo>> obtenerPorLiga(String idLiga) async {
    if (idLiga.isEmpty) {
      throw ArgumentError("idLiga no puede estar vacío");
    }
    return await servicio.obtenerEquiposDeLiga(idLiga);
  }

  Future<void> archivar(String idEquipo) async {
    log.advertencia("Archivando equipo $idEquipo");
    await servicio.archivarEquipo(idEquipo);
  }

  Future<void> activar(String idEquipo) async {
    log.informacion("Activando equipo $idEquipo");
    await servicio.activarEquipo(idEquipo);
  }

  Future<void> eliminar(String idEquipo) async {
    log.error("Eliminando equipo $idEquipo");
    await servicio.eliminarEquipo(idEquipo);
  }

  Future<void> editar(Equipo equipo) async {
    if (equipo.nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del equipo no puede estar vacío");
    }

    log.informacion("Editando equipo ${equipo.id}");
    await servicio.editarEquipo(equipo);
  }
}
