/*
  Archivo: controlador_alineaciones.dart
  Descripción:
    Lógica de negocio y validación para gestión de alineaciones.
*/

import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/servicios/firebase/servicio_alineaciones.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ControladorAlineaciones {
  final ServicioAlineaciones _servicio = ServicioAlineaciones();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear alineación
  // ---------------------------------------------------------------------------
  Future<Alineacion> crearAlineacion(
    String idLiga,
    String idUsuario,
    List<String> jugadoresSeleccionados, {
    String formacion = "4-4-2",
    int puntosTotales = 0,
  }) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El ID de la liga no puede estar vacío.");
    }

    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El ID del usuario no puede estar vacío.");
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
      jugadoresSeleccionados: jugadoresSeleccionados,
      formacion: formacion,
      puntosTotales: puntosTotales,
      fechaCreacion: timestamp,
      activo: true,
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
}
