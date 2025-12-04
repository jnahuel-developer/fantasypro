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

  Pantallas que navegan hacia esta:
    - ui__usuario__equipo_fantasy__alineacion_inicial__desktop.dart: al finalizar la selección táctica.

  Pantallas destino: ninguna
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/modelos/jugador_real.dart';

class UiUsuarioEquipoFantasyResumenDesktop extends StatelessWidget {
  /// Liga actual en la que participa el usuario.
  final Liga liga;

  /// Participación del usuario en la liga.
  final ParticipacionLiga participacion;

  /// Alineación inicial seleccionada (titulares, suplentes, formación).
  final Alineacion alineacion;

  /// Plantel completo de jugadores ya recuperados por controlador.
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
      Busca un jugador dentro del plantel usando su ID.

    Entradas:
      - idJugador (String): ID del jugador a buscar

    Salidas:
      - JugadorReal: instancia del jugador encontrado
  */
  JugadorReal _buscarJugador(String idJugador) {
    return plantel.firstWhere((j) => j.id == idJugador);
  }

  /*
    Nombre: _calcularCosto
    Descripción:
      Calcula el costo total del plantel sumando el valorMercado de cada jugador.

    Entradas: ninguna

    Salidas:
      - int: total acumulado del valor del plantel
  */
  int _calcularCosto() {
    return plantel.fold<int>(0, (prev, j) => prev + j.valorMercado);
  }

  /*
    Nombre: _listaJugadores
    Descripción:
      Construye un widget visual que muestra una lista de jugadores
      basada en una lista de IDs, con su información básica.

    Entradas:
      - titulo (String): encabezado de la sección
      - ids (List<String>): lista de IDs de jugadores

    Salidas:
      - Widget: sección visual renderizada
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
    /// Presupuesto inicial fijo del sistema.
    const int presupuestoInicial = 1000;

    /// Costo actual del plantel.
    final int costoPlantel = _calcularCosto();

    /// Presupuesto restante luego de seleccionar plantel.
    final int presupuestoRestante = presupuestoInicial - costoPlantel;

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

          // Presupuesto total del equipo
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

          // Sección de titulares
          _listaJugadores("Titulares", alineacion.idsTitulares),

          // Sección de suplentes
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
