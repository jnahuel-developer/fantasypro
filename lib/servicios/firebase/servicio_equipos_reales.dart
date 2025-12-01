/*
  Archivo: servicio_equipos_reales.dart
  Descripción:
    Servicio responsable de administrar la colección "equipos_reales"
    en Firestore. Permite crear, listar, editar, activar, archivar y
    eliminar equipos reales asociados a una liga.

  Dependencias:
    - cloud_firestore
    - modelos/equipo_real.dart
    - servicio_log.dart

  Archivos que dependen de este archivo:
    - Controladores y vistas de administración de equipos reales.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/equipo_real.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioEquiposReales {
  /// Instancia del cliente Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de registro de logs.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearEquipoReal
    Descripción:
      Crea un equipo real en Firestore utilizando el modelo EquipoReal.
    Entradas:
      - equipo (EquipoReal): datos a almacenar.
    Salidas:
      - Future<EquipoReal>: instancia con ID asignado por Firestore.
  */
  Future<EquipoReal> crearEquipoReal(EquipoReal equipo) async {
    try {
      final doc = await _db.collection("equipos_reales").add(equipo.aMapa());
      final creado = equipo.copiarCon(id: doc.id);

      _log.informacion("EquipoReal creado: ${creado.id}");
      return creado;
    } catch (e) {
      _log.error("Error creando EquipoReal: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerEquiposDeLiga
    Descripción:
      Obtiene todos los equipos reales asociados a una liga.
    Entradas:
      - idLiga (String): identificador de la liga real.
    Salidas:
      - Future<List<EquipoReal>>: lista de equipos reales.
  */
  Future<List<EquipoReal>> obtenerEquiposDeLiga(String idLiga) async {
    try {
      final query = await _db
          .collection("equipos_reales")
          .where('idLiga', isEqualTo: idLiga)
          .get();

      _log.informacion("Listar equipos reales de liga: $idLiga");

      return query.docs
          .map((d) => EquipoReal.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error listando equipos reales: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarEquipoReal
    Descripción:
      Actualiza los campos de un equipo real existente.
    Entradas:
      - equipo (EquipoReal): instancia con datos actualizados.
    Salidas:
      - Future<void>
  */
  Future<void> editarEquipoReal(EquipoReal equipo) async {
    try {
      await _db
          .collection("equipos_reales")
          .doc(equipo.id)
          .update(equipo.aMapa());

      _log.informacion("EquipoReal editado: ${equipo.id}");
    } catch (e) {
      _log.error("Error editando EquipoReal: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarEquipoReal
    Descripción:
      Marca un equipo real como inactivo.
    Entradas:
      - id (String): identificador del equipo.
    Salidas:
      - Future<void>
  */
  Future<void> archivarEquipoReal(String id) async {
    try {
      await _db.collection("equipos_reales").doc(id).update({'activo': false});

      _log.informacion("EquipoReal archivado: $id");
    } catch (e) {
      _log.error("Error archivando EquipoReal: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarEquipoReal
    Descripción:
      Marca un equipo real como activo.
    Entradas:
      - id (String): identificador del equipo.
    Salidas:
      - Future<void>
  */
  Future<void> activarEquipoReal(String id) async {
    try {
      await _db.collection("equipos_reales").doc(id).update({'activo': true});

      _log.informacion("EquipoReal activado: $id");
    } catch (e) {
      _log.error("Error activando EquipoReal: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarEquipoReal
    Descripción:
      Elimina un equipo real de la colección.
    Entradas:
      - id (String): identificador del documento.
    Salidas:
      - Future<void>
  */
  Future<void> eliminarEquipoReal(String id) async {
    try {
      await _db.collection("equipos_reales").doc(id).delete();

      _log.informacion("EquipoReal eliminado: $id");
    } catch (e) {
      _log.error("Error eliminando EquipoReal: $e");
      rethrow;
    }
  }
}
