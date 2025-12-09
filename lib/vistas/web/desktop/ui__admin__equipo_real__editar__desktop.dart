/*
  Archivo: ui__admin__equipo_real__editar__desktop.dart
  Descripción:
    Edición de datos de un equipo real.

  Dependencias:
    - modelos/equipo_real.dart
    - controladores/controlador_equipos_reales.dart

  Pantallas origen:
    - ui__admin__equipo_real__lista__desktop.dart
*/

import 'package:fantasypro/controladores/controlador_equipos_reales.dart';
import 'package:fantasypro/modelos/equipo_real.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:flutter/material.dart';

class UiAdminEquipoRealEditarDesktop extends StatefulWidget {
  final EquipoReal equipo;

  const UiAdminEquipoRealEditarDesktop({super.key, required this.equipo});

  @override
  State<UiAdminEquipoRealEditarDesktop> createState() =>
      _UiAdminEquipoRealEditarDesktopEstado();
}

class _UiAdminEquipoRealEditarDesktopEstado
    extends State<UiAdminEquipoRealEditarDesktop> {
  /// Controlador de equipos reales.
  final ControladorEquiposReales _controlador = ControladorEquiposReales();

  late TextEditingController ctrlNombre;
  late TextEditingController ctrlDescripcion;

  bool cargando = false;

  @override
  void initState() {
    super.initState();
    ctrlNombre = TextEditingController(text: widget.equipo.nombre);
    ctrlDescripcion = TextEditingController(text: widget.equipo.descripcion);
  }

  /*
    Nombre: _guardar
    Descripción:
      Guarda los cambios editados y actualiza los datos en Firestore.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _guardar() async {
    final nombre = ctrlNombre.text.trim();
    final desc = ctrlDescripcion.text.trim();

    if (nombre.isEmpty) return;

    setState(() => cargando = true);

    final actualizado = widget.equipo.copiarCon(
      nombre: nombre,
      descripcion: desc,
    );

    await _controlador.editarEquipoReal(actualizado);

    setState(() => cargando = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(TextosApp.ADMIN_EQUIPO_REAL_EDITAR_DESKTOP_TITULO),
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
                        controller: ctrlNombre,
                        decoration: const InputDecoration(
                          labelText:
                              TextosApp.ADMIN_EQUIPO_REAL_EDITAR_DESKTOP_LABEL_NOMBRE,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextField(
                        controller: ctrlDescripcion,
                        decoration: const InputDecoration(
                          labelText: TextosApp
                              .ADMIN_EQUIPO_REAL_EDITAR_DESKTOP_LABEL_DESCRIPCION,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _guardar,
                            child: const Text(TextosApp.COMUN_BOTON_GUARDAR),
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
