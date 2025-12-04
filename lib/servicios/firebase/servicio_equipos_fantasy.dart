/*
  Archivo: servicio_equipos_fantasy.dart
  Descripción:
    Servicio encargado de administrar la colección "equipos_fantasy".
    Permite crear, consultar, editar, activar, archivar y eliminar
    equipos fantasy creados por usuarios dentro de una liga.

  Dependencias:
    - cloud_firestore
    - modelos/equipo_fantasy.dart
    - servicio_log.dart

  Archivos que dependen de este archivo:
    - Controladores del flujo de usuario final (creación de equipo fantasy).
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/equipo_fantasy.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioEquiposFantasy {
  /// Instancia de Firestore.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logging.
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

  /// Validación de IDs obligatorios
  void _validarIdsObligatorios(String idUsuario, String idLiga) {
    if (idUsuario.isEmpty || idLiga.isEmpty) {
      throw ArgumentError("ID sanitizado inválido.");
    }
  }

  /*
    Nombre: crearEquipoFantasy
    Descripción:
      Crea un equipo fantasy para el usuario dentro de una liga.
      Mantiene compatibilidad con código existente delegando en
      crearEquipoFantasyParaUsuario con presupuesto inicial por defecto.
    Entradas:
      - idUsuario (String): usuario propietario.
      - idLiga (String): liga asociada.
      - nombre (String): nombre del equipo.
    Salidas:
      - Future<EquipoFantasy>: instancia creada.
  */
  Future<EquipoFantasy> crearEquipoFantasy(
    String idUsuario,
    String idLiga,
    String nombre,
  ) async {
    return crearEquipoFantasyParaUsuario(idUsuario, idLiga, nombre);
  }

  /*
    Nombre: crearEquipoFantasyParaUsuario
    Descripción:
      Crea un equipo fantasy para un usuario en una liga, inicializando
      presupuesto inicial, presupuesto restante y un plantel vacío.
    Entradas:
      - idUsuario (String): usuario propietario.
      - idLiga (String): liga asociada.
      - nombre (String): nombre del equipo.
      - presupuestoInicial (int): presupuesto inicial asignado.
    Salidas:
      - Future<EquipoFantasy>: instancia creada.
  */
  Future<EquipoFantasy> crearEquipoFantasyParaUsuario(
    String idUsuario,
    String idLiga,
    String nombre, {
    int presupuestoInicial = 1000,
  }) async {
    try {
      idUsuario = _sanitizarId(idUsuario);
      idLiga = _sanitizarId(idLiga);
      _validarIdsObligatorios(idUsuario, idLiga);

      final equipo = EquipoFantasy(
        id: "",
        idUsuario: idUsuario,
        idLiga: idLiga,
        nombre: nombre,
        presupuestoInicial: presupuestoInicial,
        presupuestoRestante: presupuestoInicial,
        idsJugadoresPlantel: const [],
        fechaCreacion: DateTime.now().millisecondsSinceEpoch,
        activo: true,
      );

      final doc = await _db.collection("equipos_fantasy").add(equipo.aMapa());
      final creado = equipo.copiarCon(id: doc.id);

      _log.informacion(
        "EquipoFantasy creado: usuario=$idUsuario liga=$idLiga → ${creado.id}",
      );

      return creado;
    } catch (e) {
      _log.error("Error creando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerEquipoFantasyDeUsuario
    Descripción:
      Obtiene un único equipo fantasy de un usuario en una liga dada.
      Devuelve null si no existe.
    Entradas:
      - idUsuario (String)
      - idLiga (String)
    Salidas:
      - Future<EquipoFantasy?>
  */
  Future<EquipoFantasy?> obtenerEquipoFantasyDeUsuario(
    String idUsuario,
    String idLiga,
  ) async {
    try {
      idUsuario = _sanitizarId(idUsuario);
      idLiga = _sanitizarId(idLiga);
      _validarIdsObligatorios(idUsuario, idLiga);

      final query = await _db
          .collection("equipos_fantasy")
          .where('idUsuario', isEqualTo: idUsuario)
          .where('idLiga', isEqualTo: idLiga)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _log.informacion(
          "EquipoFantasy no encontrado: usuario=$idUsuario liga=$idLiga",
        );
        return null;
      }

      if (query.docs.length > 1) {
        _log.advertencia(
          "Múltiples equipos fantasy encontrados para usuario=$idUsuario y liga=$idLiga. Usando el primero.",
        );
      }

      final d = query.docs.first;
      return EquipoFantasy.desdeMapa(d.id, d.data());
    } catch (e) {
      _log.error("Error obteniendo EquipoFantasy de usuario: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorUsuarioYLiga
    Descripción:
      Obtiene todos los equipos fantasy de un usuario en una liga dada.
    Entradas:
      - idUsuario (String)
      - idLiga (String)
    Salidas:
      - Future<List<EquipoFantasy>>
  */
  Future<List<EquipoFantasy>> obtenerPorUsuarioYLiga(
    String idUsuario,
    String idLiga,
  ) async {
    try {
      idUsuario = _sanitizarId(idUsuario);
      idLiga = _sanitizarId(idLiga);
      _validarIdsObligatorios(idUsuario, idLiga);

      final query = await _db
          .collection("equipos_fantasy")
          .where('idUsuario', isEqualTo: idUsuario)
          .where('idLiga', isEqualTo: idLiga)
          .get();

      _log.informacion(
        "Listar equipos fantasy: usuario=$idUsuario liga=$idLiga",
      );

      return query.docs
          .map((d) => EquipoFantasy.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error listando equipos fantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarEquipoFantasy
    Descripción:
      Actualiza un equipo fantasy existente.
    Entradas:
      - equipo (EquipoFantasy): datos actualizados.
    Salidas:
      - Future<void>
  */
  Future<void> editarEquipoFantasy(EquipoFantasy equipo) async {
    try {
      final datos = equipo.copiarCon(
        idUsuario: _sanitizarId(equipo.idUsuario),
        idLiga: _sanitizarId(equipo.idLiga),
      );

      _validarIdsObligatorios(datos.idUsuario, datos.idLiga);

      await _db
          .collection("equipos_fantasy")
          .doc(datos.id)
          .update(datos.aMapa());

      _log.informacion("EquipoFantasy editado: ${datos.id}");
    } catch (e) {
      _log.error("Error editando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarEquipoFantasy
    Descripción:
      Marca un equipo fantasy como inactivo.
    Entradas:
      - id (String)
    Salidas:
      - Future<void>
  */
  Future<void> archivarEquipoFantasy(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection("equipos_fantasy").doc(id).update({'activo': false});

      _log.informacion("EquipoFantasy archivado: $id");
    } catch (e) {
      _log.error("Error archivando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarEquipoFantasy
    Descripción:
      Marca un equipo fantasy como activo.
    Entradas:
      - id (String)
    Salidas:
      - Future<void>
  */
  Future<void> activarEquipoFantasy(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection("equipos_fantasy").doc(id).update({'activo': true});

      _log.informacion("EquipoFantasy activado: $id");
    } catch (e) {
      _log.error("Error activando EquipoFantasy: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarEquipoFantasy
    Descripción:
      Elimina un equipo fantasy de Firestore.
    Entradas:
      - id (String)
    Salidas:
      - Future<void>
  */
  Future<void> eliminarEquipoFantasy(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection("equipos_fantasy").doc(id).delete();

      _log.informacion("EquipoFantasy eliminado: $id");
    } catch (e) {
      _log.error("Error eliminando EquipoFantasy: $e");
      rethrow;
    }
  }
}
