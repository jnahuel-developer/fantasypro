/*
  Archivo: controlador_participaciones.dart
  Descripción:
    Lógica de negocio y validación para la gestión de participaciones
    de usuarios en una liga.
    Se mantiene el método crearParticipacionSiNoExiste que asegura unicidad usuario–liga.
    Se conserva registrarParticipacionUsuario como wrapper/wrapper extendido
    para dicho método, adaptado a la corrección del flujo mod0017+mod0018:
    al registrar participación, también crea automáticamente el equipo fantasy asociado.
*/

import 'package:fantasypro/controladores/controlador_alineaciones.dart';
import 'package:fantasypro/controladores/controlador_equipo_fantasy.dart';
import 'package:fantasypro/controladores/controlador_puntajes_reales.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/puntaje_equipo_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_fechas.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_puntajes_fantasy.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ControladorParticipaciones {
  final ServicioParticipaciones _servicio = ServicioParticipaciones();
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Crear participación (Etapa 1)
  // ---------------------------------------------------------------------------
  Future<ParticipacionLiga> crearParticipacionSiNoExiste(
    String idLiga,
    String idUsuario,
    String nombreEquipoFantasy,
  ) async {
    if (idLiga.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (idUsuario.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }
    if (nombreEquipoFantasy.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_NOMBRE_EQUIPO_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_VERIFICAR} $idUsuario en liga $idLiga",
    );

    final bool yaParticipa = await _servicio.usuarioYaParticipa(
      idUsuario,
      idLiga,
    );

    if (yaParticipa) {
      _log.advertencia(TextosApp.LOG_CTRL_PARTICIPACIONES_USUARIO_EXISTE);
      throw Exception(TextosApp.ERR_CTRL_PARTICIPACION_DUPLICADA);
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;

    final participacion = ParticipacionLiga(
      id: "",
      idLiga: idLiga,
      idUsuario: idUsuario,
      nombreEquipoFantasy: nombreEquipoFantasy,
      puntos: 0,
      plantelCompleto: false,
      fechaCreacion: timestamp,
      activo: true,
    );

    _log.informacion(TextosApp.LOG_CTRL_PARTICIPACIONES_CREANDO_ETAPA1);

    return await _servicio.crearParticipacion(participacion);
  }

  // ---------------------------------------------------------------------------
  // registrarParticipacionUsuario — alias / wrapper corregido
  // ---------------------------------------------------------------------------
  /*
    Nombre: registrarParticipacionUsuario
    Descripción:
      Wrapper de crearParticipacionSiNoExiste. Además de crear la participación,
      crea automáticamente el equipo fantasy correspondiente para que la UI
      pueda encontrarlo inmediatamente.
  */
  Future<ParticipacionLiga> registrarParticipacionUsuario(
    String idLiga,
    String idUsuario,
    String nombreEquipoFantasy,
  ) async {
    final participacion = await crearParticipacionSiNoExiste(
      idLiga,
      idUsuario,
      nombreEquipoFantasy,
    );

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_CREAR_EQUIPO_AUTO}: "
      "usuario=$idUsuario, liga=$idLiga, nombreEquipo=$nombreEquipoFantasy",
    );

    // Crear equipo fantasy asociado — uso directo del servicio, sin intermediarios
    await ServicioEquiposFantasy().crearEquipoFantasy(
      idUsuario,
      idLiga,
      nombreEquipoFantasy,
    );

    return participacion;
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones por liga
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorLiga(String idLiga) async {
    if (idLiga.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }

    _log.informacion("${TextosApp.LOG_CTRL_PARTICIPACIONES_LISTAR} $idLiga");

    return await _servicio.obtenerPorLiga(idLiga);
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones por usuario
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorUsuario(String idUsuario) async {
    if (idUsuario.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_LISTAR_USUARIO} $idUsuario",
    );

    return await _servicio.obtenerPorUsuario(idUsuario);
  }

  /*
    Nombre: obtenerPorUsuarioYLiga
    Descripción:
      Recupera la participación de un usuario específica para una liga.
      Devuelve null si el usuario no está inscrito.
    Entradas:
      - idUsuario (String): identificador del usuario.
      - idLiga (String): identificador de la liga.
    Salidas:
      - Future<ParticipacionLiga?>
  */
  Future<ParticipacionLiga?> obtenerPorUsuarioYLiga(
    String idUsuario,
    String idLiga,
  ) async {
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }

    return await _servicio.obtenerParticipacion(idUsuario, idLiga);
  }

  /*
    Nombre: obtenerParticipacionUsuarioEnLiga
    Descripción:
      Recupera la participación de un usuario en una liga específica.
      Si no existe participación, devuelve null.
    Entradas:
      - idLiga (String)
      - idUsuario (String)
    Salidas:
      - Future<ParticipacionLiga?>
  */
  Future<ParticipacionLiga?> obtenerParticipacionUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_OBTENER} $idUsuario en liga $idLiga",
    );

    return await _servicio.obtenerParticipacion(idUsuario, idLiga);
  }

  /*
    Nombre: obtenerPuntajesFantasyDeUsuarioEnLiga
    Descripción:
      Devuelve la lista de puntajes fantasy de un usuario en una liga,
      buscando primero su participación y luego consultando la subcolección
      "puntajes_fantasy" asociada.
    Entradas:
      - idLiga (String)
      - idUsuario (String)
    Salidas:
      - Future<List<PuntajeEquipoFantasy>>
  */
  Future<List<PuntajeEquipoFantasy>> obtenerPuntajesFantasyDeUsuarioEnLiga(
    String idLiga,
    String idUsuario,
  ) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (idUsuario.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_USUARIO_VACIO);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_PUNTAJES_USUARIO} "
      "$idUsuario en liga $idLiga",
    );

    final participacion = await obtenerParticipacionUsuarioEnLiga(
      idLiga,
      idUsuario,
    );

    if (participacion == null) {
      _log.advertencia(
        "${TextosApp.ERR_CTRL_PARTICIPACION_NO_ENCONTRADA} "
        "usuario $idUsuario en liga $idLiga",
      );
      return [];
    }

    final servicioPuntajes = ServicioPuntajesFantasy();

    return await servicioPuntajes.obtenerPuntajesPorParticipacion(
      participacion.id,
    );
  }

  // ---------------------------------------------------------------------------
  // Archivar participación
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idParticipacion) async {
    _log.advertencia(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_ARCHIVAR} $idParticipacion",
    );
    await _servicio.archivarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Activar participación
  // ---------------------------------------------------------------------------
  Future<void> activar(String idParticipacion) async {
    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_ACTIVAR} $idParticipacion",
    );
    await _servicio.activarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Eliminar participación
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idParticipacion) async {
    _log.error("${TextosApp.LOG_CTRL_PARTICIPACIONES_ELIMINAR} $idParticipacion");
    await _servicio.eliminarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Editar participación
  // ---------------------------------------------------------------------------
  Future<void> editar(ParticipacionLiga participacion) async {
    if (participacion.id.isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_PARTICIPACION_VACIO);
    }
    if (participacion.puntos < 0) {
      throw ArgumentError(TextosApp.ERR_CTRL_PUNTOS_NEGATIVOS);
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_EDITAR} ${participacion.id}",
    );

    await _servicio.editarParticipacion(participacion);
  }

  /*
    Nombre: obtenerPuntajePorParticipacionYFecha
    Descripción:
      Retorna el puntaje fantasy registrado para una participación en
      una fecha específica. Si no existe registro, devuelve null.
    Entradas:
      - idParticipacion (String): identificador de la participación.
      - idFecha (String): identificador de la fecha de liga.
    Salidas:
      - Future<PuntajeEquipoFantasy?>
  */
  Future<PuntajeEquipoFantasy?> obtenerPuntajePorParticipacionYFecha(
    String idParticipacion,
    String idFecha,
  ) async {
    if (idParticipacion.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_PARTICIPACION_VACIO);
    }
    if (idFecha.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_FECHA_VACIO);
    }

    final servicio = ServicioPuntajesFantasy();
    return await servicio.obtenerPorParticipacionYFecha(
      idParticipacion,
      idFecha,
    );
  }

  /*
    Nombre: aplicarPuntajesFantasyAFecha
    Descripción:
      Orquesta la aplicación de puntajes fantasy a todos los equipos participantes
      de una liga cuando se cierra una fecha: suma puntajes reales de titulares,
      guarda el puntaje fantasy, y actualiza los puntos acumulados de cada participación.
      Es idempotente: no recalcula si ya existe el puntaje fantasy para la participación + fecha.
    Entradas:
      - idLiga: String — ID de la liga
      - idFecha: String — ID de la fecha cerrada
    Salidas:
      - Future<void>
  */
  Future<void> aplicarPuntajesFantasyAFecha(
    String idLiga,
    String idFecha,
  ) async {
    if (idLiga.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_LIGA_VACIO);
    }
    if (idFecha.trim().isEmpty) {
      throw ArgumentError(TextosApp.ERR_CTRL_ID_FECHA_VACIO);
    }

    final ServicioFechas servicioFechas = ServicioFechas();
    final ServicioPuntajesFantasy servicioPuntajesFantasy =
        ServicioPuntajesFantasy();

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_APLICAR_PUNTAJES} "
      "para liga $idLiga, fecha $idFecha",
    );

    // 1) Validar que la fecha existe, pertenece a la liga y está cerrada
    final fecha = await servicioFechas.obtenerFechaPorId(idFecha);
    if (fecha == null || fecha.idLiga != idLiga) {
      throw Exception(TextosApp.ERR_CTRL_FECHA_NO_VALIDA);
    }
    if (!fecha.cerrada) {
      throw Exception(TextosApp.ERR_CTRL_FECHA_NO_CERRADA);
    }

    // 2) Obtener todos los participaciones activas de la liga
    final participaciones = await _servicio.obtenerActivasPorLiga(idLiga);
    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_LISTAR}: ${participaciones.length}",
    );

    for (final participacion in participaciones) {
      try {
        _log.informacion(
          "${TextosApp.LOG_CTRL_PARTICIPACIONES_EDITAR} ${participacion.id} "
          "(usuario ${participacion.idUsuario})",
        );

        // 3) Obtener equipo fantasy del usuario en la liga
        final equipo = await ControladorEquipoFantasy()
            .obtenerEquipoUsuarioEnLiga(participacion.idUsuario, idLiga);
        if (equipo == null) {
          _log.advertencia(
            "${TextosApp.LOG_CTRL_PARTICIPACIONES_SIN_EQUIPO} ${participacion.id}",
          );
          continue;
        }

        // 4) Obtener alineación (activa o más reciente) del usuario en la liga
        final alineacion = await ControladorAlineaciones()
            .obtenerAlineacionActivaDeUsuarioEnLiga(
              idLiga,
              participacion.idUsuario,
            );
        if (alineacion == null) {
          _log.advertencia(
            "${TextosApp.LOG_CTRL_PARTICIPACIONES_SIN_ALINEACION} ${participacion.idUsuario}",
          );
          continue;
        }

        // 5) Obtener puntajes reales de la fecha
        final Map<String, int> mapaPuntajes = await ControladorPuntajesReales()
            .obtenerMapaPorLigaYFecha(idLiga, idFecha);

        // 6) Calcular puntaje total sumando titulares (suplentes no puntúan)
        int puntajeTotal = 0;
        final Map<String, int> detalle = {};
        for (final idJ in alineacion.idsTitulares) {
          final pts = mapaPuntajes[idJ] ?? 0;
          puntajeTotal += pts;
          detalle[idJ] = pts;
        }

        // 7) Idempotencia: verificar si ya existe puntaje fantasy para esta participación + fecha
        final existente = await servicioPuntajesFantasy
            .obtenerPorParticipacionYFecha(participacion.id, idFecha);
        if (existente != null) {
          _log.informacion(
            "${TextosApp.LOG_CTRL_PARTICIPACIONES_PUNTAJE_EXISTENTE} "
            "${participacion.id}, fecha $idFecha — se saltea.",
          );
          continue;
        }

        // 8) Crear y guardar registro de puntaje fantasy
        final int timestamp = DateTime.now().millisecondsSinceEpoch;
        final registro = PuntajeEquipoFantasy(
          id: idFecha,
          idParticipacion: participacion.id,
          idEquipoFantasy: equipo.id,
          idLiga: idLiga,
          idFecha: idFecha,
          puntajeTotal: puntajeTotal,
          detalleJugadores: detalle,
          timestampAplicacion: timestamp,
          activo: true,
        );

        _log.informacion(
          "${TextosApp.LOG_CTRL_PARTICIPACIONES_PUNTAJE_GUARDADO} "
          "${participacion.id}: total=$puntajeTotal",
        );
        await servicioPuntajesFantasy.guardarPuntajeEquipoFantasy(registro);

        // 9) Incrementar puntos acumulados en la participación
        await _servicio.incrementarPuntosParticipacion(
          participacion.id,
          puntajeTotal,
        );

        _log.informacion(
          "${TextosApp.LOG_CTRL_PARTICIPACIONES_PUNTAJE_ACTUALIZADO} "
          "${participacion.id}",
        );
      } catch (e) {
        _log.error("${TextosApp.LOG_CTRL_PARTICIPACIONES_EDITAR} ${participacion.id}: $e");
        // Opcional: decidir si continuar con otras participaciones o abortar
      }
    }

    _log.informacion(
      "${TextosApp.LOG_CTRL_PARTICIPACIONES_FINALIZADO} $idLiga, fecha $idFecha",
    );
  }
}
