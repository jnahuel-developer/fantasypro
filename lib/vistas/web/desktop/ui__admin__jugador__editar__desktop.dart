/*
  Archivo: ui__admin__jugador__editar__desktop.dart
  Descripción:
    Edición de los datos de un jugador.
    Campos: nombre, posición, nacionalidad, dorsal.
    - Validación mínima
    - Confirmación al salir si hay cambios
    - Retorna true si hubo cambios guardados
  Dependencias:
    - modelos/jugador.dart
    - controladores/controlador_jugadores.dart
    - textos/textos_app.dart
  Pantallas que navegan hacia esta:
    - ui__admin__jugador__lista__desktop.dart
  Pantallas destino:
    - ninguna
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/controladores/controlador_jugadores.dart';
import 'package:fantasypro/textos/textos_app.dart';

class UiAdminJugadorEditarDesktop extends StatefulWidget {
  final Jugador jugador;

  const UiAdminJugadorEditarDesktop({super.key, required this.jugador});

  @override
  State<UiAdminJugadorEditarDesktop> createState() =>
      _UiAdminJugadorEditarDesktopEstado();
}

class _UiAdminJugadorEditarDesktopEstado
    extends State<UiAdminJugadorEditarDesktop> {
  /// Controlador de jugadores.
  final ControladorJugadores _controlador = ControladorJugadores();

  /// Controller para el nombre del jugador.
  late TextEditingController _ctrlNombre;

  /// Controller para la posición del jugador.
  late TextEditingController _ctrlPosicion;

  /// Controller para la nacionalidad del jugador.
  late TextEditingController _ctrlNacionalidad;

  /// Controller para el dorsal del jugador.
  late TextEditingController _ctrlDorsal;

  /// Indica si se está guardando la información.
  bool guardando = false;

  /// Indica si hay cambios sin guardar.
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

  /*
    Nombre: confirmarSalida
    Descripción:
      Muestra un diálogo de confirmación si hay cambios sin guardar
      antes de abandonar la pantalla.
    Entradas:
      - ninguna
    Salidas:
      - Future<bool>: true si se permite salir, false en caso contrario.
  */
  Future<bool> confirmarSalida() async {
    if (!hayCambios || guardando) return true;

    final salir = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(TextosApp.JUGADOR_EDITAR_DIALOGO_DESCARTAR_TITULO),
        content: const Text(TextosApp.JUGADOR_EDITAR_DIALOGO_DESCARTAR_MENSAJE),
        actions: [
          TextButton(
            child: const Text(
              TextosApp.JUGADOR_EDITAR_DIALOGO_DESCARTAR_BOTON_CANCELAR,
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text(
              TextosApp.JUGADOR_EDITAR_DIALOGO_DESCARTAR_BOTON_SALIR,
            ),
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
      Valida los campos, genera una copia actualizada del jugador y
      solicita la edición al controlador.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> guardarCambios() async {
    final nombre = _ctrlNombre.text.trim();
    final posicion = _ctrlPosicion.text.trim();
    final nacionalidad = _ctrlNacionalidad.text.trim();
    final dorsalText = _ctrlDorsal.text.trim();
    final dorsal = dorsalText.isEmpty ? 0 : int.tryParse(dorsalText) ?? 0;

    if (nombre.isEmpty || posicion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(TextosApp.JUGADOR_EDITAR_VALIDACION_OBLIGATORIOS),
        ),
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
          title: const Text(TextosApp.JUGADOR_EDITAR_TITULO),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: TextosApp.JUGADOR_EDITAR_BOTON_VOLVER,
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
                      labelText: TextosApp.JUGADOR_EDITAR_LABEL_NOMBRE,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrlPosicion,
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADOR_EDITAR_LABEL_POSICION,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrlNacionalidad,
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADOR_EDITAR_LABEL_NACIONALIDAD,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ctrlDorsal,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADOR_EDITAR_LABEL_DORSAL,
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
                    label: const Text(TextosApp.JUGADOR_EDITAR_BOTON_GUARDAR),
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
