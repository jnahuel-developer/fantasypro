/*
  Archivo: ui__admin__alineacion__editar__desktop.dart
  Descripción:
    Edición de una alineación seleccionada por un usuario dentro de una liga.
    - Editar formación (4-4-2 / 4-3-3)
    - Editar jugadores seleccionados (IDs separados por coma)
    - Editar puntos totales
    - Confirmación al salir si hay cambios
    - Retorna true si se guardaron cambios

  Dependencias:
    - modelos/alineacion.dart
    - controladores/controlador_alineaciones.dart

  Pantallas que navegan hacia esta:
    - ui__admin__alineacion__lista__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/textos/textos_app.dart';

class UiAdminAlineacionEditarDesktop extends StatefulWidget {
  /// Alineación a editar.
  final Alineacion alineacion;

  const UiAdminAlineacionEditarDesktop({super.key, required this.alineacion});

  @override
  State<UiAdminAlineacionEditarDesktop> createState() =>
      _UiAdminAlineacionEditarDesktopEstado();
}

class _UiAdminAlineacionEditarDesktopEstado
    extends State<UiAdminAlineacionEditarDesktop> {
  /// Controlador de alineaciones.
  final ControladorAlineaciones _controlador = ControladorAlineaciones();

  /// Controlador de texto para IDs de jugadores.
  late TextEditingController _ctrlJugadores;

  /// Controlador de texto para puntos.
  late TextEditingController _ctrlPuntos;

  /// Formación seleccionada.
  String formacion =
      TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_OPCION_FORMACION_442;

  /// Indica si se está guardando.
  bool guardando = false;

  /// Indica si hay cambios sin guardar.
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

  /*
    Nombre: confirmarSalida
    Descripción:
      Muestra un diálogo de confirmación si hay cambios sin guardar
      antes de cerrar la pantalla.
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
        title: Text(
          TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_DIALOGO_DESCARTAR_TITULO,
        ),
        content: Text(
          TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_DIALOGO_DESCARTAR_CONTENIDO,
        ),
        actions: [
          TextButton(
            child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text(TextosApp.COMUN_BOTON_SALIR),
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
      Valida los datos cargados, crea una copia actualizada de la alineación
      e invoca al controlador para persistirla.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> guardarCambios() async {
    final jugadoresText = _ctrlJugadores.text.trim();
    final puntosText = _ctrlPuntos.text.trim();

    if (jugadoresText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text(TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_MENSAJE_SIN_JUGADORES),
        ),
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
        const SnackBar(
          content: Text(
            TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_MENSAJE_FORMATO_INVALIDO,
          ),
        ),
      );
      return;
    }

    final puntos = int.tryParse(puntosText) ?? 0;
    if (puntos < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_MENSAJE_PUNTOS_NEGATIVOS,
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmarSalida,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_TITULO),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_TOOLTIP_VOLVER,
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
                  // Formación
                  Row(
                    children: [
                      const Text(
                        TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_LABEL_FORMACION,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: formacion,
                        items: const [
                          DropdownMenuItem(
                            value: TextosApp
                                .ADMIN_ALINEACION_EDITAR_DESKTOP_OPCION_FORMACION_442,
                            child: Text(
                              TextosApp
                                  .ADMIN_ALINEACION_EDITAR_DESKTOP_OPCION_FORMACION_442,
                            ),
                          ),
                          DropdownMenuItem(
                            value: TextosApp
                                .ADMIN_ALINEACION_EDITAR_DESKTOP_OPCION_FORMACION_433,
                            child: Text(
                              TextosApp
                                  .ADMIN_ALINEACION_EDITAR_DESKTOP_OPCION_FORMACION_433,
                            ),
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

                  // Jugadores
                  TextField(
                    controller: _ctrlJugadores,
                    decoration: const InputDecoration(
                      labelText: TextosApp
                          .ADMIN_ALINEACION_EDITAR_DESKTOP_LABEL_IDS_JUGADORES,
                      hintText:
                          TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_HINT_IDS_JUGADORES,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Puntos
                  TextField(
                    controller: _ctrlPuntos,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText:
                          TextosApp.ADMIN_ALINEACION_EDITAR_DESKTOP_LABEL_PUNTOS_TOTALES,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botón guardar
                  ElevatedButton.icon(
                    onPressed: guardando ? null : guardarCambios,
                    icon: guardando
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: const Text(TextosApp.COMUN_BOTON_GUARDAR_CAMBIOS),
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
