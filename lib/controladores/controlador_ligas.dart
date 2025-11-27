/*
  Archivo: controlador_ligas.dart
  Descripción:
    Lógica de negocio para la gestión de ligas.
*/

import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/firebase/servicio_ligas.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorLigas {
  final ServicioLigas _servicio = ServicioLigas();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear liga
  // ---------------------------------------------------------------------------
  Future<Liga> crearLiga(String nombre, String descripcion) async {
    if (nombre.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_LIGA_NOMBRE_VACIO);
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final temporadaFormateada =
        "${TextosApp.LIGA_TEXTO_TEMPORADA} ${DateTime.now().year}/${DateTime.now().year + 1}";

    final liga = Liga(
      id: "",
      nombre: nombre.trim(),
      temporada: temporadaFormateada,
      descripcion: descripcion.trim().isEmpty
          ? TextosApp.LIGA_DESCRIPCION_POR_DEFECTO
          : descripcion.trim(),
      fechaCreacion: timestamp,
      activa: true,
    );

    _log.informacion("${TextosApp.LOG_LIGA_CREANDO} $nombre");

    return await _servicio.crearLiga(liga);
  }

  // ---------------------------------------------------------------------------
  // Obtener activas
  // ---------------------------------------------------------------------------
  Future<List<Liga>> obtenerActivas() async {
    return await _servicio.obtenerLigasActivas();
  }

  // ---------------------------------------------------------------------------
  // Obtener todas
  // ---------------------------------------------------------------------------
  Future<List<Liga>> obtenerTodas() async {
    return await _servicio.obtenerTodasLasLigas();
  }

  // ---------------------------------------------------------------------------
  // Archivar
  // ---------------------------------------------------------------------------
  Future<void> archivar(String id) async {
    _log.advertencia("${TextosApp.LOG_LIGA_ARCHIVANDO} $id");
    await _servicio.archivarLiga(id);
  }

  // ---------------------------------------------------------------------------
  // Activar
  // ---------------------------------------------------------------------------
  Future<void> activar(String id) async {
    _log.informacion("${TextosApp.LOG_LIGA_ACTIVANDO} $id");
    await _servicio.activarLiga(id);
  }

  // ---------------------------------------------------------------------------
  // Eliminar
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String id) async {
    _log.error("${TextosApp.LOG_LIGA_ELIMINANDO} $id");
    await _servicio.eliminarLiga(id);
  }
}
