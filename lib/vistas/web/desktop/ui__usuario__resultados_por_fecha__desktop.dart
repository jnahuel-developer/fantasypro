/*
  Archivo: ui__usuario__resultados_por_fecha__desktop.dart
  Descripción:
    Pantalla que muestra el puntaje obtenido por el usuario en cada fecha
    de una liga. Lista todas las fechas aunque no tengan puntaje registrado
    todavía.

  Dependencias:
    - modelos/liga.dart
    - modelos/fecha_liga.dart
    - modelos/participacion_liga.dart
    - modelos/puntaje_equipo_fantasy.dart
    - controladores/controlador_fechas.dart
    - controladores/controlador_participaciones.dart
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_fechas.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/modelos/puntaje_equipo_fantasy.dart';

class UiUsuarioResultadosPorFechaDesktop extends StatefulWidget {
  /// Liga seleccionada.
  final Liga liga;

  /// Usuario autenticado.
  final User usuario;

  const UiUsuarioResultadosPorFechaDesktop({
    super.key,
    required this.liga,
    required this.usuario,
  });

  @override
  State<UiUsuarioResultadosPorFechaDesktop> createState() =>
      _UiUsuarioResultadosPorFechaDesktopEstado();
}

class _UiUsuarioResultadosPorFechaDesktopEstado
    extends State<UiUsuarioResultadosPorFechaDesktop> {
  /// Controlador de fechas.
  final ControladorFechas _controladorFechas = ControladorFechas();

  /// Controlador de participaciones.
  final ControladorParticipaciones _controladorParticipaciones =
      ControladorParticipaciones();

  /// Listado de fechas de la liga.
  List<FechaLiga> _fechas = [];

  /// Participación del usuario en la liga.
  ParticipacionLiga? _participacion;

  /// Puntajes por fecha.
  final Map<String, PuntajeEquipoFantasy?> _puntajesPorFecha = {};

  /// Estado de carga.
  bool _cargando = true;

  /// Mensaje de error.
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  /*
    Nombre: _cargarDatos
    Descripción:
      Obtiene las fechas de la liga y el puntaje del usuario por cada una.
      Siempre lista las fechas; si el usuario no tiene participación o
      puntaje en una fecha, el valor será nulo.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);

    try {
      // 1) Obtener todas las fechas de la liga
      final fechas = await _controladorFechas.obtenerPorLiga(widget.liga.id);

      // 2) Obtener puntajes fantasy del usuario en esta liga
      final listaPuntajes =
          await _controladorParticipaciones.obtenerPuntajesFantasyDeUsuarioEnLiga(
        widget.liga.id,
        widget.usuario.uid,
      );

      // 3) Mapear por idFecha para acceder rápido
      _puntajesPorFecha
        ..clear()
        ..addAll({for (final p in listaPuntajes) p.idFecha: p});

      final participacion = await _controladorParticipaciones
          .obtenerParticipacionUsuarioEnLiga(widget.liga.id, widget.usuario.uid);

      setState(() {
        _fechas = fechas;
        _participacion = participacion;
        _mensajeError = null;
      });
    } catch (_) {
      setState(() {
        _fechas = [];
        _participacion = null;
        _puntajesPorFecha.clear();
        _mensajeError = "No se pudieron cargar los resultados.";
      });
    }

    setState(() => _cargando = false);
  }

  /*
    Nombre: _puntajeDeFecha
    Descripción:
      Retorna una representación textual del puntaje para una fecha.
      Si no existe puntaje, devuelve "–".
    Entradas:
      - fecha (FechaLiga): fecha de liga a evaluar.
    Salidas:
      - String
  */
  String _puntajeDeFecha(FechaLiga fecha) {
    final puntaje = _puntajesPorFecha[fecha.id];
    if (puntaje == null) return "–";
    return puntaje.puntajeTotal.toString();
  }

  /*
    Nombre: _buildFilaFecha
    Descripción:
      Construye la fila visual para una fecha específica mostrando
      nombre y puntaje obtenido.
    Entradas:
      - fecha (FechaLiga): fecha a renderizar.
    Salidas:
      - Widget
  */
  Widget _buildFilaFecha(FechaLiga fecha) {
    final subtitulo = _participacion == null
        ? "El usuario no tiene participación en la liga"
        : (fecha.cerrada ? "Fecha cerrada" : "Fecha pendiente");

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(
          "${fecha.numeroFecha}. ${fecha.nombre}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: Text(
          _puntajeDeFecha(fecha),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados por fecha — ${widget.liga.nombre}"),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _mensajeError != null
              ? Center(child: Text(_mensajeError!))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      _participacion?.nombreEquipoFantasy ??
                          "Sin participación registrada",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Puntaje obtenido por fecha",
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    for (final fecha in _fechas) _buildFilaFecha(fecha),
                  ],
                ),
    );
  }
}
