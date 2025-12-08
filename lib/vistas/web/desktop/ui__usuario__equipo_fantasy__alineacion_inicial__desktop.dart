/*
  Archivo: ui__usuario__equipo_fantasy__alineacion_inicial__desktop.dart
  Descripción:
    Pantalla destinada a la selección de la alineación inicial del equipo fantasy.
    Se permite elegir 11 titulares y 4 suplentes (uno por posición) a partir del plantel
    previamente definido. Una vez confirmada la alineación, se procede a guardar la
    información mediante el controlador oficial y posteriormente se navega hacia la
    pantalla de resumen del equipo fantasy.

  Dependencias:
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - modelos/jugador_real.dart
    - servicios/servicio_autenticacion.dart
    - servicios/utilidades/servicio_log.dart
    - controladores/controlador_alineaciones.dart

  Pantallas destino:
    - ui__usuario__equipo_fantasy__resumen__desktop.dart: muestra el resumen final del equipo.
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'widgets/ui__usuario__appbar__desktop.dart';

import 'ui__usuario__equipo_fantasy__resumen__desktop.dart';

class UiUsuarioEquipoFantasyAlineacionInicialDesktop extends StatefulWidget {
  final Liga liga;
  final ParticipacionLiga participacion;
  final String idEquipoFantasy;
  final String idAlineacion; // ← agregado según requisito oficial
  final List<JugadorReal> plantel;
  final String formacion;

  const UiUsuarioEquipoFantasyAlineacionInicialDesktop({
    super.key,
    required this.liga,
    required this.participacion,
    required this.idEquipoFantasy,
    required this.idAlineacion, // ← parámetro requerido
    required this.plantel,
    required this.formacion,
  });

  @override
  State<UiUsuarioEquipoFantasyAlineacionInicialDesktop> createState() =>
      _UiUsuarioEquipoFantasyAlineacionInicialDesktopEstado();
}

class _UiUsuarioEquipoFantasyAlineacionInicialDesktopEstado
    extends State<UiUsuarioEquipoFantasyAlineacionInicialDesktop> {
  /// Servicio destinado a obtener los datos del usuario actual.
  final ServicioAutenticacion _servicioAuth = ServicioAutenticacion();

  /// Controlador encargado de la gestión de alineaciones.
  final ControladorAlineaciones _ctrlAlineaciones = ControladorAlineaciones();

  /// Servicio de log para registrar eventos relevantes.
  final ServicioLog _log = ServicioLog();

  /// Identificadores de los jugadores seleccionados como titulares.
  final List<String> _idsTitulares = [];

  /// Identificadores de los jugadores seleccionados como suplentes.
  final List<String> _idsSuplentes = [];

  /*
    Nombre: _limitesTitulares
    Descripción:
      Devuelve un mapa que contiene los límites permitidos por posición para los titulares,
      definidos en función de la formación establecida para el equipo.
    Entradas: ninguna
    Salidas:
      - Map<String, int>: límites por posición.
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
      Realiza un conteo de cuántos jugadores seleccionados pertenecen a una posición específica.
    Entradas:
      - ids (List<String>): lista de identificadores seleccionados
      - posicion (String): posición a evaluar (POR, DEF, MED, DEL)
    Salidas:
      - int: cantidad encontrada por posición.
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
      Muestra un mensaje breve mediante un SnackBar.
    Entradas:
      - texto (String): mensaje a desplegar.
    Salidas: void.
  */
  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  /*
    Nombre: _alternarTitular
    Descripción:
      Realiza la asignación o eliminación de un jugador como titular, respetando los
      límites permitidos por posición y evitando conflictos con suplentes.
    Entradas:
      - jugador (JugadorReal)
    Salidas: void.
  */
  void _alternarTitular(JugadorReal jugador) {
    if (_idsTitulares.contains(jugador.id)) {
      _idsTitulares.remove(jugador.id);
    } else {
      if (_idsTitulares.length >= 11) {
        _mostrarMensaje("Debe haber exactamente 11 titulares.");
        return;
      }

      final limites = _limitesTitulares();
      final usados = _contarPorPosicion(_idsTitulares, jugador.posicion);

      if (usados >= (limites[jugador.posicion] ?? 0)) {
        _mostrarMensaje(
          "Máximo alcanzado para ${jugador.posicion} según formación ${widget.formacion}.",
        );
        return;
      }

      if (_idsSuplentes.contains(jugador.id)) {
        _mostrarMensaje(
          "Un jugador no puede ser titular y suplente simultáneamente.",
        );
        return;
      }

      _idsTitulares.add(jugador.id);
    }

    setState(() {});
  }

  /*
    Nombre: _alternarSuplente
    Descripción:
      Realiza la asignación o eliminación como suplente, verificando que exista uno por posición.
    Entradas:
      - jugador (JugadorReal)
    Salidas: void.
  */
  void _alternarSuplente(JugadorReal jugador) {
    if (_idsSuplentes.contains(jugador.id)) {
      _idsSuplentes.remove(jugador.id);
    } else {
      if (_idsSuplentes.length >= 4) {
        _mostrarMensaje(
          "Debe haber exactamente 4 suplentes (uno por posición).",
        );
        return;
      }

      if (_contarPorPosicion(_idsSuplentes, jugador.posicion) >= 1) {
        _mostrarMensaje("Ya existe un suplente ${jugador.posicion}.");
        return;
      }

      if (_idsTitulares.contains(jugador.id)) {
        _mostrarMensaje(
          "Un jugador no puede ser titular y suplente simultáneamente.",
        );
        return;
      }

      _idsSuplentes.add(jugador.id);
    }

    setState(() {});
  }

  /*
    Nombre: _validarSeleccion
    Descripción:
      Verifica que la selección cumpla estrictamente con las reglas de cantidad y
      distribución para titulares y suplentes.
    Entradas: ninguna
    Salidas:
      - bool: true si la selección es válida; false si se detecta inconsistencia.
  */
  bool _validarSeleccion() {
    if (_idsTitulares.length != 11) {
      _mostrarMensaje("Debe haber exactamente 11 titulares.");
      return false;
    }

    if (_idsSuplentes.length != 4) {
      _mostrarMensaje("Debe haber exactamente 4 suplentes.");
      return false;
    }

    final limites = _limitesTitulares();

    for (final pos in ["POR", "DEF", "MED", "DEL"]) {
      if (_contarPorPosicion(_idsTitulares, pos) != (limites[pos] ?? 0)) {
        _mostrarMensaje("Distribución incorrecta para posición $pos.");
        return false;
      }
      if (_contarPorPosicion(_idsSuplentes, pos) != 1) {
        _mostrarMensaje("Debe existir exactamente 1 suplente $pos.");
        return false;
      }
    }

    return true;
  }

  /*
    Nombre: _confirmarAlineacion
    Descripción:
      Ejecuta la validación correspondiente y procede a guardar la alineación inicial,
      utilizando el idAlineacion real. Una vez persistida la información, la vista
      navega hacia la pantalla de resumen.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _confirmarAlineacion() async {
    if (!_validarSeleccion()) return;

    final usuario = _servicioAuth.obtenerUsuarioActual();
    if (usuario == null) {
      _mostrarMensaje("No hay usuario autenticado.");
      return;
    }

    try {
      _log.informacion(
        "Guardando alineación inicial con idAlineacion=${widget.idAlineacion}, "
        "idLiga=${widget.liga.id}, idUsuario=${usuario.uid}",
      );

      final alineacion = await _ctrlAlineaciones.guardarAlineacionInicial(
        widget.liga.id, // idLiga
        usuario.uid, // idUsuario
        widget.idAlineacion, // idAlineacion real
        _idsTitulares,
        _idsSuplentes,
      );

      _log.informacion(
        "guardarAlineacionInicial finalizado correctamente para idAlineacion=${alineacion.id}",
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
      _log.informacion("Error al guardar alineación inicial: $e");
      _mostrarMensaje("Error al guardar la alineación inicial.");
    }
  }

  /*
    Nombre: _seccionSeleccion
    Descripción:
      Genera un bloque visual para seleccionar titulares o suplentes, utilizando
      elementos de tipo CheckboxListTile.
    Entradas:
      - titulo (String)
      - seleccionados (List<String>)
      - onToggle (void Function(JugadorReal))
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
                subtitle: Text("Equipo real: ${j.nombreEquipoReal}"),
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
      appBar: UiUsuarioAppBarDesktop(
        titulo: "Alineación inicial — ${widget.liga.nombre}",
      ),
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
                  _idsTitulares,
                  _alternarTitular,
                ),
                _seccionSeleccion(
                  "Suplentes (4)",
                  _idsSuplentes,
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
