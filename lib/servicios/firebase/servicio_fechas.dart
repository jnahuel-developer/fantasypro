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
        throw ArgumentError("ID de liga inválido.");
      }

      _log.informacion("Creando fecha para liga $idLiga");

      // Obtener cuántas fechas existen actualmente para asignar numeroFecha.
      final existentes = await _db
          .collection("fechas_liga")
          .where("idLiga", isEqualTo: idLiga)
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

      final doc = await _db.collection("fechas_liga").add(nuevaFecha.aMapa());
      final guardada = nuevaFecha.copiarCon(id: doc.id);

      _log.informacion(
        "Fecha creada: liga=$idLiga fecha=${guardada.numeroFecha} id=${guardada.id}",
      );

      return guardada;
    } catch (e) {
      _log.error("Error creando fecha: $e");
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
        throw ArgumentError("ID de liga inválido.");
      }

      _log.informacion("Obteniendo fechas de la liga $idLiga");

      final query = await _db
          .collection("fechas_liga")
          .where("idLiga", isEqualTo: idLiga)
          .get();

      if (query.docs.isEmpty) {
        _log.advertencia("No hay fechas registradas para la liga $idLiga");
        return [];
      }

      final lista = query.docs
          .map((d) => FechaLiga.desdeMapa(d.id, d.data()))
          .toList();

      lista.sort((a, b) => a.numeroFecha.compareTo(b.numeroFecha));

      return lista;
    } on FirebaseException catch (e) {
      _log.error("Error Firebase al obtener fechas de liga $idLiga: $e");
      rethrow;
    } catch (e) {
      _log.advertencia(
        "Colección de fechas inexistente o vacía para liga $idLiga — devolviendo lista vacía.",
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
        throw ArgumentError("ID de fecha inválido.");
      }

      _log.informacion("Cerrando fecha $idFecha");

      await _db.collection("fechas_liga").doc(idFecha).update({
        "activa": false,
        "cerrada": true,
      });

      _log.informacion("Fecha cerrada correctamente: $idFecha");
    } catch (e) {
      _log.error("Error cerrando fecha: $e");
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
      throw ArgumentError("El ID de la fecha no puede estar vacío.");
    }

    _log.informacion("Buscando fecha por ID: $idFecha");

    try {
      final doc = await _db.collection("fechas_liga").doc(idFecha).get();

      if (!doc.exists) {
        throw Exception("Fecha no encontrada: $idFecha");
      }

      return FechaLiga.desdeMapa(doc.id, doc.data()!);
    } catch (e) {
      _log.error("Error al obtener fecha $idFecha: $e");
      rethrow;
    }
  }
}
