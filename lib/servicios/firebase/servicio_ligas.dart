/*
  Archivo: servicio_ligas.dart
  Descripción:
    Servicio que administra la colección "ligas" en Firestore.
    Permite crear, obtener, editar, activar, archivar y eliminar ligas.

  Dependencias:
    - cloud_firestore
    - modelos/liga.dart
    - servicio_log.dart
    - textos_app.dart

  Archivos que dependen de este archivo:
    - Controladores del flujo de creación, edición y búsqueda de ligas
    - Interfaces de usuario para explorar y gestionar ligas
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'servicio_base_de_datos.dart';

class ServicioLigas {
  /// Instancia de Firestore para acceder a la colección "ligas".
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logs para registrar acciones y errores relacionados a ligas.
  final ServicioLog _log = ServicioLog();

  /// Sanitización universal de IDs o campos de texto
  String _sanitizarTexto(String v) {
    return v
        .trim()
        .replaceAll('"', '')
        .replaceAll("'", "")
        .replaceAll("\\", "")
        .replaceAll("\n", "")
        .replaceAll("\r", "");
  }

  /*
    Nombre: crearLiga
    Descripción:
      Crea una nueva liga en la colección "ligas" con los datos provistos.
    Entradas:
      - liga (Liga): instancia de la liga a guardar.
    Salidas:
      - Future<Liga>: instancia creada con ID asignado por Firestore.
  */
  Future<Liga> crearLiga(Liga liga) async {
    try {
      final datos = liga.aMapa();
      datos[CamposFirebase.nombreBusqueda] = _sanitizarTexto(liga.nombre);

      final doc = await _db.collection(ColFirebase.ligas).add(datos);
      final nuevaLiga = liga.copiarCon(id: doc.id);

      _log.informacion("${TextosApp.LOG_LIGA_CREADA} ${nuevaLiga.id}");
      return nuevaLiga;
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_CREAR} $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerLiga
    Descripción:
      Recupera una liga existente a partir de su ID.
    Entradas:
      - id (String): identificador de la liga.
    Salidas:
      - Future<Liga?>: instancia encontrada o null si no existe.
  */
  Future<Liga?> obtenerLiga(String id) async {
    try {
      id = _sanitizarTexto(id);

      final doc = await _db.collection(ColFirebase.ligas).doc(id).get();

      if (!doc.exists) {
        _log.advertencia("${TextosApp.LOG_LIGA_NO_ENCONTRADA} $id");
        return null;
      }

      return Liga.desdeMapa(doc.id, doc.data()!);
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_OBTENER} $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerLigasActivas
    Descripción:
      Devuelve todas las ligas que están marcadas como activas en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Future<List<Liga>>: lista de ligas activas.
  */
  Future<List<Liga>> obtenerLigasActivas() async {
    try {
      final consulta = await _db
          .collection(ColFirebase.ligas)
          .where(CamposFirebase.activa, isEqualTo: true)
          .get();

      return consulta.docs.map((d) => Liga.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_LISTAR_ACTIVAS} $e");
      rethrow;
    }
  }

  /*
    Nombre: buscarLigasPorNombre
    Descripción:
      Busca ligas por coincidencia parcial en el campo "nombreBusqueda", ignorando mayúsculas.
    Entradas:
      - texto (String): texto a buscar.
    Salidas:
      - Future<List<Liga>>: lista de ligas que coinciden con la búsqueda.
  */
  Future<List<Liga>> buscarLigasPorNombre(String texto) async {
    try {
      texto = _sanitizarTexto(texto);
      if (texto.isEmpty) return [];

      final query = await _db
          .collection(ColFirebase.ligas)
          .where(CamposFirebase.nombreBusqueda, isGreaterThanOrEqualTo: texto)
          .where(CamposFirebase.nombreBusqueda, isLessThan: '${texto}z')
          .get();

      _log.informacion("Buscar ligas por nombre: '$texto'");

      return query.docs.map((d) => Liga.desdeMapa(d.id, d.data())).toList();
    } catch (e) {
      _log.informacion("Buscar ligas por nombre: '$texto'");
      rethrow;
    }
  }

  /*
    Nombre: obtenerTodasLasLigas
    Descripción:
      Devuelve todas las ligas disponibles en Firestore, sin filtrar por estado.
    Entradas:
      - Ninguna.
    Salidas:
      - Future<List<Liga>>: lista completa de ligas.
  */
  Future<List<Liga>> obtenerTodasLasLigas() async {
    try {
      final consulta = await _db.collection(ColFirebase.ligas).get();

      return consulta.docs
          .map((doc) => Liga.desdeMapa(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_LISTAR_TODAS} $e");
      rethrow;
    }
  }

  /*
    Nombre: editarLiga
    Descripción:
      Actualiza los campos de una liga existente en Firestore.
    Entradas:
      - liga (Liga): instancia con datos actualizados.
    Salidas:
      - Future<void>
  */
  Future<void> editarLiga(Liga liga) async {
    try {
      final datos = liga.aMapa();
      datos[CamposFirebase.nombreBusqueda] = _sanitizarTexto(liga.nombre);

      await _db.collection(ColFirebase.ligas).doc(liga.id).update(datos);
      _log.informacion("${TextosApp.LOG_LIGA_EDITADA} ${liga.id}");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_EDITAR} $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarLiga
    Descripción:
      Marca una liga como inactiva (activa = false).
    Entradas:
      - id (String): ID de la liga a archivar.
    Salidas:
      - Future<void>
  */
  Future<void> archivarLiga(String id) async {
    try {
      id = _sanitizarTexto(id);
      await _db
          .collection(ColFirebase.ligas)
          .doc(id)
          .update({CamposFirebase.activa: false});
      _log.informacion("${TextosApp.LOG_LIGA_ARCHIVADA} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_ARCHIVAR} $e");
      rethrow;
    }
  }

  /*
    Nombre: activarLiga
    Descripción:
      Marca una liga como activa (activa = true).
    Entradas:
      - id (String): ID de la liga a activar.
    Salidas:
      - Future<void>
  */
  Future<void> activarLiga(String id) async {
    try {
      id = _sanitizarTexto(id);
      await _db
          .collection(ColFirebase.ligas)
          .doc(id)
          .update({CamposFirebase.activa: true});
      _log.informacion("${TextosApp.LOG_LIGA_ACTIVADA} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_ACTIVAR} $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarLiga
    Descripción:
      Elimina definitivamente una liga de la base de datos.
    Entradas:
      - id (String): ID de la liga a eliminar.
    Salidas:
      - Future<void>
  */
  Future<void> eliminarLiga(String id) async {
    try {
      id = _sanitizarTexto(id);
      await _db.collection(ColFirebase.ligas).doc(id).delete();
      _log.informacion("${TextosApp.LOG_LIGA_ELIMINADA} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_LIGA_ERROR_ELIMINAR} $e");
      rethrow;
    }
  }
}
