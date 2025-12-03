/*
  Archivo: controlador_equipo_fantasy.dart
  Descripción: Controlador para gestionar equipos fantasy del usuario final.
  Añade métodos para crear equipo fantasy + participación inicial, y obtener el equipo de un usuario en una liga.
*/

import 'package:fantasypro/modelos/equipo_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_fechas.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

import 'controlador_participaciones.dart';

class ControladorEquipoFantasy {
  /// Servicio para operaciones con equipos fantasy.
  final ServicioEquiposFantasy _servicio = ServicioEquiposFantasy();

  /// Servicio para participaciones.
  final ServicioParticipaciones _servicioPart = ServicioParticipaciones();

  /// Servicio para fechas de liga (para validar que no haya fecha activa).
  final ServicioFechas _servicioFechas = ServicioFechas();

  /// Servicio de registro de logs.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: crearEquipoFantasy
    Descripción: Crea un equipo fantasy asociado al usuario y la liga.
    Entradas: idUsuario (String), idLiga (String), nombre (String)
    Salidas: Future<EquipoFantasy>
  */
  Future<EquipoFantasy> crearEquipoFantasy(
    String idUsuario,
    String idLiga,
    String nombre,
  ) async {
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (nombre.trim().isEmpty) {
      throw ArgumentError("El nombre del equipo no puede estar vacío.");
    }

    _log.informacion(
      "Creando equipo fantasy: usuario=$idUsuario liga=$idLiga nombre=$nombre",
    );

    return await _servicio.crearEquipoFantasy(idUsuario, idLiga, nombre.trim());
  }

  /*
    Nombre: obtenerPorUsuarioYLiga
    Descripción: Obtiene equipos fantasy de un usuario en una liga específica.
    Entradas: idUsuario (String), idLiga (String)
    Salidas: Future<List<EquipoFantasy>>
  */
  Future<List<EquipoFantasy>> obtenerPorUsuarioYLiga(
    String idUsuario,
    String idLiga,
  ) async {
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }

    _log.informacion(
      "Listando equipos fantasy del usuario $idUsuario en liga $idLiga",
    );

    return await _servicio.obtenerPorUsuarioYLiga(idUsuario, idLiga);
  }

  // ---------------------------------------------------------------------------
  // NUEVOS MÉTODOS para mod0017
  // ---------------------------------------------------------------------------

  /*
    Nombre: crearEquipoParaLiga
    Descripción:
      Crea un equipo fantasy + participación para un usuario en una liga,
      sólo si:
        - el usuario no tiene ya un equipo en esa liga
        - no existe fecha activa en la liga (no hay Fecha en curso)
    Entradas:
      idUsuario, idLiga, nombreEquipo
    Salidas:
      Future<EquipoFantasy>
  */
  Future<EquipoFantasy> crearEquipoParaLiga(
    String idUsuario,
    String idLiga,
    String nombreEquipo,
  ) async {
    // Validaciones básicas
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (idLiga.trim().isEmpty) {
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (nombreEquipo.trim().isEmpty) {
      throw ArgumentError("El nombre del equipo no puede estar vacío.");
    }

    _log.informacion(
      "Iniciando creación de equipo fantasy + participación: usuario=$idUsuario liga=$idLiga",
    );

    // 1) Verificar que no exista equipo fantasy para este usuario en esta liga
    final equiposExistentes = await _servicio.obtenerPorUsuarioYLiga(
      idUsuario,
      idLiga,
    );
    if (equiposExistentes.isNotEmpty) {
      _log.advertencia("El usuario ya tiene un equipo fantasy en esta liga");
      throw Exception("El usuario ya tiene un equipo fantasy en esta liga.");
    }

    // 2) Verificar que no haya fecha activa en la liga
    final fechas = await _servicioFechas.obtenerPorLiga(idLiga);
    final existeActiva = fechas.any(
      (f) => f.activa == true && f.cerrada == false,
    );
    if (existeActiva) {
      _log.advertencia(
        "No se puede crear equipo: ya existe fecha activa en la liga",
      );
      throw Exception(
        "No se puede crear equipo fantasy: la liga tiene una fecha activa.",
      );
    }

    // 3) Crear el equipo fantasy
    final EquipoFantasy equipo = await crearEquipoFantasy(
      idUsuario,
      idLiga,
      nombreEquipo.trim(),
    );

    // 4) Crear la participación inicial (plantel no completo aún)
    await _servicioPart.crearParticipacion(
      (await ControladorParticipaciones().crearParticipacionSiNoExiste(
        idLiga,
        idUsuario,
        nombreEquipo.trim(),
      )).copiarCon(plantelCompleto: false),
    );

    _log.informacion("Equipo fantasy y participación creados OK: ${equipo.id}");
    return equipo;
  }

  /*
    Nombre: obtenerEquipoUsuarioEnLiga
    Descripción:
      Devuelve el equipo fantasy del usuario en la liga indicada, o null si no tiene.
    Entradas:
      idUsuario, idLiga
    Salidas:
      Future<EquipoFantasy?>
  */
  Future<EquipoFantasy?> obtenerEquipoUsuarioEnLiga(
    String idUsuario,
    String idLiga,
  ) async {
    final lista = await obtenerPorUsuarioYLiga(idUsuario, idLiga);
    if (lista.isEmpty) return null;
    // Asumimos un solo equipo por usuario/liga
    return lista.first;
  }
}
