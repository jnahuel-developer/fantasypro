/*
  Archivo: servicio_alineaciones.dart
  Descripción:
    Servicio responsable de administrar las alineaciones fantasy creadas por el usuario
    dentro de una liga. Permite crear, modificar, archivar, activar y eliminar alineaciones,
    así como guardar el plantel inicial y la alineación base de cada equipo.

  Dependencias:
    - cloud_firestore
    - modelos/alineacion.dart
    - servicio_log.dart

  Archivos que dependen de este archivo:
    - Controladores del flujo de armado de plantel inicial
    - Controladores de gestión de alineaciones por fecha
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class ServicioAlineaciones {
  /// Instancia de Firestore para acceder a la colección de alineaciones.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logs para registrar eventos y errores.
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

  /// Validación de IDs obligatorios
  void _validarIds(String idUsuario, String idLiga) {
    if (idUsuario.isEmpty || idLiga.isEmpty) {
      throw ArgumentError("ID sanitizado inválido.");
    }
  }

  /// Validación y orden de listas
  List<String> _validarYOrdenarLista(List<String> lista, String nombreCampo) {
    final limpia = lista
        .map(_sanitizarId)
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();
    if (limpia.length != lista.length) {
      throw ArgumentError(
        "Lista '$nombreCampo' contiene elementos vacíos o inválidos.",
      );
    }
    limpia.sort();
    return limpia;
  }

  /*
    Nombre: crearAlineacion
    Descripción:
      Crea una nueva alineación fantasy para un usuario en una liga.
    Entradas:
      - alineacion (Alineacion): instancia a almacenar.
    Salidas:
      - Future<Alineacion>: instancia creada con ID asignado por Firestore.
  */
  Future<Alineacion> crearAlineacion(Alineacion alineacion) async {
    try {
      final datos = alineacion.copiarCon(
        idUsuario: _sanitizarId(alineacion.idUsuario),
        idLiga: _sanitizarId(alineacion.idLiga),
        idEquipoFantasy: _sanitizarId(alineacion.idEquipoFantasy),
        idsTitulares: _validarYOrdenarLista(
          alineacion.idsTitulares,
          "idsTitulares",
        ),
        idsSuplentes: _validarYOrdenarLista(
          alineacion.idsSuplentes,
          "idsSuplentes",
        ),
        jugadoresSeleccionados: _validarYOrdenarLista(
          alineacion.jugadoresSeleccionados,
          "jugadoresSeleccionados",
        ),
      );

      _validarIds(datos.idUsuario, datos.idLiga);

      final doc = await _db.collection("alineaciones").add(datos.aMapa());
      final nueva = datos.copiarCon(id: doc.id);

      _log.informacion("Crear alineación: ${nueva.id}");
      return nueva;
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: guardarPlantelInicial
    Descripción:
      Registra el plantel inicial de un equipo fantasy antes de iniciar la temporada,
      guardando los jugadores seleccionados pero sin titulares ni formación aún.
    Entradas:
      - idEquipoFantasy (String): ID del equipo fantasy.
      - idLiga (String): ID de la liga.
      - idUsuario (String): ID del usuario propietario.
      - idsJugadoresPlantel (List<String>): IDs de los jugadores seleccionados.
    Salidas:
      - Future<Alineacion>: alineación registrada.
  */
  Future<Alineacion> guardarPlantelInicial(
    String idEquipoFantasy,
    String idLiga,
    String idUsuario,
    List<String> idsJugadoresPlantel,
  ) async {
    try {
      idLiga = _sanitizarId(idLiga);
      idUsuario = _sanitizarId(idUsuario);
      idEquipoFantasy = _sanitizarId(idEquipoFantasy);
      _validarIds(idUsuario, idLiga);

      final jugadores = _validarYOrdenarLista(
        idsJugadoresPlantel,
        "jugadoresSeleccionados",
      );

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final alineacion = Alineacion(
        id: "",
        idLiga: idLiga,
        idUsuario: idUsuario,
        idEquipoFantasy: idEquipoFantasy,
        idsTitulares: const [],
        idsSuplentes: const [],
        jugadoresSeleccionados: jugadores,
        formacion: "",
        puntosTotales: 0,
        fechaCreacion: timestamp,
        activo: true,
      );

      final doc = await _db.collection("alineaciones").add(alineacion.aMapa());
      final creada = alineacion.copiarCon(id: doc.id);

      _log.informacion(
        "Guardar plantel inicial: equipoFantasy=$idEquipoFantasy alineacion=${creada.id}",
      );

      return creada;
    } catch (e) {
      _log.error("Error guardando plantel inicial: $e");
      rethrow;
    }
  }

  /*
    Nombre: guardarAlineacionInicial
    Descripción:
      Guarda los titulares, suplentes y formación táctica de una alineación específica.
    Entradas:
      - idAlineacion (String): ID de la alineación a modificar.
      - formacion (String): nombre del esquema táctico (ej: "4-3-3").
      - idsTitulares (List<String>): lista de IDs de los jugadores titulares.
      - idsSuplentes (List<String>): lista de IDs de los jugadores suplentes.
    Salidas:
      - Future<void>
  */
  Future<void> guardarAlineacionInicial(
    String idAlineacion,
    String formacion,
    List<String> idsTitulares,
    List<String> idsSuplentes,
  ) async {
    try {
      idAlineacion = _sanitizarId(idAlineacion);
      if (idAlineacion.isEmpty) throw ArgumentError("ID inválido.");

      final titulares = _validarYOrdenarLista(idsTitulares, "idsTitulares");
      final suplentes = _validarYOrdenarLista(idsSuplentes, "idsSuplentes");
      final combinados = [...titulares, ...suplentes]..sort();

      await _db.collection("alineaciones").doc(idAlineacion).update({
        "formacion": formacion,
        "idsTitulares": titulares,
        "idsSuplentes": suplentes,
        "jugadoresSeleccionados": combinados,
      });

      _log.informacion("Guardar alineación inicial: $idAlineacion");
    } catch (e) {
      _log.error("Error guardando alineación inicial: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerPorUsuarioEnLiga
    Descripción:
      Devuelve todas las alineaciones que un usuario ha registrado en una liga específica.
    Entradas:
      - idLiga (String): ID de la liga.
      - idUsuario (String): ID del usuario.
    Salidas:
      - Future<List<Alineacion>>: lista de alineaciones encontradas.
  */
  Future<List<Alineacion>> obtenerPorUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    try {
      idLiga = _sanitizarId(idLiga);
      idUsuario = _sanitizarId(idUsuario);
      _validarIds(idUsuario, idLiga);

      final consulta = await _db
          .collection("alineaciones")
          .where("idLiga", isEqualTo: idLiga)
          .where("idUsuario", isEqualTo: idUsuario)
          .get();

      if (consulta.docs.length > 1) {
        _log.advertencia(
          "Múltiples alineaciones encontradas para usuario=$idUsuario y liga=$idLiga",
        );
      }

      _log.informacion(
        "Listar alineaciones de usuario $idUsuario en liga $idLiga",
      );

      return consulta.docs
          .map((d) => Alineacion.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: editarAlineacion
    Descripción:
      Devuelve todas las alineaciones que un usuario ha registrado en una liga específica.
    Entradas:
      - idLiga (String): ID de la liga.
      - idUsuario (String): ID del usuario.
    Salidas:
      - Future<List<Alineacion>>: lista de alineaciones encontradas.
  */
  Future<void> editarAlineacion(Alineacion alineacion) async {
    try {
      final datos = alineacion.copiarCon(
        idUsuario: _sanitizarId(alineacion.idUsuario),
        idLiga: _sanitizarId(alineacion.idLiga),
        idEquipoFantasy: _sanitizarId(alineacion.idEquipoFantasy),
        idsTitulares: _validarYOrdenarLista(
          alineacion.idsTitulares,
          "idsTitulares",
        ),
        idsSuplentes: _validarYOrdenarLista(
          alineacion.idsSuplentes,
          "idsSuplentes",
        ),
        jugadoresSeleccionados: _validarYOrdenarLista(
          alineacion.jugadoresSeleccionados,
          "jugadoresSeleccionados",
        ),
      );

      _validarIds(datos.idUsuario, datos.idLiga);

      await _db.collection("alineaciones").doc(datos.id).update(datos.aMapa());

      _log.informacion("Editar alineación: ${datos.id}");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: archivarAlineacion
    Descripción:
      Marca una alineación como inactiva (activo = false).
    Entradas:
      - id (String): ID de la alineación a archivar.
    Salidas:
      - Future<void>
  */
  Future<void> archivarAlineacion(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection("alineaciones").doc(id).update({"activo": false});

      _log.informacion("Archivar alineación: $id");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: activarAlineacion
    Descripción:
      Marca una alineación como activa (activo = true).
    Entradas:
      - id (String): ID de la alineación a activar.
    Salidas:
      - Future<void>
  */
  Future<void> activarAlineacion(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection("alineaciones").doc(id).update({"activo": true});

      _log.informacion("Activar alineación: $id");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: eliminarAlineacion
    Descripción:
      Elimina permanentemente una alineación de la base de datos.
    Entradas:
      - id (String): ID de la alineación a eliminar.
    Salidas:
      - Future<void>
  */
  Future<void> eliminarAlineacion(String id) async {
    try {
      id = _sanitizarId(id);
      if (id.isEmpty) throw ArgumentError("ID inválido.");

      await _db.collection("alineaciones").doc(id).delete();

      _log.informacion("Eliminar alineación: $id");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }

  /*
    Nombre: obtenerAlineacionesActivasPorLiga
    Firma: Future<List<Alineacion>> obtenerAlineacionesActivasPorLiga(String idLiga)
    Descripción:
      Devuelve todas las alineaciones activas de una liga, usadas para calcular puntajes fantasy.
    Ejemplo:
      final alineaciones = await servicio.obtenerAlineacionesActivasPorLiga("liga123");
  */
  Future<List<Alineacion>> obtenerAlineacionesActivasPorLiga(
    String idLiga,
  ) async {
    try {
      idLiga = _sanitizarId(idLiga);
      if (idLiga.isEmpty) {
        throw ArgumentError("ID de liga inválido.");
      }

      _log.informacion("Listando alineaciones activas de la liga $idLiga");

      final query = await _db
          .collection("alineaciones")
          .where("idLiga", isEqualTo: idLiga)
          .where("activo", isEqualTo: true)
          .get();

      return query.docs
          .map((d) => Alineacion.desdeMapa(d.id, d.data()))
          .toList();
    } catch (e) {
      _log.error("Error al obtener alineaciones activas: $e");
      rethrow;
    }
  }
}
