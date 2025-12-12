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
import 'package:fantasypro/textos/textos_app.dart';
import 'widgets/ui__usuario__appbar__desktop.dart';
import 'ui__usuario__resultados__detalle_jugadores__desktop.dart';

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
        _mensajeError =
            TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_ERROR_CARGA;
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
    if (puntaje == null) {
      return TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SIN_PUNTAJE;
    }
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
        ? TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SIN_PARTICIPACION
        : (fecha.cerrada
            ? TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_FECHA_CERRADA
            : TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_FECHA_PENDIENTE);
    final puntaje = _puntajesPorFecha[fecha.id];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ListTile(
        title: Text(
          TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_TITULO_FECHA
              .replaceFirst("{NUMERO}", fecha.numeroFecha.toString())
              .replaceFirst("{NOMBRE}", fecha.nombre),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _puntajeDeFecha(fecha),
              style: const TextStyle(fontSize: 16),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiUsuarioResultadosDetalleJugadoresDesktop(
                      liga: widget.liga,
                      usuario: widget.usuario,
                      fecha: fecha,
                      puntajeFantasy: puntaje,
                      nombreEquipoFantasy:
                          _participacion?.nombreEquipoFantasy ?? "",
                    ),
                  ),
                );
              },
              child: const Text(
                TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_BOTON_VER_DETALLE,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiUsuarioAppBarDesktop(
        titulo: TextosApp.USUARIO_RESULTADOS_POR_FECHA_DESKTOP_TITULO_APPBAR
            .replaceFirst("{LIGA}", widget.liga.nombre),
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
                        TextosApp
                            .USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SIN_PARTICIPACION_TITULO,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    TextosApp
                        .USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SUBTITULO_LISTA,
                    style: TextStyle(fontSize: 16),
                  ),
                    const SizedBox(height: 12),
                    for (final fecha in _fechas) _buildFilaFecha(fecha),
                  ],
                ),
    );
  }
}
