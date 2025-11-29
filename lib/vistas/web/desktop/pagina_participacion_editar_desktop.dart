/*
  Archivo: pagina_participacion_editar_desktop.dart
  Descripción:
    Pantalla de edición de una participación de usuario dentro de una liga.
    Permite modificar:
      - nombreEquipoFantasy
      - puntos
    Campos NO editables:
      - idUsuario
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';

class PaginaParticipacionEditarDesktop extends StatefulWidget {
  final ParticipacionLiga participacion;

  const PaginaParticipacionEditarDesktop({
    super.key,
    required this.participacion,
  });

  @override
  State<PaginaParticipacionEditarDesktop> createState() =>
      _PaginaParticipacionEditarDesktopEstado();
}

class _PaginaParticipacionEditarDesktopEstado
    extends State<PaginaParticipacionEditarDesktop> {
  final ControladorParticipaciones _controlador = ControladorParticipaciones();

  late TextEditingController ctrlNombre;
  late TextEditingController ctrlPuntos;

  bool cargando = false;

  @override
  void initState() {
    super.initState();

    ctrlNombre = TextEditingController(
      text: widget.participacion.nombreEquipoFantasy,
    );

    ctrlPuntos = TextEditingController(
      text: widget.participacion.puntos.toString(),
    );
  }

  Future<void> guardar() async {
    final nombre = ctrlNombre.text.trim();
    final puntos = int.tryParse(ctrlPuntos.text.trim()) ?? 0;

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El nombre del equipo no puede estar vacío."),
        ),
      );
      return;
    }

    if (puntos < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Los puntos no pueden ser negativos.")),
      );
      return;
    }

    setState(() => cargando = true);

    final actualizado = widget.participacion.copiarCon(
      nombreEquipoFantasy: nombre,
      puntos: puntos,
    );

    await _controlador.editar(actualizado);

    setState(() => cargando = false);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar participación"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ID Usuario (NO editable)
                      TextField(
                        enabled: false,
                        controller: TextEditingController(
                          text: widget.participacion.idUsuario,
                        ),
                        decoration: const InputDecoration(
                          labelText: "ID Usuario (no editable)",
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nombre equipo fantasy
                      TextField(
                        controller: ctrlNombre,
                        decoration: const InputDecoration(
                          labelText: "Nombre del equipo fantasy",
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Puntos
                      TextField(
                        controller: ctrlPuntos,
                        decoration: const InputDecoration(labelText: "Puntos"),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancelar"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: guardar,
                            child: const Text("Guardar cambios"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
