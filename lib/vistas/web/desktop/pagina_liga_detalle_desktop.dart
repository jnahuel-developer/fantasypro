/*
  Archivo: pagina_liga_detalle_desktop.dart
  Descripción:
    Detalle mínimo de liga + opción de unirse.
    Flujo aprobado por PM:
      1) Obtener usuario actual
      2) usuarioYaParticipa(idUsuario, idLiga)
      3) Si participa → error
      4) Si no → crearParticipacionSiNoExiste
      5) Navegar a creación de equipo
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';

import 'pagina_equipo_crear_desktop.dart';

class PaginaLigaDetalleDesktop extends StatefulWidget {
  final Liga liga;

  const PaginaLigaDetalleDesktop({super.key, required this.liga});

  @override
  State<PaginaLigaDetalleDesktop> createState() =>
      _PaginaLigaDetalleDesktopEstado();
}

class _PaginaLigaDetalleDesktopEstado extends State<PaginaLigaDetalleDesktop> {
  final ControladorParticipaciones controladorParticipaciones =
      ControladorParticipaciones();

  final ServicioAutenticacion servicioAuth = ServicioAutenticacion();
  final ServicioParticipaciones servicioParticipaciones =
      ServicioParticipaciones();

  bool cargando = false;
  String? mensajeError;

  Future<void> unirse() async {
    setState(() {
      cargando = true;
      mensajeError = null;
    });

    try {
      // 1) Usuario actual
      final usuario = servicioAuth.obtenerUsuarioActual();
      if (usuario == null) {
        setState(() {
          mensajeError = "No hay usuario autenticado.";
          cargando = false;
        });
        return;
      }

      final idUsuario = usuario.uid;

      // 2) Verificar si ya participa
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

      // 3) Crear participación
      final participacion = await controladorParticipaciones
          .crearParticipacionSiNoExiste(
            widget.liga.id,
            idUsuario,
            "Mi Equipo", // nombre temporal inicial (Etapa 1)
          );

      // 4) Navegar a crear equipo
      // Cerrar esta pantalla ANTES de ir a crear el equipo
      Navigator.pop(context);

      // Ir a la pantalla de creación de equipo
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaginaEquipoCrearDesktop(liga: widget.liga),
        ),
      );
    } catch (e) {
      debugPrint("ERROR unirse a liga: $e");
      setState(() {
        mensajeError = "Error desconocido al unirse.";
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  mensajeError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),

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
