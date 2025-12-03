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
      final doc = await _db.collection("alineaciones").add(alineacion.aMapa());
      final nueva = alineacion.copiarCon(id: doc.id);

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
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final alineacion = Alineacion(
        id: "",
        idLiga: idLiga,
        idUsuario: idUsuario,
        idEquipoFantasy: idEquipoFantasy,
        idsTitulares: const [],
        idsSuplentes: const [],
        jugadoresSeleccionados: idsJugadoresPlantel,
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
      final idsCombinados = <String>[...idsTitulares, ...idsSuplentes];

      await _db.collection("alineaciones").doc(idAlineacion).update({
        "formacion": formacion,
        "idsTitulares": idsTitulares,
        "idsSuplentes": idsSuplentes,
        "jugadoresSeleccionados": idsCombinados,
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
      final consulta = await _db
          .collection("alineaciones")
          .where("idLiga", isEqualTo: idLiga)
          .where("idUsuario", isEqualTo: idUsuario)
          .get();

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
    Nombre: obtenerPorUsuarioEnLiga
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
      await _db
          .collection("alineaciones")
          .doc(alineacion.id)
          .update(alineacion.aMapa());

      _log.informacion("Editar alineación: ${alineacion.id}");
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
      await _db.collection("alineaciones").doc(id).delete();

      _log.informacion("Eliminar alineación: $id");
    } catch (e) {
      _log.error("Error en operación de alineaciones: $e");
      rethrow;
    }
  }
}
