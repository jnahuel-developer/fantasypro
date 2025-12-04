/*
  Archivo: servicio_puntajes_reales.dart
  Descripción:
    Servicio encargado de administrar la colección "puntajes_reales" en Firestore.
    Permite almacenar y recuperar los puntajes reales obtenidos por los jugadores
    en una fecha específica, utilizando operaciones básicas de escritura y consulta.

  Dependencias:
    - cloud_firestore.dart
    - modelos/puntaje_jugador_fecha.dart
    - servicio_log.dart

  Archivos que dependen de este:
    - Controladores de puntajes reales.
    - Controladores de cálculo fantasy (en desarrollos futuros).
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/puntaje_jugador_fecha.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioPuntajesReales {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logging interno.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: guardarPuntajesDeFecha
    Descripción:
      Guarda todos los puntajes asociados a una fecha utilizando un WriteBatch.
      Cada puntaje se almacena como documento individual dentro de la colección
      "puntajes_reales". El ID del documento es determinístico y se compone de:
         "<idFecha>_<idJugadorReal>"
      garantizando que solo exista un puntaje por jugador y por fecha.
    Entradas:
      - idLiga (String): identificador de la liga asociada.
      - idFecha (String): identificador de la fecha.
      - puntajes (List<PuntajeJugadorFecha>): listado de puntajes a guardar.
    Salidas:
      - Future<void>: operación completada.
  */
  Future<void> guardarPuntajesDeFecha(
    String idLiga,
    String idFecha,
    List<PuntajeJugadorFecha> puntajes,
  ) async {
    try {
      final batch = _db.batch();
      final coleccion = _db.collection("puntajes_reales");

      for (final p in puntajes) {
        // ID determinístico: asegura UN SOLO documento por (fecha, jugador).
        final String idDoc = "${idFecha}_${p.idJugadorReal}";

        final docRef = coleccion.doc(idDoc);

        batch.set(docRef, {
          ...p.aMapa(),
          "id": idDoc,
          "idLiga": idLiga,
          "idFecha": idFecha,
        }, SetOptions(merge: true));
      }

      await batch.commit();
      _log.informacion(
        "Guardar puntajes reales (doc único por jugador): fecha=$idFecha total=${puntajes.length}",
      );
    } catch (e) {
      _log.error("Error guardando puntajes reales: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPuntajesPorFecha
    Descripción:
      Recupera todos los puntajes registrados para una fecha. La consulta se
      limita a la colección "puntajes_reales" filtrando por el campo "idFecha",
      y retorna los elementos mapeados al modelo PuntajeJugadorFecha.
    Entradas:
      - idFecha (String): identificador de la fecha.
    Salidas:
      - Future<List<PuntajeJugadorFecha>>: listado de puntajes encontrados.
  */
  Future<List<PuntajeJugadorFecha>> obtenerPuntajesPorFecha(
    String idFecha,
  ) async {
    try {
      final query = await _db
          .collection("puntajes_reales")
          .where("idFecha", isEqualTo: idFecha)
          .orderBy("idJugadorReal")
          .get();

      _log.informacion("Listar puntajes reales de la fecha: $idFecha");

      return query.docs
          .map((doc) => PuntajeJugadorFecha.desdeMapa(doc.id, doc.data()))
          .toList();
    } catch (e) {
      _log.error("Error obteniendo puntajes reales de fecha: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPuntajeDeJugadorEnFecha
    Descripción:
      Busca un único puntaje correspondiente a un jugador real dentro de una
      fecha específica. Si no existe, devuelve null.
    Entradas:
      - idFecha (String): identificador de la fecha.
      - idJugadorReal (String): identificador del jugador real.
    Salidas:
      - Future<PuntajeJugadorFecha?>: instancia encontrada o null.
  */
  Future<PuntajeJugadorFecha?> obtenerPuntajeDeJugadorEnFecha(
    String idFecha,
    String idJugadorReal,
  ) async {
    try {
      final String idDoc = "${idFecha}_$idJugadorReal";

      final snap = await _db.collection("puntajes_reales").doc(idDoc).get();

      if (!snap.exists) {
        _log.informacion(
          "Puntaje no encontrado: jugador=$idJugadorReal fecha=$idFecha",
        );
        return null;
      }

      return PuntajeJugadorFecha.desdeMapa(snap.id, snap.data()!);
    } catch (e) {
      _log.error("Error obteniendo puntaje individual: $e");
      rethrow;
    }
  }
}
