/*
  Archivo: ui__usuario__dashboard__desktop.dart
  Descripción:
    Pantalla inicial para usuarios finales no administradores. Presenta
    accesos rápidos para crear equipos y revisar resultados por fecha.

  Dependencias:
    - firebase_auth.dart
    - controladores/controlador_ligas.dart
    - controladores/controlador_participaciones.dart
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - vistas/ui__usuario__inicio__lista__desktop.dart
    - vistas/ui__usuario__resultados_por_fecha__desktop.dart
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';

import 'widgets/ui__usuario__appbar__desktop.dart';
import 'ui__usuario__inicio__lista__desktop.dart';
import 'ui__usuario__resultados_por_fecha__desktop.dart';

class _ParticipacionConLiga {
  final ParticipacionLiga participacion;
  final Liga liga;

  const _ParticipacionConLiga({
    required this.participacion,
    required this.liga,
  });
}

class UiUsuarioDashboardDesktop extends StatefulWidget {
  const UiUsuarioDashboardDesktop({super.key});

  @override
  State<UiUsuarioDashboardDesktop> createState() =>
      _UiUsuarioDashboardDesktopEstado();
}

class _UiUsuarioDashboardDesktopEstado
    extends State<UiUsuarioDashboardDesktop> {
  /// Controlador de participaciones.
  final ControladorParticipaciones _ctrlParticipaciones =
      ControladorParticipaciones();

  /// Controlador de ligas.
  final ControladorLigas _ctrlLigas = ControladorLigas();

  /// Usuario autenticado.
  User? _usuario;

  /// Lista de participaciones con su liga asociada.
  List<_ParticipacionConLiga> _participaciones = [];

  /// Estado de carga.
  bool _cargando = true;

  /// Mensaje de error.
  String? _mensajeError;

  @override
  void initState() {
    super.initState();
    _cargarParticipaciones();
  }

  /*
    Nombre: _cargarParticipaciones
    Descripción:
      Obtiene las participaciones activas del usuario autenticado y sus
      respectivas ligas para mostrarlas en el dashboard.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cargarParticipaciones() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final usuarioActual = FirebaseAuth.instance.currentUser;
    if (usuarioActual == null) {
      setState(() {
        _usuario = null;
        _participaciones = [];
        _mensajeError = "No hay usuario autenticado.";
        _cargando = false;
      });
      return;
    }

    List<_ParticipacionConLiga> items = [];
    String? mensajeError;

    try {
      final participacionesUsuario =
          await _ctrlParticipaciones.obtenerPorUsuario(usuarioActual.uid);

      for (final participacion in participacionesUsuario) {
        final liga = await _ctrlLigas.obtenerPorId(participacion.idLiga);
        if (liga != null) {
          items.add(
            _ParticipacionConLiga(
              participacion: participacion,
              liga: liga,
            ),
          );
        }
      }
    } catch (e) {
      mensajeError = "No se pudieron cargar tus participaciones.";
    }

    if (!mounted) return;

    setState(() {
      _usuario = usuarioActual;
      _participaciones = items;
      _mensajeError = mensajeError;
      _cargando = false;
    });
  }

  /*
    Nombre: _botonAccion
    Descripción:
      Construye un botón elevado con estilo uniforme para las acciones
      principales del dashboard.
    Entradas:
      - texto (String): etiqueta del botón.
      - onPressed (VoidCallback): acción a ejecutar.
    Salidas:
      - Widget
  */
  Widget _botonAccion(String texto, VoidCallback onPressed) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(texto, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  /*
    Nombre: _tarjetaParticipacion
    Descripción:
      Muestra los datos de una participación junto con su liga y ofrece
      acceso directo a los resultados por fecha.
    Entradas:
      - item (_ParticipacionConLiga): participación y liga asociada.
    Salidas:
      - Widget
  */
  Widget _tarjetaParticipacion(_ParticipacionConLiga item) {
    final usuarioActual = _usuario;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(item.liga.nombre),
        subtitle: Text(
          "Equipo: ${item.participacion.nombreEquipoFantasy} — Puntos: ${item.participacion.puntos}",
        ),
        trailing: ElevatedButton(
          onPressed: usuarioActual == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UiUsuarioResultadosPorFechaDesktop(
                        liga: item.liga,
                        usuario: usuarioActual,
                      ),
                    ),
                  );
                },
          child: const Text("Ver resultados"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UiUsuarioAppBarDesktop(
        titulo: "FantasyPro — Inicio",
        mostrarBotonVolver: false,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                children: [
                  const Text(
                    "Bienvenido a FantasyPro",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _botonAccion(
                    "Crear equipos",
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UiUsuarioInicioListaDesktop(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Ver resultados",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_mensajeError != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _mensajeError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  else if (_participaciones.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "Aún no tienes equipos registrados. Crea uno para comenzar.",
                      ),
                    )
                  else
                    ..._participaciones.map(_tarjetaParticipacion),
                ],
              ),
            ),
    );
  }
}
