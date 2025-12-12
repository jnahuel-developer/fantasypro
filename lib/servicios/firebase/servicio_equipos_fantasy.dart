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
import 'package:fantasypro/textos/textos_app.dart';
import 'servicio_base_de_datos.dart';

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
      throw ArgumentError(TextosApp.ERR_SERVICIO_ID_SANITIZADO_INVALIDO);
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

      final doc =
          await _db.collection(ColFirebase.equiposFantasy).add(equipo.aMapa());
      final creado = equipo.copiarCon(id: doc.id);

      _log.informacion(
        "${TextosApp.LOG_EQUIPO_FANTASY_CREADO} usuario=$idUsuario liga=$idLiga → ${creado.id}",
      );

      return creado;
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_CREAR} $e");
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
          .collection(ColFirebase.equiposFantasy)
          .where(CamposFirebase.idUsuario, isEqualTo: idUsuario)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _log.informacion(
          "${TextosApp.LOG_EQUIPO_FANTASY_NO_ENCONTRADO} usuario=$idUsuario liga=$idLiga",
        );
        return null;
      }

      if (query.docs.length > 1) {
        _log.advertencia(
          TextosApp.LOG_EQUIPO_FANTASY_ADVERTENCIA_MULTIPLES
              .replaceFirst('{USUARIO}', idUsuario)
              .replaceFirst('{LIGA}', idLiga),
        );
      }

      final d = query.docs.first;
      return EquipoFantasy.desdeMapa(d.id, d.data());
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_OBTENER} $e");
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
          .collection(ColFirebase.equiposFantasy)
          .where(CamposFirebase.idUsuario, isEqualTo: idUsuario)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .get();

      _log.informacion(
        TextosApp.LOG_EQUIPO_FANTASY_LISTAR_USUARIO_LIGA
            .replaceFirst('{USUARIO}', idUsuario)
            .replaceFirst('{LIGA}', idLiga),
      );

      return query.docs
          .map((d) => EquipoFantasy.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_LISTAR} $e");
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
          .collection(ColFirebase.equiposFantasy)
          .doc(datos.id)
          .update(datos.aMapa());

      _log.informacion("${TextosApp.LOG_EQUIPO_FANTASY_EDITADO} ${datos.id}");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_EDITAR} $e");
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
      if (id.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_INVALIDO);
      }

      await _db
          .collection(ColFirebase.equiposFantasy)
          .doc(id)
          .update({CamposFirebase.activo: false});

      _log.informacion("${TextosApp.LOG_EQUIPO_FANTASY_ARCHIVADO} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_ARCHIVAR} $e");
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
      if (id.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_INVALIDO);
      }

      await _db
          .collection(ColFirebase.equiposFantasy)
          .doc(id)
          .update({CamposFirebase.activo: true});

      _log.informacion("${TextosApp.LOG_EQUIPO_FANTASY_ACTIVADO} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_ACTIVAR} $e");
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
      if (id.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_INVALIDO);
      }

      await _db.collection(ColFirebase.equiposFantasy).doc(id).delete();

      _log.informacion("${TextosApp.LOG_EQUIPO_FANTASY_ELIMINADO} $id");
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_ELIMINAR} $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerActivosPorLiga
    Firma: Future<List<EquipoFantasy>> obtenerActivosPorLiga(String idLiga)
    Descripción:
      Devuelve todos los equipos fantasy activos asociados a una liga dada.
    Ejemplo:
      final equipos = await servicio.obtenerActivosPorLiga("liga123");
  */
  Future<List<EquipoFantasy>> obtenerActivosPorLiga(String idLiga) async {
    try {
      idLiga = _sanitizarId(idLiga);
      if (idLiga.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_LIGA_INVALIDO);
      }

      _log.informacion(
        "${TextosApp.LOG_EQUIPO_FANTASY_LISTANDO_ACTIVOS} $idLiga",
      );

      final query = await _db
          .collection(ColFirebase.equiposFantasy)
          .where(CamposFirebase.idLiga, isEqualTo: idLiga)
          .where(CamposFirebase.activo, isEqualTo: true)
          .get();

      return query.docs
          .map((d) => EquipoFantasy.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_ACTIVOS} $e");
      rethrow;
    }
  }

  Future<void> actualizarPlantel(
    String idEquipoFantasy,
    List<String> idsJugadores,
    int presupuestoRestante,
  ) async {
    try {
      final idSan = _sanitizarId(idEquipoFantasy);
      if (idSan.isEmpty) {
        throw ArgumentError(TextosApp.ERR_SERVICIO_ID_EQUIPO_INVALIDO);
      }

      await _db.collection(ColFirebase.equiposFantasy).doc(idSan).update({
        CamposFirebase.idsJugadoresPlantel: idsJugadores,
        CamposFirebase.presupuestoRestante: presupuestoRestante,
      });

      _log.informacion(
        "${TextosApp.LOG_EQUIPO_FANTASY_PLANTEL_ACTUALIZADO} $idEquipoFantasy",
      );
    } catch (e) {
      _log.error("${TextosApp.LOG_EQUIPO_FANTASY_ERROR_PLANTEL} $e");
      rethrow;
    }
  }
}
