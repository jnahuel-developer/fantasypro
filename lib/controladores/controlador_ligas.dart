/*
  Archivo: controlador_ligas.dart
  Descripción:
    Lógica de negocio para gestionar ligas desde la interfaz.
*/

import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/firebase/servicio_ligas.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ControladorLigas {
  final ServicioLigas servicio = ServicioLigas();
  final ServicioLog log = ServicioLog();

  /*
    Nombre: crearLiga
    Descripción:
      Crea una liga nueva con datos mínimos.
  */
  Future<Liga> crearLiga(String nombre, String descripcion) async {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final liga = Liga(
      id: "",
      nombre: nombre,
      temporada: "Temporada ${DateTime.now().year}/${DateTime.now().year + 1}",
      descripcion: descripcion.isEmpty
          ? "Liga generada por el administrador."
          : descripcion,
      fechaCreacion: timestamp,
      activa: true,
    );

    return await servicio.crearLiga(liga);
  }

  Future<List<Liga>> obtenerActivas() async {
    return await servicio.obtenerLigasActivas();
  }

  Future<List<Liga>> obtenerTodas() async {
    return await servicio.obtenerTodasLasLigas();
  }

  Future<void> archivar(String id) async {
    await servicio.archivarLiga(id);
  }

  Future<void> activar(String id) async {
    await servicio.activarLiga(id);
  }

  Future<void> eliminar(String id) async {
    await servicio.eliminarLiga(id);
  }
}
