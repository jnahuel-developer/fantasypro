/*
  Archivo: ui__usuario__equipo_fantasy__alineacion_inicial__desktop.dart
  Descripción:
    Pantalla para seleccionar la alineación inicial de un equipo fantasy.
    Permite elegir 11 titulares y 4 suplentes (1 por posición) a partir
    de un plantel de 15 jugadores reales ya definido y una formación fija.

  Dependencias:
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - modelos/jugador_real.dart
    - servicios/servicio_autenticacion.dart
    - controladores/controlador_alineaciones.dart
    - ui__usuario__equipo_fantasy__resumen__desktop.dart

  Pantallas que navegan hacia esta:
    - ui__usuario__equipo_fantasy__plantel__desktop.dart

  Pantallas destino:
    - ui__usuario__equipo_fantasy__resumen__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart';

import 'ui__usuario__equipo_fantasy__resumen__desktop.dart';

class UiUsuarioEquipoFantasyAlineacionInicialDesktop extends StatefulWidget {
  final Liga liga;
  final ParticipacionLiga participacion;
  final String idEquipoFantasy;
  final List<JugadorReal> plantel;
  final String formacion;

  const UiUsuarioEquipoFantasyAlineacionInicialDesktop({
    super.key,
    required this.liga,
    required this.participacion,
    required this.idEquipoFantasy,
    required this.plantel,
    required this.formacion,
  });

  @override
  State<UiUsuarioEquipoFantasyAlineacionInicialDesktop> createState() =>
      _UiUsuarioEquipoFantasyAlineacionInicialDesktopEstado();
}

class _UiUsuarioEquipoFantasyAlineacionInicialDesktopEstado
    extends State<UiUsuarioEquipoFantasyAlineacionInicialDesktop> {
  /// Servicio de autenticación para obtener el usuario actual.
  final ServicioAutenticacion servicioAutenticacion = ServicioAutenticacion();

  /// Controlador de alineaciones para guardar la alineación inicial.
  final ControladorAlineaciones controladorAlineaciones =
      ControladorAlineaciones();

  /// Lista de IDs de jugadores seleccionados como titulares.
  final List<String> idsTitulares = [];

  /// Lista de IDs de jugadores seleccionados como suplentes.
  final List<String> idsSuplentes = [];

  /*
    Nombre: _limitesTitulares
    Descripción:
      Retorna el mapa de límites por posición para titulares según la formación.
    Entradas:
      - ninguna
    Salidas:
      - Map<String, int>
  */
  Map<String, int> _limitesTitulares() {
    if (widget.formacion == "4-4-2") {
      return {"POR": 1, "DEF": 4, "MED": 4, "DEL": 2};
    } else {
      return {"POR": 1, "DEF": 4, "MED": 3, "DEL": 3};
    }
  }

  /*
    Nombre: _contarPorPosicion
    Descripción:
      Cuenta cuántos jugadores de una lista de IDs corresponden a una posición dada.
    Entradas:
      - List<String> ids
      - String posicion
    Salidas:
      - int
  */
  int _contarPorPosicion(List<String> ids, String posicion) {
    return ids
        .map(
          (id) => widget.plantel.firstWhere(
            (j) => j.id == id,
            orElse: () => widget.plantel.first,
          ),
        )
        .where((j) => j.posicion == posicion)
        .length;
  }

  /*
    Nombre: _mostrarMensaje
    Descripción:
      Muestra un mensaje rápido mediante SnackBar.
    Entradas:
      - String texto
    Salidas:
      - ninguna
  */
  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  /*
    Nombre: _alternarTitular
    Descripción:
      Agrega o quita un jugador de la lista de titulares respetando límites.
    Entradas:
      - JugadorReal jugador
    Salidas:
      - ninguna
  */
  void _alternarTitular(JugadorReal jugador) {
    if (idsTitulares.contains(jugador.id)) {
      idsTitulares.remove(jugador.id);
    } else {
      if (idsTitulares.length >= 11) {
        _mostrarMensaje("Debe haber exactamente 11 titulares.");
        return;
      }

      final limites = _limitesTitulares();
      final actual = _contarPorPosicion(idsTitulares, jugador.posicion);
      final limitePosicion = limites[jugador.posicion] ?? 0;

      if (actual >= limitePosicion) {
        _mostrarMensaje(
          "Ya se alcanzó el máximo de ${jugador.posicion} para la formación ${widget.formacion}.",
        );
        return;
      }

      if (idsSuplentes.contains(jugador.id)) {
        _mostrarMensaje("Un jugador no puede ser titular y suplente a la vez.");
        return;
      }

      idsTitulares.add(jugador.id);
    }

    setState(() {});
  }

  /*
    Nombre: _alternarSuplente
    Descripción:
      Agrega o quita un jugador de la lista de suplentes respetando límites.
      Debe haber exactamente 1 suplente por posición.
    Entradas:
      - JugadorReal jugador
    Salidas:
      - ninguna
  */
  void _alternarSuplente(JugadorReal jugador) {
    if (idsSuplentes.contains(jugador.id)) {
      idsSuplentes.remove(jugador.id);
    } else {
      if (idsSuplentes.length >= 4) {
        _mostrarMensaje("Debe haber exactamente 4 suplentes (1 por posición).");
        return;
      }

      final actual = _contarPorPosicion(idsSuplentes, jugador.posicion);
      if (actual >= 1) {
        _mostrarMensaje(
          "Ya existe un suplente para la posición ${jugador.posicion}.",
        );
        return;
      }

      if (idsTitulares.contains(jugador.id)) {
        _mostrarMensaje("Un jugador no puede ser titular y suplente a la vez.");
        return;
      }

      idsSuplentes.add(jugador.id);
    }

    setState(() {});
  }

  /*
    Nombre: _validarSeleccion
    Descripción:
      Valida que la cantidad y distribución de titulares y suplentes sea correcta.
    Entradas:
      - ninguna
    Salidas:
      - bool (true si la selección es válida)
  */
  bool _validarSeleccion() {
    if (idsTitulares.length != 11) {
      _mostrarMensaje("Debe haber exactamente 11 titulares.");
      return false;
    }

    if (idsSuplentes.length != 4) {
      _mostrarMensaje("Debe haber exactamente 4 suplentes (1 por posición).");
      return false;
    }

    final limites = _limitesTitulares();
    for (final pos in ["POR", "DEF", "MED", "DEL"]) {
      final countTitulares = _contarPorPosicion(idsTitulares, pos);
      if (countTitulares != (limites[pos] ?? 0)) {
        _mostrarMensaje(
          "Distribución de titulares inválida para la posición $pos en la formación ${widget.formacion}.",
        );
        return false;
      }

      final countSuplentes = _contarPorPosicion(idsSuplentes, pos);
      if (countSuplentes != 1) {
        _mostrarMensaje("Debe haber exactamente 1 suplente $pos.");
        return false;
      }
    }

    return true;
  }

  /*
    Nombre: _confirmarAlineacion
    Descripción:
      Valida la selección y guarda la alineación inicial mediante el controlador.
      Navega luego a la pantalla de resumen.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _confirmarAlineacion() async {
    if (!_validarSeleccion()) return;

    final usuario = servicioAutenticacion.obtenerUsuarioActual();
    if (usuario == null) {
      _mostrarMensaje("No hay usuario autenticado.");
      return;
    }

    try {
      final alineacion = await controladorAlineaciones.guardarAlineacionInicial(
        usuario.uid,
        widget.liga.id,
        widget.idEquipoFantasy,
        idsTitulares,
        idsSuplentes,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UiUsuarioEquipoFantasyResumenDesktop(
            liga: widget.liga,
            participacion: widget.participacion,
            alineacion: alineacion,
            plantel: widget.plantel,
          ),
        ),
      );
    } catch (e) {
      _mostrarMensaje("Error al guardar la alineación inicial.");
    }
  }

  /*
    Nombre: _seccionSeleccion
    Descripción:
      Construye una sección de selección (titulares o suplentes) con checkboxes.
    Entradas:
      - String titulo
      - List<String> seleccionados
      - void Function(JugadorReal) onToggle
    Salidas:
      - Widget
  */
  Widget _seccionSeleccion(
    String titulo,
    List<String> seleccionados,
    void Function(JugadorReal) onToggle,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        title: Text("$titulo (${seleccionados.length})"),
        children: widget.plantel
            .map(
              (j) => CheckboxListTile(
                title: Text("${j.nombre} (${j.posicion})"),
                subtitle: Text("Equipo real: ${j.idEquipoReal}"),
                value: seleccionados.contains(j.id),
                onChanged: (_) => onToggle(j),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Alineación inicial — ${widget.liga.nombre}")),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Equipo: ${widget.participacion.nombreEquipoFantasy}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              "Formación: ${widget.formacion}",
              style: const TextStyle(fontSize: 15),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                _seccionSeleccion(
                  "Titulares (11)",
                  idsTitulares,
                  _alternarTitular,
                ),
                _seccionSeleccion(
                  "Suplentes (4)",
                  idsSuplentes,
                  _alternarSuplente,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ElevatedButton(
              onPressed: _confirmarAlineacion,
              child: const Text("Confirmar alineación inicial"),
            ),
          ),
        ],
      ),
    );
  }
}
