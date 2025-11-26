/*
  Archivo: pagina_equipo_editar_desktop.dart
  Descripción:
    Pantalla dedicada a la edición de los datos de un equipo en una liga.
    Permite modificar:
      - nombre
      - descripción
      - URL del escudo

    Incluye:
      - Botón volver
      - Validación básica
      - Diálogo de confirmación al intentar salir sin guardar
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/controladores/controlador_equipos.dart';

class PaginaEquipoEditarDesktop extends StatefulWidget {
  final Equipo equipo;

  const PaginaEquipoEditarDesktop({super.key, required this.equipo});

  @override
  State<PaginaEquipoEditarDesktop> createState() =>
      _PaginaEquipoEditarDesktopEstado();
}

class _PaginaEquipoEditarDesktopEstado
    extends State<PaginaEquipoEditarDesktop> {
  final ControladorEquipos controlador = ControladorEquipos();

  late TextEditingController controladorNombre;
  late TextEditingController controladorDescripcion;
  late TextEditingController controladorEscudo;

  bool guardando = false;
  bool hayCambios = false;

  @override
  void initState() {
    super.initState();

    controladorNombre = TextEditingController(text: widget.equipo.nombre)
      ..addListener(() => setState(() => hayCambios = true));

    controladorDescripcion = TextEditingController(
      text: widget.equipo.descripcion,
    )..addListener(() => setState(() => hayCambios = true));

    controladorEscudo = TextEditingController(text: widget.equipo.escudoUrl)
      ..addListener(() => setState(() => hayCambios = true));
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

  /*
    Nombre: guardarCambios
    Descripción:
      Valida campos, genera nueva instancia y solicita edición al controlador.
  */
  Future<void> guardarCambios() async {
    final nombre = controladorNombre.text.trim();
    final descripcion = controladorDescripcion.text.trim();
    final escudo = controladorEscudo.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("El nombre del equipo no puede estar vacío."),
        ),
      );
      return;
    }

    setState(() => guardando = true);

    final actualizado = widget.equipo.copiarCon(
      nombre: nombre,
      descripcion: descripcion,
      escudoUrl: escudo,
    );

    await controlador.editar(actualizado);

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmarSalida,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Editar equipo"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: "Volver",
            onPressed: () async {
              final salir = await confirmarSalida();
              if (salir && mounted) Navigator.pop(context);
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
                    controller: controladorNombre,
                    decoration: const InputDecoration(
                      labelText: "Nombre del equipo",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controladorDescripcion,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controladorEscudo,
                    decoration: const InputDecoration(
                      labelText: "URL del escudo (opcional)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 32),
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
