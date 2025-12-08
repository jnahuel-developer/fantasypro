/*
  Archivo: ui__usuario__resultados__detalle_jugadores__desktop.dart
  Descripción:
    Pantalla que muestra el detalle de puntajes por jugador para una fecha
    específica de la liga seleccionada. Utiliza el puntaje fantasy ya
    calculado para el usuario y lista los titulares con su aporte.

  Dependencias:
    - modelos/liga.dart
    - modelos/fecha_liga.dart
    - modelos/puntaje_equipo_fantasy.dart
    - modelos/jugador_real.dart
    - controladores/controlador_jugadores_reales.dart
    - widgets/ui__usuario__appbar__desktop.dart
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/puntaje_equipo_fantasy.dart';

import 'widgets/ui__usuario__appbar__desktop.dart';

class UiUsuarioResultadosDetalleJugadoresDesktop extends StatefulWidget {
  final Liga liga;
  final User usuario;
  final FechaLiga fecha;
  final PuntajeEquipoFantasy? puntajeFantasy;
  final String nombreEquipoFantasy;

  const UiUsuarioResultadosDetalleJugadoresDesktop({
    super.key,
    required this.liga,
    required this.usuario,
    required this.fecha,
    required this.puntajeFantasy,
    required this.nombreEquipoFantasy,
  });

  @override
  State<UiUsuarioResultadosDetalleJugadoresDesktop> createState() =>
      _UiUsuarioResultadosDetalleJugadoresDesktopEstado();
}

class _UiUsuarioResultadosDetalleJugadoresDesktopEstado
    extends State<UiUsuarioResultadosDetalleJugadoresDesktop> {
  /// Controlador de jugadores reales.
  final ControladorJugadoresReales _ctrlJugadoresReales =
      ControladorJugadoresReales();

  /// Lista de jugadores titulares con sus datos.
  List<JugadorReal> _jugadores = [];

  /// Estado de carga.
  bool _cargando = true;

  /// Mensaje de error si ocurre algún problema.
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Carga los datos de jugadores asociados al puntaje fantasy recibido.
      Si no hay puntaje para la fecha, muestra un mensaje indicando ausencia
      de registros.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cargar() async {
    final puntaje = widget.puntajeFantasy;
    if (puntaje == null) {
      setState(() {
        _cargando = false;
        _mensajeError = "No hay puntaje registrado para esta fecha.";
      });
      return;
    }

    if (puntaje.detalleJugadores.isEmpty) {
      setState(() {
        _cargando = false;
        _mensajeError = "No hay puntaje registrado para esta fecha.";
      });
      return;
    }

    try {
      final jugadores = await _ctrlJugadoresReales
          .obtenerPorIds(puntaje.detalleJugadores.keys.toList());

      if (!mounted) return;

      setState(() {
        _jugadores = jugadores;
        _mensajeError = null;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _cargando = false;
        _mensajeError = "Error al cargar el detalle de jugadores.";
      });
    }
  }

  /*
    Nombre: _puntajeDeJugador
    Descripción:
      Obtiene el puntaje de un jugador específico desde el mapa de detalle
      del puntaje fantasy. Devuelve 0 si no hay entrada.
    Entradas:
      - jugadorId (String): identificador del jugador real.
    Salidas:
      - int
  */
  int _puntajeDeJugador(String jugadorId) {
    return widget.puntajeFantasy?.detalleJugadores[jugadorId] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final puntaje = widget.puntajeFantasy;
    return Scaffold(
      appBar: const UiUsuarioAppBarDesktop(
        titulo: "Resultados por jugador",
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _mensajeError != null
              ? Center(child: Text(_mensajeError!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      widget.liga.nombre,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${widget.fecha.numeroFecha}. ${widget.fecha.nombre}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.nombreEquipoFantasy.isEmpty
                          ? "Equipo fantasy"
                          : widget.nombreEquipoFantasy,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    if (puntaje != null)
                      Text(
                        "Puntaje total: ${puntaje.puntajeTotal}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    const SizedBox(height: 12),
                    for (final jugador in _jugadores)
                      Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 0,
                        ),
                        child: ListTile(
                          title: Text(jugador.nombre),
                          subtitle: Text(
                            "Equipo: ${jugador.nombreEquipoReal} — Posición: ${jugador.posicion}",
                          ),
                          trailing: Text(
                            _puntajeDeJugador(jugador.id).toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}
