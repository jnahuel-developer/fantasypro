/*
  Archivo: ui__usuario__equipo_fantasy__plantel__desktop.dart
  Descripción:
    Pantalla de armado del PLANTEL (15 jugadores) para un equipo fantasy.
    El usuario:
      - Elige formación (4-4-2 o 4-3-3)
      - Ve presupuesto disponible
      - Selecciona 15 jugadores reales activos
      - Debe respetar distribución de posiciones según formación
      - Esta pantalla NO guarda en BD → solo arma el plantel
        El guardado se hace en la pantalla de Alineación Inicial.

  Dependencias:
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - modelos/jugador_real.dart
    - modelos/equipo_real.dart
    - controladores/controlador_equipos_reales.dart
    - controladores/controlador_jugadores_reales.dart
*/

import 'package:fantasypro/controladores/controlador_equipo_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/jugador_real.dart';

import 'package:fantasypro/controladores/controlador_equipos_reales.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';

import 'ui__usuario__equipo_fantasy__alineacion_inicial__desktop.dart';

class UiUsuarioEquipoFantasyPlantelDesktop extends StatefulWidget {
  final Liga liga;
  final ParticipacionLiga participacion;

  const UiUsuarioEquipoFantasyPlantelDesktop({
    super.key,
    required this.liga,
    required this.participacion,
  });

  @override
  State<UiUsuarioEquipoFantasyPlantelDesktop> createState() =>
      _UiUsuarioEquipoFantasyPlantelDesktopEstado();
}

class _UiUsuarioEquipoFantasyPlantelDesktopEstado
    extends State<UiUsuarioEquipoFantasyPlantelDesktop> {
  /// Presupuesto fijo inicial (aprobado por PM)
  static const int presupuestoInicial = 1000;

  /// Controladores
  final ControladorEquiposReales ctrlEquipos = ControladorEquiposReales();
  final ControladorJugadoresReales ctrlJugadores = ControladorJugadoresReales();

  bool cargando = true;

  /// Formación actual (solo 2 opciones)
  String formacion = "4-4-2";

  /// Jugadores disponibles por posición
  List<JugadorReal> por = [];
  List<JugadorReal> def = [];
  List<JugadorReal> med = [];
  List<JugadorReal> del = [];

  /// Jugadores seleccionados (sus IDs)
  final List<String> seleccionados = [];

  int presupuestoRestante = presupuestoInicial;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Carga todos los equipos reales de la liga y sus jugadores reales activos.
      Luego agrupa jugadores por posición para mostrarlos.
  */
  Future<void> _cargar() async {
    setState(() => cargando = true);

    final equipos = await ctrlEquipos.obtenerPorLiga(widget.liga.id);

    List<JugadorReal> acumulado = [];

    for (final eq in equipos) {
      final lista = await ctrlJugadores.obtenerPorEquipoReal(eq.id);
      acumulado.addAll(lista.where((j) => j.activo));
    }

    por = acumulado.where((j) => j.posicion == "POR").toList();
    def = acumulado.where((j) => j.posicion == "DEF").toList();
    med = acumulado.where((j) => j.posicion == "MED").toList();
    del = acumulado.where((j) => j.posicion == "DEL").toList();

    setState(() => cargando = false);
  }

  /*
    Nombre: _limitePorPosicion
    Descripción:
      Devuelve la cantidad máxima permitida para una posición según la formación.
  */
  int _limitePorPosicion(String pos) {
    if (formacion == "4-4-2") {
      switch (pos) {
        case "POR":
          return 2;
        case "DEF":
          return 5;
        case "MED":
          return 5;
        case "DEL":
          return 3;
      }
    } else if (formacion == "4-3-3") {
      switch (pos) {
        case "POR":
          return 2;
        case "DEF":
          return 5;
        case "MED":
          return 4;
        case "DEL":
          return 4;
      }
    }
    return 0;
  }

  /*
    Nombre: _countSeleccionados
    Descripción:
      Devuelve cuántos jugadores del plantel seleccionado pertenecen a una posición.
  */
  int _countSeleccionados(String pos) {
    // Para contar, hay que buscar en todas las listas ya cargadas
    int count = 0;

    List<JugadorReal> todos = [...por, ...def, ...med, ...del];

    for (final id in seleccionados) {
      final j = todos.firstWhere((e) => e.id == id);
      if (j.posicion == pos) count++;
    }

    return count;
  }

  /*
    Nombre: _toggleJugador
    Descripción:
      Agrega o saca un jugador del plantel respetando límites y presupuesto.
  */
  void _toggleJugador(JugadorReal j) {
    final esSeleccionado = seleccionados.contains(j.id);

    if (!esSeleccionado) {
      // Validar límite por posición
      final cantPos = _countSeleccionados(j.posicion);
      if (cantPos >= _limitePorPosicion(j.posicion)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Límite alcanzado para ${j.posicion}")),
        );
        return;
      }

      // Validar presupuesto
      if (presupuestoRestante - j.valorMercado < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Presupuesto insuficiente.")),
        );
        return;
      }

      seleccionados.add(j.id);
      presupuestoRestante -= j.valorMercado;
    } else {
      seleccionados.remove(j.id);
      presupuestoRestante += j.valorMercado;
    }

    setState(() {});
  }

  /*
    Nombre: _cambiarFormacion
    Descripción:
      Permite cambiar formación, reiniciando la selección actual.
  */
  void _cambiarFormacion(String nueva) {
    if (nueva == formacion) return;

    setState(() {
      formacion = nueva;
      seleccionados.clear();
      presupuestoRestante = presupuestoInicial;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Formación cambiada. Selección reiniciada."),
      ),
    );
  }

  /*
    Nombre: _confirmarPlantel
    Descripción:
      Valida que haya exactamente 15 jugadores seleccionados.
      Navega a la pantalla de selección de titulares/suplentes.
  */
  Future<void> _confirmarPlantel() async {
    if (seleccionados.length != 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debés seleccionar exactamente 15 jugadores."),
        ),
      );
      return;
    }

    final usuario = ServicioAutenticacion().obtenerUsuarioActual();
    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay usuario autenticado.")),
      );
      return;
    }

    final equipo = await ControladorEquipoFantasy().obtenerEquipoUsuarioEnLiga(
      usuario.uid,
      widget.liga.id,
    );

    if (equipo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se encontró tu equipo fantasy.")),
      );
      return;
    }

    final plantel = await ControladorJugadoresReales().obtenerPorIds(
      seleccionados,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UiUsuarioEquipoFantasyAlineacionInicialDesktop(
          liga: widget.liga,
          participacion: widget.participacion,
          idEquipoFantasy: equipo.id,
          plantel: plantel,
          formacion: formacion,
        ),
      ),
    );
  }

  /*
    Nombre: _listaJugadores
    Descripción:
      Crea la lista visual de jugadores para una posición.
  */
  Widget _listaJugadores(String titulo, List<JugadorReal> lista) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        title: Text("$titulo (${lista.length})"),
        children: lista
            .map(
              (j) => ListTile(
                title: Text(j.nombre),
                subtitle: Text(
                  "Equipo: ${j.idEquipoReal} · Valor: ${j.valorMercado}",
                ),
                trailing: Checkbox(
                  value: seleccionados.contains(j.id),
                  onChanged: (_) => _toggleJugador(j),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Armado del plantel — ${widget.liga.nombre}")),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),

                // Formación
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text("Formación:", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: formacion,
                        items: const [
                          DropdownMenuItem(
                            value: "4-4-2",
                            child: Text("4-4-2"),
                          ),
                          DropdownMenuItem(
                            value: "4-3-3",
                            child: Text("4-3-3"),
                          ),
                        ],
                        onChanged: (v) => _cambiarFormacion(v!),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Presupuesto
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Presupuesto restante: $presupuestoRestante / $presupuestoInicial",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Divider(),

                // Listas de jugadores
                Expanded(
                  child: ListView(
                    children: [
                      _listaJugadores("Arqueros (POR)", por),
                      _listaJugadores("Defensores (DEF)", def),
                      _listaJugadores("Mediocampistas (MED)", med),
                      _listaJugadores("Delanteros (DEL)", del),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _confirmarPlantel,
                  child: const Text("Confirmar plantel"),
                ),

                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
