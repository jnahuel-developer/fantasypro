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
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (idUsuario.isEmpty) {
      throw ArgumentError("El idUsuario no puede estar vacío.");
    }
    if (nombreEquipoFantasy.isEmpty) {
      throw ArgumentError("El nombre del equipo fantasy no puede estar vacío.");
    }

    _log.informacion(
      "Verificando si usuario $idUsuario ya participa en liga $idLiga",
    );

    final bool yaParticipa = await _servicio.usuarioYaParticipa(
      idUsuario,
      idLiga,
    );

    if (yaParticipa) {
      _log.advertencia("El usuario ya participa en la liga");
      throw Exception("El usuario ya participa en esta liga.");
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

    _log.informacion("Creando participación (Etapa 1)");

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
      "Creando equipo fantasy automáticamente tras registrar participación: usuario=$idUsuario, liga=$idLiga, nombreEquipo=$nombreEquipoFantasy",
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
      throw ArgumentError("El ID de la liga no puede estar vacío.");
    }

    _log.informacion("Listando participaciones de liga $idLiga");

    return await _servicio.obtenerPorLiga(idLiga);
  }

  // ---------------------------------------------------------------------------
  // Obtener participaciones por usuario
  // ---------------------------------------------------------------------------
  Future<List<ParticipacionLiga>> obtenerPorUsuario(String idUsuario) async {
    if (idUsuario.isEmpty) {
      throw ArgumentError("El ID del usuario no puede estar vacío.");
    }

    _log.informacion("Listando participaciones del usuario $idUsuario");

    return await _servicio.obtenerPorUsuario(idUsuario);
  }

  // ---------------------------------------------------------------------------
  // Archivar participación
  // ---------------------------------------------------------------------------
  Future<void> archivar(String idParticipacion) async {
    _log.advertencia("Archivando participación $idParticipacion");
    await _servicio.archivarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Activar participación
  // ---------------------------------------------------------------------------
  Future<void> activar(String idParticipacion) async {
    _log.informacion("Activando participación $idParticipacion");
    await _servicio.activarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Eliminar participación
  // ---------------------------------------------------------------------------
  Future<void> eliminar(String idParticipacion) async {
    _log.error("Eliminando participación $idParticipacion");
    await _servicio.eliminarParticipacion(idParticipacion);
  }

  // ---------------------------------------------------------------------------
  // Editar participación
  // ---------------------------------------------------------------------------
  Future<void> editar(ParticipacionLiga participacion) async {
    if (participacion.id.isEmpty) {
      throw ArgumentError("El ID de la participación no puede estar vacío.");
    }
    if (participacion.puntos < 0) {
      throw ArgumentError("Los puntos no pueden ser negativos.");
    }

    _log.informacion("Editando participación ${participacion.id}");

    await _servicio.editarParticipacion(participacion);
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
      throw ArgumentError("El idLiga no puede estar vacío.");
    }
    if (idFecha.trim().isEmpty) {
      throw ArgumentError("El idFecha no puede estar vacío.");
    }

    final ServicioFechas servicioFechas = ServicioFechas();
    final ServicioPuntajesFantasy servicioPuntajesFantasy =
        ServicioPuntajesFantasy();

    _log.informacion(
      "Iniciando cálculo de puntajes fantasy para liga $idLiga, fecha $idFecha",
    );

    // 1) Validar que la fecha existe, pertenece a la liga y está cerrada
    final fecha = await servicioFechas.obtenerFechaPorId(idFecha);
    if (fecha == null || fecha.idLiga != idLiga) {
      throw Exception("Fecha no válida para la liga especificada.");
    }
    if (!fecha.cerrada) {
      throw Exception("La fecha $idFecha no está cerrada.");
    }

    // 2) Obtener todos los participaciones activas de la liga
    final participaciones = await _servicio.obtenerActivasPorLiga(idLiga);
    _log.informacion(
      "Participaciones activas encontradas: ${participaciones.length}",
    );

    for (final participacion in participaciones) {
      try {
        _log.informacion(
          "Procesando participación ${participacion.id} (usuario ${participacion.idUsuario})",
        );

        // 3) Obtener equipo fantasy del usuario en la liga
        final equipo = await ControladorEquipoFantasy()
            .obtenerEquipoUsuarioEnLiga(participacion.idUsuario, idLiga);
        if (equipo == null) {
          _log.advertencia(
            "No se encuentra equipo fantasy para participación ${participacion.id} — se saltea.",
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
            "No se encontró alineación para usuario ${participacion.idUsuario} — se saltea.",
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
            "Puntaje fantasy ya aplicado para participación ${participacion.id}, fecha $idFecha — se saltea.",
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
          "Guardando puntaje fantasy para participación ${participacion.id}: total=$puntajeTotal",
        );
        await servicioPuntajesFantasy.guardarPuntajeEquipoFantasy(registro);

        // 9) Incrementar puntos acumulados en la participación
        await _servicio.incrementarPuntosParticipacion(
          participacion.id,
          puntajeTotal,
        );

        _log.informacion(
          "Puntos acumulados actualizados para participación ${participacion.id}",
        );
      } catch (e) {
        _log.error("Error procesando participación ${participacion.id}: $e");
        // Opcional: decidir si continuar con otras participaciones o abortar
      }
    }

    _log.informacion(
      "Cálculo de puntajes fantasy finalizado para liga $idLiga, fecha $idFecha",
    );
  }
}
