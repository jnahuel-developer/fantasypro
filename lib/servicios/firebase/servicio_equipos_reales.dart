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
import 'package:fantasypro/textos/textos_app.dart';
import 'servicio_base_de_datos.dart';

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
      final doc =
          await _db.collection(ColFirebase.equiposReales).add(equipo.aMapa());
      final creado = equipo.copiarCon(id: doc.id);

      _log.informacion("${TextosApp.LOG_EQUIPO_REAL_CREADO} ${creado.id}");
      return creado;
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_REAL_ERROR_CREAR} $e");
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
          .collection(ColFirebase.equiposReales)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .get();

      _log.informacion("${TextosApp.LOG_EQUIPO_REAL_LISTAR_LIGA} $idLiga");

      return query.docs
          .map((d) => EquipoReal.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_REAL_ERROR_LISTAR} $e");
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
          .collection(ColFirebase.equiposReales)
          .doc(equipo.id)
          .update(equipo.aMapa());

      _log.informacion("${TextosApp.LOG_EQUIPO_REAL_EDITADO} ${equipo.id}");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_REAL_ERROR_EDITAR} $e");
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
      await _db
          .collection(ColFirebase.equiposReales)
          .doc(id)
          .update({CamposFirebase.activo: false});

      _log.informacion("${TextosApp.LOG_EQUIPO_REAL_ARCHIVADO} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_REAL_ERROR_ARCHIVAR} $e");
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
      await _db
          .collection(ColFirebase.equiposReales)
          .doc(id)
          .update({CamposFirebase.activo: true});

      _log.informacion("${TextosApp.LOG_EQUIPO_REAL_ACTIVADO} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_REAL_ERROR_ACTIVAR} $e");
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
      await _db.collection(ColFirebase.equiposReales).doc(id).delete();

      _log.informacion("${TextosApp.LOG_EQUIPO_REAL_ELIMINADO} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_REAL_ERROR_ELIMINAR} $e");
      rethrow;
    }
  }
}
