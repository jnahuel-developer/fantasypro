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
    - ui__usuario__equipo_fantasy__plantel__desktop.dart
    - ui__usuario__equipo_fantasy__alineacion_inicial__desktop.dart
    - ui__usuario__equipo_fantasy__resumen__desktop.dart
*/

import 'package:fantasypro/controladores/controlador_equipo_fantasy.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/modelos/jugador_real.dart';

import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';

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
  final ServicioAutenticacion servicioAuth = ServicioAutenticacion();
  final ServicioParticipaciones servicioParticipaciones =
      ServicioParticipaciones();
  final ControladorParticipaciones controladorParticipaciones =
      ControladorParticipaciones();
  final ControladorFechas controladorFechas = ControladorFechas();
  final ControladorAlineaciones controladorAlineaciones =
      ControladorAlineaciones();
  final ControladorEquipoFantasy controladorEquiposFantasy =
      ControladorEquipoFantasy();
  final ControladorJugadoresReales controladorJugadoresReales =
      ControladorJugadoresReales();

  bool cargando = true;
  String? mensajeError;
  ParticipacionLiga? participacion;
  bool existeFechaActiva = false;
  final TextEditingController campoNombreEquipo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      cargando = true;
      mensajeError = null;
    });

    try {
      final usuario = servicioAuth.obtenerUsuarioActual();
      if (usuario == null) {
        setState(() {
          mensajeError = "No hay usuario autenticado.";
          cargando = false;
        });
        return;
      }

      final idUsuario = usuario.uid;

      participacion = await servicioParticipaciones.obtenerParticipacion(
        idUsuario,
        widget.liga.id,
      );

      final fechas = await controladorFechas.obtenerPorLiga(widget.liga.id);
      existeFechaActiva = fechas.any((f) => f.activa && !f.cerrada);

      setState(() => cargando = false);
    } catch (e) {
      setState(() {
        mensajeError = "Error al cargar los datos de la liga.";
        cargando = false;
      });
    }
  }

  Future<void> _crearParticipacionYContinuar() async {
    final nombreEquipo = campoNombreEquipo.text.trim();

    if (nombreEquipo.isEmpty) {
      setState(() {
        mensajeError = "Debés ingresar un nombre para tu equipo fantasy.";
      });
      return;
    }

    setState(() {
      cargando = true;
      mensajeError = null;
    });

    try {
      final usuario = servicioAuth.obtenerUsuarioActual();
      if (usuario == null) {
        setState(() {
          mensajeError = "No hay usuario autenticado.";
          cargando = false;
        });
        return;
      }

      final idUsuario = usuario.uid;

      await controladorParticipaciones.registrarParticipacionUsuario(
        widget.liga.id,
        idUsuario,
        nombreEquipo,
      );

      participacion = await servicioParticipaciones.obtenerParticipacion(
        idUsuario,
        widget.liga.id,
      );

      setState(() => cargando = false);

      if (participacion == null) {
        setState(() {
          mensajeError = "No se pudo recuperar la participación creada.";
        });
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UiUsuarioEquipoFantasyPlantelDesktop(
            liga: widget.liga,
            participacion: participacion!,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        mensajeError = "Error al crear la participación en la liga.";
        cargando = false;
      });
    }
  }

  void _continuarArmado() {
    if (participacion == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UiUsuarioEquipoFantasyPlantelDesktop(
          liga: widget.liga,
          participacion: participacion!,
        ),
      ),
    );
  }

  Future<void> _verResumen() async {
    if (participacion == null) return;

    setState(() {
      cargando = true;
      mensajeError = null;
    });

    try {
      final usuario = servicioAuth.obtenerUsuarioActual();
      if (usuario == null) {
        setState(() {
          mensajeError = "No hay usuario autenticado.";
          cargando = false;
        });
        return;
      }

      final idUsuario = usuario.uid;
      final idLiga = widget.liga.id;

      final alineaciones = await controladorAlineaciones
          .obtenerPorUsuarioEnLiga(idLiga, idUsuario);
      final alineacion = alineaciones.isNotEmpty ? alineaciones.first : null;

      if (alineacion == null) {
        setState(() {
          mensajeError = "No se encontró la alineación inicial.";
          cargando = false;
        });
        return;
      }

      final equipo = await controladorEquiposFantasy.obtenerEquipoUsuarioEnLiga(
        idUsuario,
        idLiga,
      );
      if (equipo == null) {
        setState(() {
          mensajeError = "No se encontró el equipo fantasy.";
          cargando = false;
        });
        return;
      }

      final plantel = await controladorJugadoresReales.obtenerPorIds(
        equipo.idsJugadoresPlantel,
      );

      setState(() => cargando = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UiUsuarioEquipoFantasyResumenDesktop(
            liga: widget.liga,
            participacion: participacion!,
            alineacion: alineacion,
            plantel: plantel,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        mensajeError = "Error al cargar el resumen del equipo.";
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final liga = widget.liga;

    return Scaffold(
      appBar: AppBar(title: Text("Liga: ${liga.nombre}")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Temporada: ${liga.temporada}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  if (mensajeError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        mensajeError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  if (existeFechaActiva)
                    const Text(
                      "No podés crear ni modificar tu equipo mientras haya una fecha activa en curso.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else ...[
                    if (participacion == null) ...[
                      const Text(
                        "Elegí un nombre para tu equipo fantasy:",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: campoNombreEquipo,
                        decoration: const InputDecoration(
                          labelText: "Nombre del equipo",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _crearParticipacionYContinuar,
                        child: const Text("Crear equipo fantasy"),
                      ),
                    ] else if (participacion != null &&
                        participacion!.plantelCompleto == false) ...[
                      const Text(
                        "Tenés un equipo fantasy pendiente de completar.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _continuarArmado,
                        child: const Text("Continuar armado del equipo"),
                      ),
                    ] else if (participacion != null &&
                        participacion!.plantelCompleto == true) ...[
                      const Text(
                        "Tu equipo fantasy ya está completo.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _verResumen,
                        child: const Text("Ver mi equipo fantasy"),
                      ),
                    ],
                  ],
                ],
              ),
      ),
    );
  }
}
