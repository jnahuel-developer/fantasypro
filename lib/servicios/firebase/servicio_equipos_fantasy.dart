/*
  Archivo: servicio_equipos_fantasy.dart
  Descripción:
    Servicio encargado de administrar la colección "equipos_fantasy".
    Permite crear, consultar, editar, activar, archivar y eliminar
    equipos fantasy creados por usuarios dentro de una liga.

  Dependencias:
    - cloud_firestore
    - modelos/equipo_fantasy.dart
    - servicio_log.dart

  Archivos que dependen de este archivo:
    - Controladores del flujo de usuario final (creación de equipo fantasy).
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/equipo_fantasy.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioEquiposFantasy {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logging.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearEquipoFantasy
    Descripción:
      Crea un equipo fantasy para el usuario dentro de una liga.
    Entradas:
      - idUsuario (String): usuario propietario.
      - idLiga (String): liga asociada.
      - nombre (String): nombre del equipo.
    Salidas:
      - Future<EquipoFantasy>: instancia creada.
  */
  Future<EquipoFantasy> crearEquipoFantasy(
    String idUsuario,
    String idLiga,
    String nombre,
  ) async {
    try {
      final equipo = EquipoFantasy(
        id: "",
        idUsuario: idUsuario,
        idLiga: idLiga,
        nombre: nombre,
        fechaCreacion: DateTime.now().millisecondsSinceEpoch,
        activo: true,
      );

      final doc = await _db.collection("equipos_fantasy").add(equipo.aMapa());
      final creado = equipo.copiarCon(id: doc.id);

      _log.informacion(
        "EquipoFantasy creado: usuario=$idUsuario liga=$idLiga → ${creado.id}",
      );

      return creado;
    } catch (e) {
      _log.error("Error creando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorUsuarioYLiga
    Descripción:
      Obtiene todos los equipos fantasy de un usuario en una liga dada.
    Entradas:
      - idUsuario (String)
      - idLiga (String)
    Salidas:
      - Future<List<EquipoFantasy>>
  */
  Future<List<EquipoFantasy>> obtenerPorUsuarioYLiga(
    String idUsuario,
    String idLiga,
  ) async {
    try {
      final query = await _db
          .collection("equipos_fantasy")
          .where('idUsuario', isEqualTo: idUsuario)
          .where('idLiga', isEqualTo: idLiga)
          .get();

      _log.informacion(
        "Listar equipos fantasy: usuario=$idUsuario liga=$idLiga",
      );

      return query.docs
          .map((d) => EquipoFantasy.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error listando equipos fantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarEquipoFantasy
    Descripción:
      Actualiza un equipo fantasy existente.
    Entradas:
      - equipo (EquipoFantasy): datos actualizados.
    Salidas:
      - Future<void>
  */
  Future<void> editarEquipoFantasy(EquipoFantasy equipo) async {
    try {
      await _db
          .collection("equipos_fantasy")
          .doc(equipo.id)
          .update(equipo.aMapa());

      _log.informacion("EquipoFantasy editado: ${equipo.id}");
    } catch (e) {
      _log.error("Error editando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarEquipoFantasy
    Descripción:
      Marca un equipo fantasy como inactivo.
    Entradas:
      - id (String)
    Salidas:
      - Future<void>
  */
  Future<void> archivarEquipoFantasy(String id) async {
    try {
      await _db.collection("equipos_fantasy").doc(id).update({'activo': false});

      _log.informacion("EquipoFantasy archivado: $id");
    } catch (e) {
      _log.error("Error archivando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarEquipoFantasy
    Descripción:
      Marca un equipo fantasy como activo.
    Entradas:
      - id (String)
    Salidas:
      - Future<void>
  */
  Future<void> activarEquipoFantasy(String id) async {
    try {
      await _db.collection("equipos_fantasy").doc(id).update({'activo': true});

      _log.informacion("EquipoFantasy activado: $id");
    } catch (e) {
      _log.error("Error activando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarEquipoFantasy
    Descripción:
      Elimina un equipo fantasy de Firestore.
    Entradas:
      - id (String)
    Salidas:
      - Future<void>
  */
  Future<void> eliminarEquipoFantasy(String id) async {
    try {
      await _db.collection("equipos_fantasy").doc(id).delete();

      _log.informacion("EquipoFantasy eliminado: $id");
    } catch (e) {
      _log.error("Error eliminando EquipoFantasy: $e");
      rethrow;
    }
  }
}
