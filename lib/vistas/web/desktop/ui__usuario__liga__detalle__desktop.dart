/*
  Archivo: ui__usuario__liga__detalle__desktop.dart
  Descripción:
    Pantalla de detalle de una liga para el usuario final.
    Permite unirse a la liga si aún no participa.
  Dependencias:
    - modelos/liga.dart
    - servicios/servicio_autenticacion.dart
    - servicios/servicio_participaciones.dart
    - controladores/controlador_participaciones.dart
  Pantallas que navegan hacia esta:
    - ui__usuario__inicio__lista__desktop.dart
  Pantallas destino:
    - ui__usuario__equipo_fantasy__crear__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';

import 'ui__usuario__equipo_fantasy__crear__desktop.dart';

class UiUsuarioLigaDetalleDesktop extends StatefulWidget {
  final Liga liga;

  const UiUsuarioLigaDetalleDesktop({super.key, required this.liga});

  @override
  State<UiUsuarioLigaDetalleDesktop> createState() =>
      _UiUsuarioLigaDetalleDesktopEstado();
}

class _UiUsuarioLigaDetalleDesktopEstado
    extends State<UiUsuarioLigaDetalleDesktop> {
  /// Controlador de participaciones.
  final ControladorParticipaciones controladorParticipaciones =
      ControladorParticipaciones();

  final ServicioAutenticacion servicioAuth = ServicioAutenticacion();
  final ServicioParticipaciones servicioParticipaciones =
      ServicioParticipaciones();

  bool cargando = false;
  String? mensajeError;

  /*
    Nombre: unirse
    Descripción:
      Valida si el usuario ya participa y crea la participación en caso afirmativo.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> unirse() async {
    setState(() {
      cargando = true;
      mensajeError = null;
    });

    try {
      final usuario = servicioAuth.obtenerUsuarioActual();
      if (usuario == null) {
        setState(() {
          mensajeError = "No hay usuario autenticado.";
          cargando = false;
        });
        return;
      }

      final idUsuario = usuario.uid;

      final ya = await servicioParticipaciones.usuarioYaParticipa(
        idUsuario,
        widget.liga.id,
      );

      if (ya) {
        setState(() {
          mensajeError = "Ya participás en esta liga.";
          cargando = false;
        });
        return;
      }

      await controladorParticipaciones.crearParticipacionSiNoExiste(
        widget.liga.id,
        idUsuario,
        "Mi Equipo",
      );

      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UiUsuarioEquipoFantasyCrearDesktop(liga: widget.liga),
        ),
      );
    } catch (e) {
      setState(() {
        mensajeError = "Error al unirse.";
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liga: ${widget.liga.nombre}")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Temporada: ${widget.liga.temporada}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (mensajeError != null)
              Text(mensajeError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: unirse,
                    child: const Text("Unirme a esta liga"),
                  ),
          ],
        ),
      ),
    );
  }
}
