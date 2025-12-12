/*
  Archivo: ui__usuario__liga__detalle__desktop.dart
  Descripción:
    Pantalla de detalle de una liga para el usuario final.
    Desde la versión actual:
      - Detecta si el usuario ya tiene participación en la liga.
      - Distingue entre plantel incompleto y plantel completo.
      - Permite crear equipo fantasy, continuar armado o ver el resumen.
      - Bloquea el flujo si existe una fecha activa en la liga.

  Dependencias:
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - modelos/alineacion.dart
    - modelos/jugador_real.dart
    - servicios/servicio_autenticacion.dart
    - servicios/servicio_participaciones.dart
    - controladores/controlador_participaciones.dart
    - controladores/controlador_fechas.dart
    - controladores/controlador_alineaciones.dart
    - controladores/controlador_equipos_fantasy.dart
    - controladores/controlador_jugadores_reales.dart

  Pantallas que navegan hacia esta:
    - ui__usuario__inicio__lista__desktop.dart

  Pantallas destino:
    - ui__usuario__equipo_fantasy__plantel__desktop.dart: navegación luego de crear o continuar armado del equipo fantasy.
    - ui__usuario__equipo_fantasy__resumen__desktop.dart: navegación cuando el usuario ya completó el equipo y desea ver el resumen.
*/

import 'package:fantasypro/controladores/controlador_equipo_fantasy.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/modelos/jugador_real.dart';

import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/textos/textos_app.dart';

import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/controladores/controlador_fechas.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';

import 'ui__usuario__equipo_fantasy__plantel__desktop.dart';
import 'ui__usuario__equipo_fantasy__resumen__desktop.dart';

class UiUsuarioLigaDetalleDesktop extends StatefulWidget {
  final Liga liga;

  const UiUsuarioLigaDetalleDesktop({super.key, required this.liga});

  @override
  State<UiUsuarioLigaDetalleDesktop> createState() =>
      _UiUsuarioLigaDetalleDesktopEstado();
}

class _UiUsuarioLigaDetalleDesktopEstado
    extends State<UiUsuarioLigaDetalleDesktop> {
  /// Servicio de autenticación para obtener el usuario actual.
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();

  /// Servicio de participación usado solo para recuperación directa por ID.
  final ServicioParticipaciones _servicioParticipaciones =
      ServicioParticipaciones();

  /// Controlador de participaciones en ligas.
  final ControladorParticipaciones _ctrlParticipaciones =
      ControladorParticipaciones();

  /// Controlador de fechas de liga.
  final ControladorFechas _ctrlFechas = ControladorFechas();

  /// Controlador de alineaciones fantasy.
  final ControladorAlineaciones _ctrlAlineaciones = ControladorAlineaciones();

  /// Controlador de equipos fantasy.
  final ControladorEquipoFantasy _ctrlEquipos = ControladorEquipoFantasy();

  /// Controlador de jugadores reales.
  final ControladorJugadoresReales _ctrlJugadoresReales =
      ControladorJugadoresReales();

  /// Campo de texto para ingresar nombre del equipo fantasy.
  final TextEditingController _campoNombreEquipo = TextEditingController();

  /// Participación actual del usuario en la liga (si existe).
  ParticipacionLiga? _participacion;

  /// Indica si hay al menos una fecha activa en la liga.
  bool _existeFechaActiva = false;

  /// Estado de carga general de la pantalla.
  bool _cargando = true;

  /// Mensaje de error actual (si existe).
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Recupera el usuario autenticado, verifica si participa en la liga,
      y consulta si hay fechas activas para bloquear el flujo.

    Entradas: ninguna
    Salidas: void: sin valor devuelto
  */
  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final ServicioLog log = ServicioLog();

    try {
      log.informacion(
        "Iniciando _cargar en la pantalla <ui__usuario__liga__detalle__desktop>",
      );

        final usuario = _servicioAuth.obtenerUsuarioActual();

        log.informacion("obtenerUsuarioActual devolvió $usuario");

        if (usuario == null) {
          setState(() {
            _mensajeError = TextosApp.USUARIO_NO_AUTENTICADO;
            _cargando = false;
          });
          return;
        }

      final idUsuario = usuario.uid;

      log.informacion("${TextosApp.LOG_LIGA_DETALLE_ID_USUARIO} $idUsuario");

      _participacion = await _servicioParticipaciones.obtenerParticipacion(
        idUsuario,
        widget.liga.id,
      );

      final fechas = await _ctrlFechas.obtenerPorLiga(widget.liga.id);

      log.informacion("${TextosApp.LOG_LIGA_DETALLE_FECHAS} $fechas");

      _existeFechaActiva = fechas.any((f) => f.activa && !f.cerrada);

      setState(() => _cargando = false);
    } catch (e) {
      setState(() {
        _mensajeError = TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_ERROR_GENERAL;
        _cargando = false;
      });
    }
  }

  /*
    Nombre: _crearParticipacionYContinuar
    Descripción:
      Registra una nueva participación del usuario en la liga con el nombre
      provisto, y navega a la pantalla de armado del plantel inicial.

    Entradas: ninguna
    Salidas: void: sin valor devuelto
  */
  Future<void> _crearParticipacionYContinuar() async {
    final nombreEquipo = _campoNombreEquipo.text.trim();

    if (nombreEquipo.isEmpty) {
      setState(() {
        _mensajeError = TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_NOMBRE_OBLIGATORIO;
      });
      return;
    }

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final usuario = _servicioAuth.obtenerUsuarioActual();
      if (usuario == null) {
        setState(() {
          _mensajeError = TextosApp.USUARIO_NO_AUTENTICADO;
          _cargando = false;
        });
        return;
      }

      final idUsuario = usuario.uid;

      await _ctrlParticipaciones.registrarParticipacionUsuario(
        widget.liga.id,
        idUsuario,
        nombreEquipo,
      );

      _participacion = await _servicioParticipaciones.obtenerParticipacion(
        idUsuario,
        widget.liga.id,
      );

      setState(() => _cargando = false);

      if (_participacion == null) {
        setState(() {
          _mensajeError =
              TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_PARTICIPACION_NO_RECUPERADA;
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UiUsuarioEquipoFantasyPlantelDesktop(
            liga: widget.liga,
            participacion: _participacion!,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _mensajeError = TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_ERROR_CREAR_PARTICIPACION;
        _cargando = false;
      });
    }
  }

  /*
    Nombre: _continuarArmado
    Descripción:
      Permite reanudar el armado del equipo si la participación está incompleta.

    Entradas: ninguna
    Salidas: void: sin valor devuelto
  */
  void _continuarArmado() {
    if (_participacion == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UiUsuarioEquipoFantasyPlantelDesktop(
          liga: widget.liga,
          participacion: _participacion!,
        ),
      ),
    );
  }

  /*
    Nombre: _verResumen
    Descripción:
      Recupera la alineación y plantel actual del usuario y navega a la pantalla
      de resumen fantasy.

    Entradas: ninguna
    Salidas: void: sin valor devuelto
  */
  Future<void> _verResumen() async {
    if (_participacion == null) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    try {
      final usuario = _servicioAuth.obtenerUsuarioActual();
      if (usuario == null) {
        setState(() {
          _mensajeError = TextosApp.USUARIO_NO_AUTENTICADO;
          _cargando = false;
        });
        return;
      }

      final idUsuario = usuario.uid;
      final idLiga = widget.liga.id;

      final alineaciones = await _ctrlAlineaciones.obtenerPorUsuarioEnLiga(
        idLiga,
        idUsuario,
      );
      final alineacion = alineaciones.isNotEmpty ? alineaciones.first : null;

      if (alineacion == null) {
        setState(() {
          _mensajeError = TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_SIN_ALINEACION;
          _cargando = false;
        });
        return;
      }

      final equipos = await _ctrlEquipos.obtenerEquiposPorUsuarioYLiga(
        idUsuario,
        idLiga,
      );
      final equipo = equipos.isNotEmpty ? equipos.first : null;

      if (equipo == null) {
        setState(() {
          _mensajeError = TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_SIN_EQUIPO;
          _cargando = false;
        });
        return;
      }

      final plantel = await _ctrlJugadoresReales.obtenerPorIds(
        equipo.idsJugadoresPlantel,
      );

      setState(() => _cargando = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UiUsuarioEquipoFantasyResumenDesktop(
            liga: widget.liga,
            participacion: _participacion!,
            alineacion: alineacion,
            plantel: plantel,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _mensajeError = TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_ERROR_RESUMEN;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final liga = widget.liga;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextosApp.LIGA_DETALLE_USUARIO_APPBAR_TITULO
              .replaceAll("{LIGA}", liga.nombre),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TextosApp.LIGA_DETALLE_USUARIO_TEXTO_TEMPORADA
                        .replaceAll("{TEMPORADA}", liga.temporada),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (_mensajeError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _mensajeError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  if (_existeFechaActiva)
                    const Text(
                      TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_FECHA_ACTIVA,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else ...[
                    if (_participacion == null) ...[
                      const Text(
                        TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_ELEGIR_NOMBRE,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _campoNombreEquipo,
                        decoration: const InputDecoration(
                          labelText: TextosApp.LIGA_DETALLE_USUARIO_LABEL_NOMBRE,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _crearParticipacionYContinuar,
                        child: const Text(
                          TextosApp.LIGA_DETALLE_USUARIO_BOTON_CREAR,
                        ),
                      ),
                    ] else if (_participacion!.plantelCompleto == false) ...[
                      const Text(
                        TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_PLANTEL_PENDIENTE,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _continuarArmado,
                        child: const Text(
                          TextosApp.LIGA_DETALLE_USUARIO_BOTON_CONTINUAR,
                        ),
                      ),
                    ] else if (_participacion!.plantelCompleto == true) ...[
                      const Text(
                        TextosApp.LIGA_DETALLE_USUARIO_MENSAJE_PLANTEL_COMPLETO,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _verResumen,
                        child: const Text(
                          TextosApp.LIGA_DETALLE_USUARIO_BOTON_VER_EQUIPO,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
      ),
    );
  }
}
