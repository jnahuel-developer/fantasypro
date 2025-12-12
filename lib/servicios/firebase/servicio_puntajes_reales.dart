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
import 'package:fantasypro/textos/textos_app.dart';
import 'servicio_base_de_datos.dart';

class ServicioPuntajesReales {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logging interno.
  final ServicioLog _log = ServicioLog();

  /// Sanitización universal de IDs
  String _sanitizarId(String valor) {
    return valor
        .trim()
        .replaceAll('"', '')
        .replaceAll("'", "")
        .replaceAll("\\", "")
        .replaceAll("\n", "")
        .replaceAll("\r", "");
  }

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
      final coleccion = _db.collection(ColFirebase.puntajesReales);

      for (final p in puntajes) {
        // ID determinístico: asegura UN SOLO documento por (fecha, jugador).
        final String idDoc = "${idFecha}_${p.idJugadorReal}";

        final docRef = coleccion.doc(idDoc);

        batch.set(docRef, {
          ...p.aMapa(),
          CamposFirebase.id: idDoc,
          CamposFirebase.idLiga: idLiga,
          CamposFirebase.idFecha: idFecha,
        }, SetOptions(merge: true));
      }

      await batch.commit();
      _log.informacion(
        "${TextosApp.LOG_PUNTAJES_REALES_GUARDAR} fecha=$idFecha total=${puntajes.length}",
      );
    } catch (e) {
      _log.error("${TextosApp.LOG_PUNTAJES_REALES_ERROR_GUARDAR} $e");
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
          .collection(ColFirebase.puntajesReales)
          .where(CamposFirebase.idFecha, isEqualTo: idFecha)
          .get();

      _log.informacion("${TextosApp.LOG_PUNTAJES_REALES_LISTAR_FECHA} $idFecha");

      final lista = query.docs
          .map((doc) => PuntajeJugadorFecha.desdeMapa(doc.id, doc.data()))
          .toList();

      // Ordenar en memoria si es necesario
      lista.sort((a, b) => a.idJugadorReal.compareTo(b.idJugadorReal));

      return lista;
    } catch (e) {
      _log.error("${TextosApp.LOG_PUNTAJES_REALES_ERROR_OBTENER} $e");
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

      final snap =
          await _db.collection(ColFirebase.puntajesReales).doc(idDoc).get();

      if (!snap.exists) {
        _log.informacion(
          "${TextosApp.LOG_PUNTAJE_NO_ENCONTRADO} jugador=$idJugadorReal fecha=$idFecha",
        );
        return null;
      }

      return PuntajeJugadorFecha.desdeMapa(snap.id, snap.data()!);
    } catch (e) {
      _log.error("${TextosApp.LOG_PUNTAJES_REALES_ERROR_INDIVIDUAL} $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerMapaPuntajesPorLigaYFecha
    Firma: Future<Map<String, int>> obtenerMapaPuntajesPorLigaYFecha(String idLiga, String idFecha)
    Descripción:
      Devuelve un mapa con los puntajes reales de jugadores para una fecha y liga dada.
      Se filtran únicamente jugadores activos y con puntaje asignado.
    Ejemplo:
      final mapa = await servicio.obtenerMapaPuntajesPorLigaYFecha("idLigaX", "fecha1");
  */
  Future<Map<String, int>> obtenerMapaPuntajesPorLigaYFecha(
    String idLiga,
    String idFecha,
  ) async {
    try {
      idLiga = _sanitizarId(idLiga);
      idFecha = _sanitizarId(idFecha);

      if (idLiga.isEmpty || idFecha.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_LIGA_O_FECHA_INVALIDO);
      }

      _log.informacion(
        "${TextosApp.LOG_PUNTAJES_REALES_OBTENER_LIGA_FECHA} liga=$idLiga fecha=$idFecha",
      );

      final query = await _db
          .collection(ColFirebase.puntajesReales)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .where(CamposFirebase.idFecha, isEqualTo: idFecha)
          .get();

      final mapa = <String, int>{};

      for (final doc in query.docs) {
        final data = doc.data();
        final String idJugador =
            _sanitizarId(data[CamposFirebase.idJugadorReal] ?? '');
        final int puntaje = data[CamposFirebase.puntuacion] ?? 0;

        if (idJugador.isNotEmpty) {
          mapa[idJugador] = puntaje;
        }
      }

      return mapa;
    } catch (e) {
      _log.error("${TextosApp.LOG_PUNTAJES_REALES_ERROR_MAPA} $e");
      rethrow;
    }
  }
}
