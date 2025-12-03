/*
  Archivo: ui__usuario__equipo_fantasy__resumen__desktop.dart
  Descripción:
    Pantalla final del flujo de creación del equipo fantasy.
    Muestra el resumen del plantel, titulares, suplentes, formación,
    presupuesto inicial y presupuesto restante.

  Dependencias:
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - modelos/alineacion.dart
    - modelos/jugador_real.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/modelos/jugador_real.dart';

class UiUsuarioEquipoFantasyResumenDesktop extends StatelessWidget {
  final Liga liga;
  final ParticipacionLiga participacion;
  final Alineacion alineacion;
  final List<JugadorReal> plantel;

  const UiUsuarioEquipoFantasyResumenDesktop({
    super.key,
    required this.liga,
    required this.participacion,
    required this.alineacion,
    required this.plantel,
  });

  /*
    Nombre: _buscarJugador
    Descripción:
      Busca un jugador dentro del plantel por ID.
    Entradas:
      - String idJugador
    Salidas:
      - JugadorReal
  */
  JugadorReal _buscarJugador(String idJugador) {
    return plantel.firstWhere((j) => j.id == idJugador);
  }

  /*
    Nombre: _calcularCosto
    Descripción:
      Suma el valorMercado de todos los jugadores del plantel.
    Entradas:
      - ninguna
    Salidas:
      - int
  */
  int _calcularCosto() {
    return plantel.fold<int>(0, (prev, j) => prev + j.valorMercado);
  }

  /*
    Nombre: _listaJugadores
    Descripción:
      Convierte una lista de IDs en widgets con datos de cada jugador.
    Entradas:
      - List<String> ids
      - String titulo
    Salidas:
      - Widget
  */
  Widget _listaJugadores(String titulo, List<String> ids) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            for (final idJ in ids)
              Builder(
                builder: (_) {
                  final j = _buscarJugador(idJ);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "${j.nombre} — ${j.posicion} — ${j.valorMercado} pts — Equipo real: ${j.idEquipoReal}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presupuestoInicial = 1000;
    final costoPlantel = _calcularCosto();
    final presupuestoRestante = presupuestoInicial - costoPlantel;

    return Scaffold(
      appBar: AppBar(title: Text("Resumen del equipo — ${liga.nombre}")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            participacion.nombreEquipoFantasy,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "Formación: ${alineacion.formacion}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),

          // Presupuestos
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            child: ListTile(
              title: const Text("Presupuesto"),
              subtitle: Text(
                "Inicial: $presupuestoInicial   —   Usado: $costoPlantel   —   Restante: $presupuestoRestante",
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Titulares
          _listaJugadores("Titulares", alineacion.idsTitulares),

          // Suplentes
          _listaJugadores("Suplentes", alineacion.idsSuplentes),

          const SizedBox(height: 32),
          const Text(
            "¡Tu equipo ya está listo para competir!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
