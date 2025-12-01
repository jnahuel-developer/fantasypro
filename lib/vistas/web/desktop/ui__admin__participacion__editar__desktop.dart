/*
  Archivo: ui__admin__participacion__editar__desktop.dart
  Descripción:
    Pantalla para editar una participación en una liga: nombre del equipo fantasy
    y puntos. El modelo subyacente sigue siendo ParticipacionLiga.

  Dependencias:
    - modelos/participacion_liga.dart
    - controladores/controlador_participaciones.dart

  Pantallas que navegan hacia esta:
    - ui__admin__participacion__lista__desktop.dart

  Pantallas destino:
    - ninguna
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';

class UiAdminParticipacionEditarDesktop extends StatefulWidget {
  final ParticipacionLiga participacion;

  const UiAdminParticipacionEditarDesktop({
    super.key,
    required this.participacion,
  });

  @override
  State<UiAdminParticipacionEditarDesktop> createState() =>
      _UiAdminParticipacionEditarDesktopEstado();
}

class _UiAdminParticipacionEditarDesktopEstado
    extends State<UiAdminParticipacionEditarDesktop> {
  /// Controlador de participaciones.
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

  /*
    Nombre: _guardar
    Descripción:
      Valida entradas, actualiza la participación y vuelve indicando éxito.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _guardar() async {
    final nombre = ctrlNombre.text.trim();
    final puntos = int.tryParse(ctrlPuntos.text.trim()) ?? 0;

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El nombre no puede estar vacío.")),
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
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SizedBox(
                  width: 500,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        enabled: false,
                        controller: TextEditingController(
                          text: widget.participacion.idUsuario,
                        ),
                        decoration: const InputDecoration(
                          labelText: "ID Usuario",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: ctrlNombre,
                        decoration: const InputDecoration(
                          labelText: "Nombre del equipo fantasy",
                        ),
                      ),
                      const SizedBox(height: 16),
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
                            child: const Text("Cancelar"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _guardar,
                            child: const Text("Guardar"),
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
