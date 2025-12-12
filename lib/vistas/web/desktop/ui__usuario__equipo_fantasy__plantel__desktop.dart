/*
  Archivo: ui__usuario__equipo_fantasy__plantel__desktop.dart
  Descripción:
    Pantalla de armado del PLANTEL (15 jugadores) para un equipo fantasy.
    El usuario:
      - Elige formación (4‑4‑2 o 4‑3‑3)
      - Ve presupuesto disponible
      - Selecciona 15 jugadores reales activos
      - Debe respetar distribución de posiciones según formación
    Al confirmar el plantel:
      - Crea la alineación inicial en la base (mediante guardarPlantelInicial)
      - Navega hacia la pantalla de selección de titulares/suplentes,
        pasando el idReal de la alineación creada.

  Dependencias:
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - modelos/jugador_real.dart
    - controladores/controlador_equipos_reales.dart
    - controladores/controlador_jugadores_reales.dart
    - controladores/controlador_equipos_fantasy.dart
    - controladores/controlador_alineaciones.dart
    - servicios/servicio_autenticacion.dart
    - servicios/utilidades/servicio_log.dart

  Pantallas destino:
    - ui__usuario__equipo_fantasy__alineacion_inicial__desktop.dart: selección de titulares y suplentes, con idAlineacion real.
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/jugador_real.dart';

import 'package:fantasypro/controladores/controlador_equipos_reales.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';
import 'package:fantasypro/controladores/controlador_equipo_fantasy.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

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
  /// Presupuesto fijo inicial para el armado del plantel.
  static const int _presupuestoInicial = 1000;

  /// Controlador para obtener equipos reales de la liga.
  final ControladorEquiposReales _ctrlEquiposReales =
      ControladorEquiposReales();

  /// Controlador para obtener jugadores reales activos.
  final ControladorJugadoresReales _ctrlJugadoresReales =
      ControladorJugadoresReales();

  /// Controlador para equipos fantasy, para obtener el equipo del usuario.
  final ControladorEquipoFantasy _ctrlEquiposFantasy =
      ControladorEquipoFantasy();

  /// Controlador de alineaciones para guardar alineación inicial.
  final ControladorAlineaciones _ctrlAlineaciones = ControladorAlineaciones();

  /// Servicio de logging.
  final ServicioLog _log = ServicioLog();

  /// Formación actual seleccionada.
  String _formacion = "4-4-2";

  /// Listas de jugadores disponibles por posición.
  List<JugadorReal> _por = [];
  List<JugadorReal> _def = [];
  List<JugadorReal> _med = [];
  List<JugadorReal> _del = [];

  /// IDs de jugadores seleccionados para el plantel.
  final List<String> _seleccionados = [];

  /// Presupuesto restante al seleccionar jugadores.
  int _presupuestoRestante = _presupuestoInicial;

  /// Indica si la lista está cargando.
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Carga todos los equipos reales de la liga y sus jugadores reales activos.
      Luego los agrupa por posición para ser mostrados.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
    });
    try {
      final equipos = await _ctrlEquiposReales.obtenerPorLiga(widget.liga.id);
      List<JugadorReal> acumulado = [];
      for (final eq in equipos) {
        final lista = await _ctrlJugadoresReales.obtenerPorEquipoReal(eq.id);
        acumulado.addAll(lista.where((j) => j.activo));
      }
      _por = acumulado.where((j) => j.posicion == "POR").toList();
      _def = acumulado.where((j) => j.posicion == "DEF").toList();
      _med = acumulado.where((j) => j.posicion == "MED").toList();
      _del = acumulado.where((j) => j.posicion == "DEL").toList();
    } catch (e) {
      // En este contexto no se muestran errores explícitos para carga
    }
    setState(() {
      _cargando = false;
    });
  }

  /*
    Nombre: _limitePorPosicion
    Descripción:
      Devuelve la cantidad máxima permitida de jugadores por posición según la formación.
    Entradas:
      - pos (String): posición ("POR","DEF","MED","DEL")
    Salidas:
      - int: límite permitido
  */
  int _limitePorPosicion(String pos) {
    switch (_formacion) {
      case "4-4-2":
        switch (pos) {
          case "POR":
            return 2;
          case "DEF":
            return 5;
          case "MED":
            return 5;
          case "DEL":
            return 3;
          default:
            return 0;
        }
      case "4-3-3":
        switch (pos) {
          case "POR":
            return 2;
          case "DEF":
            return 5;
          case "MED":
            return 4;
          case "DEL":
            return 4;
          default:
            return 0;
        }
      default:
        return 0;
    }
  }

  /*
    Nombre: _countSeleccionados
    Descripción:
      Cuenta cuántos jugadores seleccionados pertenecen a una posición dada.
    Entradas:
      - pos (String): posición a contar
    Salidas:
      - int: cantidad de jugadores seleccionados en esa posición
  */
  int _countSeleccionados(String pos) {
    List<JugadorReal> todos = [..._por, ..._def, ..._med, ..._del];
    int count = 0;
    for (final id in _seleccionados) {
      final jList = todos.where((e) => e.id == id && e.posicion == pos);
      if (jList.isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  /*
    Nombre: _toggleJugador
    Descripción:
      Agrega o quita un jugador del plantel, validando límite por posición y presupuesto restante.
    Entradas:
      - j (JugadorReal): jugador a togglear
    Salidas: void
  */
  void _toggleJugador(JugadorReal j) {
    final esSeleccionado = _seleccionados.contains(j.id);
    if (!esSeleccionado) {
      final cntPos = _countSeleccionados(j.posicion);
      final limite = _limitePorPosicion(j.posicion);
      if (cntPos >= limite) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              TextosApp.EQUIPO_FANTASY_PLANTEL_MENSAJE_LIMITE_POSICION
                  .replaceAll("{POS}", j.posicion),
            ),
          ),
        );
        return;
      }
      if (_presupuestoRestante - j.valorMercado < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(TextosApp.EQUIPO_FANTASY_PLANTEL_MENSAJE_PRESUPUESTO),
          ),
        );
        return;
      }
      _seleccionados.add(j.id);
      _presupuestoRestante -= j.valorMercado;
    } else {
      _seleccionados.remove(j.id);
      _presupuestoRestante += j.valorMercado;
    }
    setState(() {});
  }

  /*
    Nombre: _cambiarFormacion
    Descripción:
      Modifica la formación seleccionada y reinicia la selección actual.
    Entradas:
      - nueva (String): nueva formación ("4-4-2" o "4-3-3")
    Salidas: void
  */
  void _cambiarFormacion(String nueva) {
    if (nueva == _formacion) return;
    setState(() {
      _formacion = nueva;
      _seleccionados.clear();
      _presupuestoRestante = _presupuestoInicial;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text(TextosApp.EQUIPO_FANTASY_PLANTEL_MENSAJE_FORMACION_CAMBIADA),
      ),
    );
  }

  /*
    Nombre: _confirmarPlantel
    Descripción:
      Valida que haya exactamente 15 jugadores seleccionados, crea la alineación inicial
      mediante el controlador, y navega hacia la pantalla de selección de titulares/suplentes,
      pasando el id real de la alineación creada.

    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _confirmarPlantel() async {
    if (_seleccionados.length != 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            TextosApp.EQUIPO_FANTASY_PLANTEL_MENSAJE_CANTIDAD_INVALIDA,
          ),
        ),
      );
      return;
    }

    final usuario = ServicioAutenticacion().obtenerUsuarioActual();
    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TextosApp.USUARIO_NO_AUTENTICADO)),
      );
      return;
    }

    // Obtener equipo fantasy del usuario en la liga
    final equipos = await _ctrlEquiposFantasy.obtenerEquiposPorUsuarioYLiga(
      usuario.uid,
      widget.liga.id,
    );
    final equipo = equipos.isNotEmpty ? equipos.first : null;
    if (equipo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(TextosApp.EQUIPO_FANTASY_PLANTEL_MENSAJE_SIN_EQUIPO),
        ),
      );
      return;
    }

    _log.informacion(
      TextosApp.LOG_EQUIPO_FANTASY_PLANTEL_CONFIRMAR
          .replaceAll("{LIGA}", widget.liga.id)
          .replaceAll("{USUARIO}", usuario.uid)
          .replaceAll("{EQUIPO}", equipo.id)
          .replaceAll("{CANT}", "${_seleccionados.length}")
          .replaceAll("{PRESUPUESTO}", "$_presupuestoRestante")
          .replaceAll("{FORMACION}", _formacion),
    );

    try {
      // ---------------------------------------------------------------------
      // 1) GUARDAR PLANTEL INICIAL EN EL EQUIPO FANTASY
      // ---------------------------------------------------------------------
      await _ctrlEquiposFantasy.guardarPlantelInicial(
        equipo.id,
        _seleccionados,
        _presupuestoRestante,
      );

      _log.informacion(TextosApp.LOG_EQUIPO_FANTASY_PLANTEL_GUARDADO
          .replaceAll("{EQUIPO}", equipo.id));

      // ---------------------------------------------------------------------
      // 2) CREAR ALINEACIÓN INICIAL (como ya hacía antes)
      // ---------------------------------------------------------------------
      final alineacion = await _ctrlAlineaciones.guardarPlantelInicial(
        widget.liga.id,
        usuario.uid,
        equipo.id,
        _seleccionados,
        _formacion,
      );

      _log.informacion(TextosApp.LOG_EQUIPO_FANTASY_PLANTEL_ALINEACION
          .replaceAll("{ALINEACION}", alineacion.id));

      // ---------------------------------------------------------------------
      // 3) Cargar la lista de modelos JugadorReal antes de navegar
      // ---------------------------------------------------------------------
      final plantel = await _ctrlJugadoresReales.obtenerPorIds(_seleccionados);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UiUsuarioEquipoFantasyAlineacionInicialDesktop(
            liga: widget.liga,
            participacion: widget.participacion,
            idEquipoFantasy: equipo.id,
            idAlineacion: alineacion.id,
            plantel: plantel,
            formacion: _formacion,
          ),
        ),
      );
    } catch (e) {
      _log.error("Error confirmando plantel inicial: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text(TextosApp.EQUIPO_FANTASY_PLANTEL_MENSAJE_ERROR_GUARDAR),
        ),
      );
    }
  }

  /*
    Nombre: _buildListaPorPosicion
    Descripción:
      Crea un widget ExpansionTile con lista de jugadores de una posición dada.
    Entradas:
      - titulo (String): título de sección
      - lista (List<JugadorReal>): jugadores disponibles
    Salidas:
      - Widget
  */
  Widget _buildListaPorPosicion(String titulo, List<JugadorReal> lista) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: ExpansionTile(
        title: Text("$titulo (${lista.length})"),
        children: lista
            .map(
              (j) => ListTile(
                title: Text(j.nombre),
                subtitle: Text(
                  TextosApp.EQUIPO_FANTASY_PLANTEL_SUBTITULO_JUGADOR
                      .replaceAll("{EQUIPO}", j.nombreEquipoReal)
                      .replaceAll("{VALOR}", "${j.valorMercado}"),
                ),
                trailing: Checkbox(
                  value: _seleccionados.contains(j.id),
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
      appBar: AppBar(
        title: Text(
          TextosApp.EQUIPO_FANTASY_PLANTEL_APPBAR_TITULO
              .replaceAll("{LIGA}", widget.liga.nombre),
        ),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Text(TextosApp.EQUIPO_FANTASY_PLANTEL_LABEL_FORMACION,
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _formacion,
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
                        onChanged: (v) {
                          if (v != null) _cambiarFormacion(v);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    TextosApp.EQUIPO_FANTASY_PLANTEL_TEXTO_PRESUPUESTO
                        .replaceAll("{RESTANTE}", "$_presupuestoRestante")
                        .replaceAll("{INICIAL}", "$_presupuestoInicial"),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      _buildListaPorPosicion(
                        TextosApp.EQUIPO_FANTASY_PLANTEL_SECCION_ARQUEROS,
                        _por,
                      ),
                      _buildListaPorPosicion(
                        TextosApp.EQUIPO_FANTASY_PLANTEL_SECCION_DEFENSORES,
                        _def,
                      ),
                      _buildListaPorPosicion(
                        TextosApp.EQUIPO_FANTASY_PLANTEL_SECCION_MEDIOCAMPISTAS,
                        _med,
                      ),
                      _buildListaPorPosicion(
                        TextosApp.EQUIPO_FANTASY_PLANTEL_SECCION_DELANTEROS,
                        _del,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _confirmarPlantel,
                  child: const Text(
                    TextosApp.EQUIPO_FANTASY_PLANTEL_BOTON_CONFIRMAR,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
    );
  }
}
