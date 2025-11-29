/*
  Archivo: pagina_alineacion_editar_desktop.dart
  Descripción:
    Edición de una alineación seleccionada por un usuario dentro de una liga.
    - Editar formación (4-4-2 / 4-3-3)
    - Editar jugadores seleccionados (IDs separados por coma)
    - Editar puntos totales
    - Confirmación al salir si hay cambios
    - Retorna true si se guardaron cambios
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart';

class PaginaAlineacionEditarDesktop extends StatefulWidget {
  final Alineacion alineacion;

  const PaginaAlineacionEditarDesktop({super.key, required this.alineacion});

  @override
  State<PaginaAlineacionEditarDesktop> createState() =>
      _PaginaAlineacionEditarDesktopEstado();
}

class _PaginaAlineacionEditarDesktopEstado
    extends State<PaginaAlineacionEditarDesktop> {
  final ControladorAlineaciones _controlador = ControladorAlineaciones();

  late TextEditingController _ctrlJugadores;
  late TextEditingController _ctrlPuntos;

  String formacion = "4-4-2";

  bool guardando = false;
  bool hayCambios = false;

  @override
  void initState() {
    super.initState();

    formacion = widget.alineacion.formacion;

    _ctrlJugadores = TextEditingController(
      text: widget.alineacion.jugadoresSeleccionados.join(","),
    )..addListener(() => setState(() => hayCambios = true));

    _ctrlPuntos = TextEditingController(
      text: widget.alineacion.puntosTotales.toString(),
    )..addListener(() => setState(() => hayCambios = true));
  }

  // -----------------------------------------------------
  // Confirmación al salir sin guardar
  // -----------------------------------------------------
  Future<bool> confirmarSalida() async {
    if (!hayCambios || guardando) return true;

    final salir = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Descartar cambios"),
        content: const Text(
          "Hay cambios sin guardar. ¿Desea salir igualmente?",
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("Salir"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    return salir ?? false;
  }

  // -----------------------------------------------------
  // Guardar cambios
  // -----------------------------------------------------
  Future<void> guardarCambios() async {
    final jugadoresText = _ctrlJugadores.text.trim();
    final puntosText = _ctrlPuntos.text.trim();

    if (jugadoresText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debe incluir al menos un jugador.")),
      );
      return;
    }

    final jugadores = jugadoresText
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (jugadores.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Formato inválido de jugadores.")),
      );
      return;
    }

    final puntos = int.tryParse(puntosText) ?? 0;
    if (puntos < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Los puntos no pueden ser negativos.")),
      );
      return;
    }

    setState(() => guardando = true);

    final actualizado = widget.alineacion.copiarCon(
      jugadoresSeleccionados: jugadores,
      formacion: formacion,
      puntosTotales: puntos,
    );

    await _controlador.editar(actualizado);

    if (mounted) Navigator.pop(context, true);
  }

  // -----------------------------------------------------
  // Build
  // -----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmarSalida,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Editar alineación"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: "Volver",
            onPressed: () async {
              final ok = await confirmarSalida();
              if (ok && mounted) Navigator.pop(context);
            },
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SizedBox(
              width: 560,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // FORMACION
                  Row(
                    children: [
                      const Text(
                        "Formación:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: formacion,
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
                          if (v == null) return;
                          setState(() {
                            formacion = v;
                            hayCambios = true;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // JUGADORES
                  TextField(
                    controller: _ctrlJugadores,
                    decoration: const InputDecoration(
                      labelText: "IDs de jugadores (separados por coma)",
                      hintText: "ej: j1,j2,j3,j4",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // PUNTOS
                  TextField(
                    controller: _ctrlPuntos,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Puntos totales",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // BOTÓN GUARDAR
                  ElevatedButton.icon(
                    onPressed: guardando ? null : guardarCambios,
                    icon: guardando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text("Guardar cambios"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
