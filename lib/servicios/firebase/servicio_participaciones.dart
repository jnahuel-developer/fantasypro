/*
  Archivo: servicio_participaciones.dart
  Descripción:
    Servicio dedicado a la administración CRUD de la colección "participaciones_liga".
    Permite crear, obtener, editar, activar, archivar y eliminar participaciones
    de usuarios dentro de una liga.

  Dependencias:
    - cloud_firestore
    - modelos/participacion_liga.dart
    - servicio_log.dart

  Archivos que dependen de este archivo:
    - Controladores de participación en ligas
    - Flujos de alta de equipos fantasy y armado de plantel
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioParticipaciones {
  /// Instancia de Firestore para operaciones sobre la colección "participaciones_liga".
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logs para registrar operaciones relacionadas a participaciones.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearParticipacion
    Descripción:
      Crea una participación en una liga con los datos proporcionados.
    Entradas:
      - participacion (ParticipacionLiga): instancia con los datos de la participación.
    Salidas:
      - Future<ParticipacionLiga>: instancia con ID generado por Firestore.
  */
  Future<ParticipacionLiga> crearParticipacion(
    ParticipacionLiga participacion,
  ) async {
    try {
      final doc = await _db
          .collection("participaciones_liga")
          .add(participacion.aMapa());
      final nueva = participacion.copiarCon(id: doc.id);

      _log.informacion("Crear participación: ${nueva.id}");
      return nueva;
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: crearParticipacionEnLiga
    Descripción:
      Crea una participación nueva a partir del ID del usuario, ID de liga y nombre del equipo fantasy.
    Entradas:
      - idUsuario (String): ID del usuario participante.
      - idLiga (String): ID de la liga.
      - nombreEquipoFantasy (String): nombre elegido para el equipo.
    Salidas:
      - Future<ParticipacionLiga>: participación creada con ID asignado.
  */
  Future<ParticipacionLiga> crearParticipacionEnLiga(
    String idUsuario,
    String idLiga,
    String nombreEquipoFantasy,
  ) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final participacion = ParticipacionLiga(
        id: "",
        idLiga: idLiga,
        idUsuario: idUsuario,
        nombreEquipoFantasy: nombreEquipoFantasy,
        puntos: 0,
        fechaCreacion: timestamp,
        activo: true,
        plantelCompleto: false,
      );

      final doc = await _db
          .collection("participaciones_liga")
          .add(participacion.aMapa());
      final nueva = participacion.copiarCon(id: doc.id);

      _log.informacion(
        "Crear participación en liga: usuario=$idUsuario liga=$idLiga → ${nueva.id}",
      );

      return nueva;
    } catch (e) {
      _log.error("Error creando participación en liga: $e");
      rethrow;
    }
  }

  /*
    Nombre: usuarioYaParticipa
    Descripción:
      Verifica si un usuario ya tiene una participación activa en una liga.
    Entradas:
      - idUsuario (String): ID del usuario.
      - idLiga (String): ID de la liga.
    Salidas:
      - Future<bool>: true si ya participa, false en caso contrario.
  */
  Future<bool> usuarioYaParticipa(String idUsuario, String idLiga) async {
    try {
      final query = await _db
          .collection("participaciones_liga")
          .where("idUsuario", isEqualTo: idUsuario)
          .where("idLiga", isEqualTo: idLiga)
          .where("activo", isEqualTo: true)
          .limit(1)
          .get();

      final existe = query.docs.isNotEmpty;

      _log.informacion(
        "Verificar participación: usuario=$idUsuario liga=$idLiga → $existe",
      );

      return existe;
    } catch (e) {
      _log.error("Error validando participación: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerParticipacion
    Descripción:
      Devuelve la participación única de un usuario en una liga, si existe.
    Entradas:
      - idUsuario (String): ID del usuario.
      - idLiga (String): ID de la liga.
    Salidas:
      - Future<ParticipacionLiga?>: participación encontrada o null.
  */
  Future<ParticipacionLiga?> obtenerParticipacion(
    String idUsuario,
    String idLiga,
  ) async {
    try {
      final consulta = await _db
          .collection("participaciones_liga")
          .where("idUsuario", isEqualTo: idUsuario)
          .where("idLiga", isEqualTo: idLiga)
          .limit(1)
          .get();

      if (consulta.docs.isEmpty) {
        _log.informacion(
          "Participación no encontrada: usuario=$idUsuario liga=$idLiga",
        );
        return null;
      }

      final d = consulta.docs.first;
      return ParticipacionLiga.desdeMapa(d.id, d.data());
    } catch (e) {
      _log.error("Error obteniendo participación única: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorLiga
    Descripción:
      Devuelve todas las participaciones registradas para una liga dada.
    Entradas:
      - idLiga (String): ID de la liga.
    Salidas:
      - Future<List<ParticipacionLiga>>: lista de participaciones encontradas.
  */
  Future<List<ParticipacionLiga>> obtenerPorLiga(String idLiga) async {
    try {
      final consulta = await _db
          .collection("participaciones_liga")
          .where("idLiga", isEqualTo: idLiga)
          .get();

      _log.informacion("Listar participaciones de liga: $idLiga");

      return consulta.docs
          .map((d) => ParticipacionLiga.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorUsuario
    Descripción:
      Devuelve todas las participaciones del usuario, en cualquier liga.
    Entradas:
      - idUsuario (String): ID del usuario.
    Salidas:
      - Future<List<ParticipacionLiga>>: lista de participaciones.
  */
  Future<List<ParticipacionLiga>> obtenerPorUsuario(String idUsuario) async {
    try {
      final consulta = await _db
          .collection("participaciones_liga")
          .where("idUsuario", isEqualTo: idUsuario)
          .get();

      _log.informacion("Listar participaciones del usuario: $idUsuario");

      return consulta.docs
          .map((d) => ParticipacionLiga.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarParticipacion
    Descripción:
      Actualiza los datos de una participación existente.
    Entradas:
      - participacion (ParticipacionLiga): instancia con datos actualizados.
    Salidas:
      - Future<void>
  */
  Future<void> editarParticipacion(ParticipacionLiga participacion) async {
    try {
      await _db
          .collection("participaciones_liga")
          .doc(participacion.id)
          .update(participacion.aMapa());

      _log.informacion("Editar participación: ${participacion.id}");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarParticipacion
    Descripción:
      Marca una participación como inactiva (activo = false).
    Entradas:
      - id (String): ID de la participación.
    Salidas:
      - Future<void>
  */
  Future<void> archivarParticipacion(String id) async {
    try {
      await _db.collection("participaciones_liga").doc(id).update({
        "activo": false,
      });

      _log.informacion("Archivar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarParticipacion
    Descripción:
      Marca una participación como activa (activo = true).
    Entradas:
      - id (String): ID de la participación.
    Salidas:
      - Future<void>
  */
  Future<void> activarParticipacion(String id) async {
    try {
      await _db.collection("participaciones_liga").doc(id).update({
        "activo": true,
      });

      _log.informacion("Activar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarParticipacion
    Descripción:
      Elimina definitivamente una participación de Firestore.
    Entradas:
      - id (String): ID de la participación.
    Salidas:
      - Future<void>
  */
  Future<void> eliminarParticipacion(String id) async {
    try {
      await _db.collection("participaciones_liga").doc(id).delete();

      _log.informacion("Eliminar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }
}
