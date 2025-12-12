/*
  Archivo: servicio_fechas.dart
  Descripción:
    Servicio encargado de administrar las Fechas de una Liga dentro de Firestore.
    Permite crear fechas, listarlas por liga y cerrar fechas. No permite activar,
    editar, archivar ni eliminar fechas, para preservar la integridad del historial.

  Dependencias:
    - cloud_firestore.dart
    - fecha_liga.dart
    - servicio_log.dart

  Archivos que dependen de este:
    - Controladores de liga y cronologías.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'servicio_base_de_datos.dart';

class ServicioFechas {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logging interno.
  final ServicioLog _log = ServicioLog();

  /// Sanitización universal de IDs
  String _sanitizarId(String v) {
    return v
        .trim()
        .replaceAll('"', '')
        .replaceAll("'", "")
        .replaceAll("\\", "")
        .replaceAll("\n", "")
        .replaceAll("\r", "");
  }

  /*
    Nombre: crearFecha
    Descripción:
      Crea una nueva fecha para una liga. El número de fecha se autogenera
      incrementando la cantidad de fechas existentes. El nombre también se
      autogenera como "Fecha X". La fecha se crea activa y no cerrada.
    Entradas:
      - fecha (FechaLiga): instancia preliminar sin ID asignado.
    Salidas:
      - FechaLiga: instancia final con ID asignado por Firestore.
  */
  Future<FechaLiga> crearFecha(FechaLiga fecha) async {
    try {
      final idLiga = _sanitizarId(fecha.idLiga);
      if (idLiga.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_LIGA_INVALIDO);
      }

      _log.informacion("${TextosApp.LOG_FECHAS_CREANDO} $idLiga");

      // Obtener cuántas fechas existen actualmente para asignar numeroFecha.
      final existentes = await _db
          .collection(ColFirebase.fechasLiga)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .get();

      final numeroGenerado = existentes.docs.length + 1;
      final nombreGenerado = "Fecha $numeroGenerado";

      final nuevaFecha = fecha.copiarCon(
        idLiga: idLiga,
        numeroFecha: numeroGenerado,
        nombre: nombreGenerado,
        activa: true,
        cerrada: false,
        fechaCreacion: DateTime.now().millisecondsSinceEpoch,
      );

      final doc = await _db
          .collection(ColFirebase.fechasLiga)
          .add(nuevaFecha.aMapa());
      final guardada = nuevaFecha.copiarCon(id: doc.id);

      _log.informacion(
        TextosApp.LOG_FECHAS_CREADA
            .replaceFirst('{LIGA}', idLiga)
            .replaceFirst('{NUMERO}', '${guardada.numeroFecha}')
            .replaceFirst('{ID}', guardada.id),
      );

      return guardada;
    } catch (e) {
      _log.error("${TextosApp.LOG_FECHAS_ERROR_CREAR} $e");
      rethrow;
    }
  }

  /*
  Nombre: obtenerPorLiga
  Descripción:
    Devuelve todas las fechas pertenecientes a una liga dada.
    En caso de que la colección no exista o no tenga índice, retorna lista vacía.
  Entradas:
    - idLiga (String): identificador de la liga.
  Salidas:
    - Lista de instancias FechaLiga.
*/
  Future<List<FechaLiga>> obtenerPorLiga(String idLiga) async {
    try {
      idLiga = _sanitizarId(idLiga);
      if (idLiga.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_LIGA_INVALIDO);
      }

      _log.informacion(
        TextosApp.LOG_FECHAS_OBTENIENDO_LIGA.replaceFirst('{LIGA}', idLiga),
      );

      final query = await _db
          .collection(ColFirebase.fechasLiga)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .get();

      if (query.docs.isEmpty) {
        _log.advertencia(
          TextosApp.LOG_FECHAS_SIN_REGISTROS.replaceFirst('{LIGA}', idLiga),
        );
        return [];
      }

      final lista = query.docs
          .map((d) => FechaLiga.desdeMapa(d.id, d.data()))
          .toList();

      lista.sort((a, b) => a.numeroFecha.compareTo(b.numeroFecha));

      return lista;
    } on FirebaseException catch (e) {
      _log.error(
        "${TextosApp.LOG_FECHAS_ERROR_FIREBASE.replaceFirst('{LIGA}', idLiga)} $e",
      );
      rethrow;
    } catch (e) {
      _log.advertencia(
        TextosApp.LOG_FECHAS_COLECCION_INEXISTENTE.replaceFirst('{LIGA}', idLiga),
      );
      return [];
    }
  }

  /*
    Nombre: cerrarFecha
    Descripción:
      Marca una fecha como cerrada: activa=false y cerrada=true.
      No elimina la fecha. No modifica otras fechas.
    Entradas:
      - idFecha (String): identificador de la fecha a cerrar.
    Salidas:
      - Ninguna.
  */
  Future<void> cerrarFecha(String idFecha) async {
    try {
      idFecha = _sanitizarId(idFecha);
      if (idFecha.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_FECHA_INVALIDO);
      }

      _log.informacion("${TextosApp.LOG_FECHAS_CERRANDO} $idFecha");

      await _db.collection(ColFirebase.fechasLiga).doc(idFecha).update({
        CamposFirebase.activa: false,
        CamposFirebase.cerrada: true,
      });

      _log.informacion("${TextosApp.LOG_FECHAS_CERRADA} $idFecha");
    } catch (e) {
      _log.error("${TextosApp.LOG_FECHAS_ERROR_CERRAR} $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerFechaPorId
    Descripción:
      Recupera una fecha de liga a partir de su ID.
    Entradas:
      - idFecha: String → ID de la fecha
    Salidas:
      - Future<FechaLiga> → Instancia recuperada
  */
  Future<FechaLiga> obtenerFechaPorId(String idFecha) async {
    if (idFecha.isEmpty) {
      throw ArgumentError(TextosApp.ERR_FECHAS_ID_VACIO);
    }

    _log.informacion("${TextosApp.LOG_FECHAS_BUSCANDO_ID} $idFecha");

    try {
      final doc =
          await _db.collection(ColFirebase.fechasLiga).doc(idFecha).get();

      if (!doc.exists) {
        throw Exception("${TextosApp.LOG_FECHAS_NO_ENCONTRADA} $idFecha");
      }

      return FechaLiga.desdeMapa(doc.id, doc.data()!);
    } catch (e) {
      _log.error("${TextosApp.LOG_FECHAS_ERROR_OBTENER_ID} $idFecha: $e");
      rethrow;
    }
  }
}
