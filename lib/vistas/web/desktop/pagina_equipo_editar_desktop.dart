/*
  Archivo: pagina_equipo_editar_desktop.dart
  Descripción:
    Pantalla dedicada a la edición de los datos de un equipo en una liga.
    Permite modificar los campos:
      - nombre
      - descripción
      - URL del escudo
    Una vez guardados los cambios, la pantalla retorna a la vista anterior.
  Dependencias:
    - modelos/equipo.dart
    - controladores/controlador_equipos.dart
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

  @override
  void initState() {
    super.initState();

    controladorNombre = TextEditingController(text: widget.equipo.nombre);
    controladorDescripcion = TextEditingController(
      text: widget.equipo.descripcion,
    );
    controladorEscudo = TextEditingController(text: widget.equipo.escudoUrl);
  }

  /*
    Nombre: guardarCambios
    Descripción:
      Valida los campos y envía los cambios al controlador de equipos.
      Al finalizar, retorna a la pantalla anterior.
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
      Navigator.pop(context, true); // Retorna indicando éxito
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar equipo")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controladorNombre,
                  decoration: const InputDecoration(
                    labelText: "Nombre del equipo",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controladorDescripcion,
                  decoration: const InputDecoration(labelText: "Descripción"),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controladorEscudo,
                  decoration: const InputDecoration(
                    labelText: "URL del escudo (opcional)",
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
    );
  }
}
