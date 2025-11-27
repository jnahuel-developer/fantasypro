/*
  Archivo: pagina_jugador_editar_desktop.dart
  Descripción:
    Edición de los datos de un jugador.
    Campos: nombre, posición, nacionalidad, dorsal.
    - Validación mínima
    - Confirmación al salir si hay cambios
    - Retorna true si hubo cambios guardados
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/controladores/controlador_jugadores.dart';

class PaginaJugadorEditarDesktop extends StatefulWidget {
  final Jugador jugador;

  const PaginaJugadorEditarDesktop({super.key, required this.jugador});

  @override
  State<PaginaJugadorEditarDesktop> createState() =>
      _PaginaJugadorEditarDesktopEstado();
}

class _PaginaJugadorEditarDesktopEstado
    extends State<PaginaJugadorEditarDesktop> {
  final ControladorJugadores _controlador = ControladorJugadores();

  late TextEditingController _ctrlNombre;
  late TextEditingController _ctrlPosicion;
  late TextEditingController _ctrlNacionalidad;
  late TextEditingController _ctrlDorsal;

  bool guardando = false;
  bool hayCambios = false;

  @override
  void initState() {
    super.initState();
    _ctrlNombre = TextEditingController(text: widget.jugador.nombre)
      ..addListener(() => setState(() => hayCambios = true));
    _ctrlPosicion = TextEditingController(text: widget.jugador.posicion)
      ..addListener(() => setState(() => hayCambios = true));
    _ctrlNacionalidad = TextEditingController(text: widget.jugador.nacionalidad)
      ..addListener(() => setState(() => hayCambios = true));
    _ctrlDorsal = TextEditingController(
      text: widget.jugador.dorsal > 0 ? widget.jugador.dorsal.toString() : "",
    )..addListener(() => setState(() => hayCambios = true));
  }

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

  Future<void> guardarCambios() async {
    final nombre = _ctrlNombre.text.trim();
    final posicion = _ctrlPosicion.text.trim();
    final nacionalidad = _ctrlNacionalidad.text.trim();
    final dorsalText = _ctrlDorsal.text.trim();
    final dorsal = dorsalText.isEmpty ? 0 : int.tryParse(dorsalText) ?? 0;

    if (nombre.isEmpty || posicion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nombre y posición son obligatorios.")),
      );
      return;
    }

    setState(() => guardando = true);

    final actualizado = widget.jugador.copiarCon(
      nombre: nombre,
      posicion: posicion,
      nacionalidad: nacionalidad,
      dorsal: dorsal,
    );

    await _controlador.editar(actualizado);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmarSalida,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Editar jugador"),
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
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _ctrlNombre,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrlPosicion,
                    decoration: const InputDecoration(
                      labelText: "Posición",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrlNacionalidad,
                    decoration: const InputDecoration(
                      labelText: "Nacionalidad",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrlDorsal,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Dorsal (opcional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
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
