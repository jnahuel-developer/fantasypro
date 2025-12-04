/*
  Archivo: servicio_puntajes_fantasy.dart
  Descripción:
    Servicio encargado de la gestión de puntajes fantasy asignados a equipos
    en fechas específicas dentro de una participación de liga.

  Responsabilidades:
    - Guardar el puntaje de un equipo fantasy en una fecha.
    - Recuperar puntaje fantasy dado una participación y una fecha.
    - Garantizar consistencia y seguridad de escritura en subcolección anidada.

  Dependencias:
    - FirebaseFirestore
    - PuntajeEquipoFantasy
    - ServicioLog
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/puntaje_equipo_fantasy.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioPuntajesFantasy {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de log para auditoría.
  final ServicioLog _log = ServicioLog();

  /// Sanitiza un ID antes de uso en Firestore.
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
    Nombre: guardarPuntajeEquipoFantasy
    Descripción:
      Persiste el puntaje de un equipo fantasy como documento en la subcolección
      de la participación correspondiente. Utiliza el idFecha como ID del documento.
    Entradas:
      - modelo (PuntajeEquipoFantasy): datos a guardar.
    Salidas:
      - Futuro void.
  */
  Future<void> guardarPuntajeEquipoFantasy(PuntajeEquipoFantasy modelo) async {
    try {
      final idParticipacion = _sanitizarId(modelo.idParticipacion);
      final idFecha = _sanitizarId(modelo.idFecha);

      if (idParticipacion.isEmpty || idFecha.isEmpty) {
        throw ArgumentError("ID de participación o fecha inválido.");
      }

      _log.informacion(
        "Guardando puntaje fantasy: "
        "participacion=$idParticipacion, fecha=$idFecha, puntos=${modelo.puntajeTotal}",
      );

      await _db
          .collection("participaciones_liga")
          .doc(idParticipacion)
          .collection("puntajes_fantasy")
          .doc(idFecha)
          .set(modelo.aMapa());
    } catch (e) {
      _log.error("Error al guardar puntaje fantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorParticipacionYFecha
    Descripción:
      Recupera el puntaje fantasy de un equipo, para una participación y fecha determinada.
    Entradas:
      - idParticipacion (String): ID de la participación.
      - idFecha (String): ID de la fecha.
    Salidas:
      - Futuro que puede devolver PuntajeEquipoFantasy o null si no existe.
  */
  Future<PuntajeEquipoFantasy?> obtenerPorParticipacionYFecha(
    String idParticipacion,
    String idFecha,
  ) async {
    try {
      idParticipacion = _sanitizarId(idParticipacion);
      idFecha = _sanitizarId(idFecha);

      if (idParticipacion.isEmpty || idFecha.isEmpty) {
        throw ArgumentError("ID de participación o fecha inválido.");
      }

      _log.informacion(
        "Obteniendo puntaje fantasy: participacion=$idParticipacion, fecha=$idFecha",
      );

      final doc = await _db
          .collection("participaciones_liga")
          .doc(idParticipacion)
          .collection("puntajes_fantasy")
          .doc(idFecha)
          .get();

      if (!doc.exists) return null;

      return PuntajeEquipoFantasy.desdeMapa(doc.id, doc.data() ?? {});
    } catch (e) {
      _log.error("Error al obtener puntaje fantasy: $e");
      rethrow;
    }
  }
}
