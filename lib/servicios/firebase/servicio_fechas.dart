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
      _log.informacion("Creando fecha para liga ${fecha.idLiga}");

      // Obtener cuántas fechas existen actualmente para asignar numeroFecha.
      final existentes = await _db
          .collection("fechas_liga")
          .where("idLiga", isEqualTo: fecha.idLiga)
          .get();

      final numeroGenerado = existentes.docs.length + 1;
      final nombreGenerado = "Fecha $numeroGenerado";

      final nuevaFecha = fecha.copiarCon(
        numeroFecha: numeroGenerado,
        nombre: nombreGenerado,
        activa: true,
        cerrada: false,
        fechaCreacion: DateTime.now().millisecondsSinceEpoch,
      );

      final doc = await _db.collection("fechas_liga").add(nuevaFecha.aMapa());
      final guardada = nuevaFecha.copiarCon(id: doc.id);

      _log.informacion(
        "Fecha creada: liga=${fecha.idLiga} fecha=${guardada.numeroFecha} id=${guardada.id}",
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
    Entradas:
      - idLiga (String): identificador de la liga.
    Salidas:
      - Lista de instancias FechaLiga.
  */
  Future<List<FechaLiga>> obtenerPorLiga(String idLiga) async {
    try {
      _log.informacion("Obteniendo fechas de la liga $idLiga");

      final query = await _db
          .collection("fechas_liga")
          .where("idLiga", isEqualTo: idLiga)
          .orderBy("numeroFecha")
          .get();

      return query.docs
          .map((d) => FechaLiga.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error obteniendo fechas de liga: $e");
      rethrow;
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
}
