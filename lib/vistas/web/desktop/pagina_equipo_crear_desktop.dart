/*
  Archivo: pagina_equipo_crear_desktop.dart
  Descripción:
    Crear equipo inicial con solo un nombre.
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_equipos.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';

import 'pagina_inicio_desktop.dart';

class PaginaEquipoCrearDesktop extends StatefulWidget {
  final Liga liga;

  const PaginaEquipoCrearDesktop({super.key, required this.liga});

  @override
  State<PaginaEquipoCrearDesktop> createState() =>
      _PaginaEquipoCrearDesktopEstado();
}

class _PaginaEquipoCrearDesktopEstado extends State<PaginaEquipoCrearDesktop> {
  final ControladorEquipos controladorEquipos = ControladorEquipos();
  final ServicioAutenticacion servicioAuth = ServicioAutenticacion();

  final TextEditingController ctrlNombre = TextEditingController();

  bool cargando = false;
  String? mensajeError;

  Future<void> crearEquipo() async {
    final nombre = ctrlNombre.text.trim();

    if (nombre.isEmpty) {
      setState(() => mensajeError = "El nombre del equipo es obligatorio.");
      return;
    }

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

      await controladorEquipos.crearEquipoInicial(
        usuario.uid, // ✔ parámetro 1 correcto
        widget.liga.id, // ✔ parámetro 2 correcto
        nombre, // ✔ parámetro 3
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PaginaInicioDesktop()),
      );
    } catch (e) {
      debugPrint("ERROR crear equipo inicial: $e");
      setState(() {
        mensajeError = "Ocurrió un error al crear el equipo.";
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Equipo Inicial")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nombre del equipo:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: ctrlNombre,
              decoration: const InputDecoration(border: OutlineInputBorder()),
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
                    onPressed: crearEquipo,
                    child: const Text("Crear equipo"),
                  ),
          ],
        ),
      ),
    );
  }
}
