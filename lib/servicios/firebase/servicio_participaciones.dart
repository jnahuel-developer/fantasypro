/*
  Archivo: servicio_participaciones.dart
  Descripción:
    Servicio dedicado a la administración CRUD de la colección "participaciones_liga".
    Permite crear, obtener, editar, activar, archivar y eliminar participaciones
    de usuarios dentro de una liga. Todas las operaciones aplican sanitización
    de IDs y validación posterior, para garantizar consistencia y evitar errores
    de consultas vacías o mal formateadas.

  Dependencias:
    - cloud_firestore
    - modelos/participacion_liga.dart
    - servicio_log.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'servicio_base_de_datos.dart';

class ServicioParticipaciones {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  String _sanitizarId(String valor) {
    return valor
        .trim()
        .replaceAll('"', '')
        .replaceAll("'", "")
        .replaceAll("\\", "")
        .replaceAll("\n", "")
        .replaceAll("\r", "");
  }

  void _validarIdsObligatorios(String idUsuario, String idLiga) {
    if (idUsuario.isEmpty || idLiga.isEmpty) {
      throw ArgumentError("ID sanitizado inválido.");
    }
  }

  Future<ParticipacionLiga> crearParticipacion(
    ParticipacionLiga participacion,
  ) async {
    try {
      final datos = participacion.copiarCon(
        idUsuario: _sanitizarId(participacion.idUsuario),
        idLiga: _sanitizarId(participacion.idLiga),
      );

      _validarIdsObligatorios(datos.idUsuario, datos.idLiga);

      final doc =
          await _db.collection(ColFirebase.participaciones).add(datos.aMapa());

      final nueva = datos.copiarCon(id: doc.id);

      _log.informacion("Crear participación: ${nueva.id}");
      return nueva;
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  Future<ParticipacionLiga> crearParticipacionEnLiga(
    String idUsuario,
    String idLiga,
    String nombreEquipoFantasy,
  ) async {
    try {
      idUsuario = _sanitizarId(idUsuario);
      idLiga = _sanitizarId(idLiga);

      _validarIdsObligatorios(idUsuario, idLiga);

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
          .collection(ColFirebase.participaciones)
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

  Future<bool> usuarioYaParticipa(String idUsuario, String idLiga) async {
    try {
      idUsuario = _sanitizarId(idUsuario);
      idLiga = _sanitizarId(idLiga);

      _validarIdsObligatorios(idUsuario, idLiga);

      final query = await _db
          .collection(ColFirebase.participaciones)
          .where(CamposFirebase.idUsuario, isEqualTo: idUsuario)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .where(CamposFirebase.activo, isEqualTo: true)
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

  Future<ParticipacionLiga?> obtenerParticipacion(
    String idUsuario,
    String idLiga,
  ) async {
    try {
      idUsuario = _sanitizarId(idUsuario);
      idLiga = _sanitizarId(idLiga);

      _validarIdsObligatorios(idUsuario, idLiga);

      final consulta = await _db
          .collection(ColFirebase.participaciones)
          .where(CamposFirebase.idUsuario, isEqualTo: idUsuario)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .limit(1)
          .get();

      if (consulta.docs.isEmpty) {
        _log.informacion(
          "Participación no encontrada: usuario=$idUsuario liga=$idLiga",
        );
        return null;
      }

      if (consulta.docs.length > 1) {
        _log.advertencia(
          "Múltiples participaciones encontradas para usuario=$idUsuario y liga=$idLiga. Usando la primera.",
        );
      }

      final d = consulta.docs.first;
      return ParticipacionLiga.desdeMapa(d.id, d.data());
    } catch (e) {
      _log.error("Error obteniendo participación única: $e");
      rethrow;
    }
  }

  Future<List<ParticipacionLiga>> obtenerPorLiga(String idLiga) async {
    try {
      idLiga = _sanitizarId(idLiga);
      if (idLiga.isEmpty) throw ArgumentError("ID de liga inválido.");

      final consulta = await _db
          .collection(ColFirebase.participaciones)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
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

  Future<List<ParticipacionLiga>> obtenerPorUsuario(String idUsuario) async {
    try {
      idUsuario = _sanitizarId(idUsuario);
      if (idUsuario.isEmpty) throw ArgumentError("ID de usuario inválido.");

      final consulta = await _db
          .collection(ColFirebase.participaciones)
          .where(CamposFirebase.idUsuario, isEqualTo: idUsuario)
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
    Actualiza únicamente los campos permitidos de una participación existente.
    Evita enviar campos de identidad para cumplir con las reglas de Firestore.
  Entradas:
    - participacion (ParticipacionLiga): instancia con datos editables.
  Salidas:
    - Future<void>
*/
  Future<void> editarParticipacion(ParticipacionLiga participacion) async {
    try {
      // Sanitizar ID del documento
      final String idSan = _sanitizarId(participacion.id);
      if (idSan.isEmpty) {
        throw ArgumentError("ID de participación inválido.");
      }

      // Construcción explícita de campos editables permitidos
      final actualizacion = {
        CamposFirebase.puntos: participacion.puntos,
        CamposFirebase.plantelCompleto: participacion.plantelCompleto,
        CamposFirebase.nombreEquipoFantasy: participacion.nombreEquipoFantasy
            .trim(), // limpieza mínima
        CamposFirebase.activo: participacion.activo,
      };

      _log.informacion(
        "Editando participación $idSan con campos: $actualizacion",
      );

      await _db
          .collection(ColFirebase.participaciones)
          .doc(idSan)
          .update(actualizacion);
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  Future<void> archivarParticipacion(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection(ColFirebase.participaciones).doc(id).update({
        CamposFirebase.activo: false,
      });

      _log.informacion("Archivar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  Future<void> activarParticipacion(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection(ColFirebase.participaciones).doc(id).update({
        CamposFirebase.activo: true,
      });

      _log.informacion("Activar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  Future<void> eliminarParticipacion(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection(ColFirebase.participaciones).doc(id).delete();

      _log.informacion("Eliminar participación: $id");
    } catch (e) {
      _log.error("Error en operación de participaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerActivasPorLiga
    Firma: Future<List<ParticipacionLiga>> obtenerActivasPorLiga(String idLiga)
    Descripción:
      Devuelve todas las participaciones activas de una liga.
    Ejemplo:
      final participantes = await servicio.obtenerActivasPorLiga("ligaABC");
  */
  Future<List<ParticipacionLiga>> obtenerActivasPorLiga(String idLiga) async {
    try {
      idLiga = _sanitizarId(idLiga);
      if (idLiga.isEmpty) {
        throw ArgumentError("ID de liga inválido.");
      }

      _log.informacion("Listando participaciones activas de la liga $idLiga");

      final query = await _db
          .collection(ColFirebase.participaciones)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .where(CamposFirebase.activo, isEqualTo: true)
          .get();

      return query.docs
          .map((d) => ParticipacionLiga.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error al obtener participaciones activas: $e");
      rethrow;
    }
  }

  /*
    Nombre: incrementarPuntosParticipacion
    Firma: Future<void> incrementarPuntosParticipacion(String idParticipacion, int delta)
    Descripción:
      Incrementa de forma atómica el campo "puntos" en una participación de liga.
    Ejemplo:
      await servicio.incrementarPuntosParticipacion("part123", 18);
  */
  Future<void> incrementarPuntosParticipacion(
    String idParticipacion,
    int delta,
  ) async {
    try {
      final idSan = _sanitizarId(idParticipacion);
      if (idSan.isEmpty) {
        throw ArgumentError("ID de participación inválido.");
      }

      _log.informacion("Incrementando $delta puntos en participación $idSan");

      await _db.collection(ColFirebase.participaciones).doc(idSan).update({
        CamposFirebase.puntos: FieldValue.increment(delta),
      });
    } catch (e) {
      _log.error("Error al incrementar puntos en participación: $e");
      rethrow;
    }
  }
}
