/*
  Archivo: ui__admin__puntajes_reales__lista__desktop.dart
  Descripción:
    Pantalla para cargar los puntajes reales (1–10) de Jugadores Reales para una
    FechaLiga activa. Permite seleccionar equipo real, listar jugadores y asignar
    puntajes parciales. No permite cargar puntajes si la fecha está cerrada.

  Dependencias:
    - modelos/fecha_liga.dart
    - modelos/liga.dart
    - modelos/jugador_real.dart
    - modelos/equipo_real.dart
    - controladores/controlador_puntajes_reales.dart
    - controladores/controlador_equipos_reales.dart
*/

import 'package:fantasypro/controladores/controlador_equipos_reales.dart';
import 'package:fantasypro/controladores/controlador_puntajes_reales.dart';
import 'package:fantasypro/modelos/equipo_real.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:flutter/material.dart';

class UiAdminPuntajesRealesListaDesktop extends StatefulWidget {
  final Liga liga;
  final FechaLiga fecha;

  const UiAdminPuntajesRealesListaDesktop({
    super.key,
    required this.liga,
    required this.fecha,
  });

  @override
  State<UiAdminPuntajesRealesListaDesktop> createState() =>
      _UiAdminPuntajesRealesListaDesktopEstado();
}

class _UiAdminPuntajesRealesListaDesktopEstado
    extends State<UiAdminPuntajesRealesListaDesktop> {
  final ControladorPuntajesReales _ctrlPuntajes = ControladorPuntajesReales();
  final ControladorEquiposReales _ctrlEquipos = ControladorEquiposReales();

  bool cargando = true;

  Map<String, List<JugadorReal>> jugadoresPorEquipo = {};
  List<EquipoReal> equiposOrdenados = [];
  String? equipoSeleccionado;

  /// Mapa idJugadorReal → puntaje seleccionado (1–10)
  final Map<String, int?> puntajesSeleccionados = {};

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Carga equipos reales y jugadores reales activos, luego ordena los equipos
      alfabéticamente y establece selección inicial.
  */
  Future<void> _cargar() async {
    setState(() => cargando = true);

    jugadoresPorEquipo = await _ctrlPuntajes.obtenerJugadoresPorEquipo(
      widget.liga.id,
    );

    final equipos = await _ctrlEquipos.obtenerPorLiga(widget.liga.id);
    equiposOrdenados = equipos.where((e) => e.activo).toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    if (equiposOrdenados.isNotEmpty) {
      equipoSeleccionado = equiposOrdenados.first.id;
    }

    setState(() => cargando = false);
  }

  /*
    Nombre: _guardar
    Descripción:
      Construye el mapa limpio idJugadorReal → puntaje (sin nulos),
      delega en el controlador y muestra feedback.
  */
  Future<void> _guardar() async {
    final mapa = <String, int>{};

    for (final e in puntajesSeleccionados.entries) {
      if (e.value != null) mapa[e.key] = e.value!;
    }

    await _ctrlPuntajes.guardarPuntajesDeFecha(
      widget.liga.id,
      widget.fecha.id,
      mapa,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      const SnackBar(
        content:
            Text(TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_SNACKBAR_GUARDADO),
      ),
    );
  }

  /*
    Nombre: _itemJugador
    Descripción:
      Renderiza un jugador y su dropdown de puntaje.
  */
  Widget _itemJugador(JugadorReal j) {
    final puntajeActual = puntajesSeleccionados[j.id];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TITULO_JUGADOR
              .replaceFirst("{NOMBRE}", j.nombre)
              .replaceFirst("{POSICION}", j.posicion)
              .replaceFirst(
                "{DORSAL}",
                j.dorsal != null
                    ? TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_DORSAL
                        .replaceFirst("{DORSAL}", j.dorsal.toString())
                    : "",
              ),
        ),
        subtitle: const Text(
          TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_PUNTAJE_REAL,
        ),
        trailing: DropdownButton<int>(
          value: puntajeActual,
          hint: const Text(
            TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_HINT_PUNTAJE_JUGADOR,
          ),
          items: List.generate(
            10,
            (i) =>
                DropdownMenuItem(value: i + 1, child: Text((i + 1).toString())),
          ),
          onChanged: widget.fecha.cerrada
              ? null
              : (v) => setState(() => puntajesSeleccionados[j.id] = v),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fecha = widget.fecha;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TITULO_APPBAR
              .replaceFirst("{NUMERO}", fecha.numeroFecha.toString()),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // ---- CONTENIDO SCROLLEABLE ----
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Encabezado (ya no muestra ID)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_LIGA
                              .replaceFirst("{LIGA}", widget.liga.nombre),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_FECHA
                              .replaceFirst("{NOMBRE}", fecha.nombre)
                              .replaceFirst(
                                "{NUMERO}",
                                fecha.numeroFecha.toString(),
                              ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      const SizedBox(height: 16),
                      const Divider(),

                      if (fecha.cerrada)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            TextosApp
                                .ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_MENSAJE_FECHA_CERRADA,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      // Selector de equipo real
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButton<String>(
                          value: equipoSeleccionado,
                          hint: const Text(
                            TextosApp.ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_HINT_EQUIPO,
                          ),
                          items: equiposOrdenados
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e.id,
                                  child: Text(e.nombre),
                                ),
                              )
                              .toList(),
                          onChanged: fecha.cerrada
                              ? null
                              : (v) => setState(() => equipoSeleccionado = v),
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (equipoSeleccionado != null)
                        ...jugadoresPorEquipo[equipoSeleccionado]!.map(
                          _itemJugador,
                        ),
                    ],
                  ),
                ),

                // ---- BOTÓN FIJO ----
                if (!fecha.cerrada)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: SafeArea(
                      child: ElevatedButton.icon(
                        onPressed: _guardar,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          TextosApp
                              .ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_LABEL_GUARDAR_PUNTAJES,
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
