/*
  Archivo: ui__admin__jugador__editar__desktop.dart
  Descripción:
    Edición de los datos de un jugador real.
    Campos: nombre, posición, nacionalidad, dorsal, valor de mercado.
    - Validación mínima
    - Confirmación al salir si hay cambios
    - Retorna true si hubo cambios guardados
  Dependencias:
    - modelos/jugador_real.dart
    - controladores/controlador_jugadores_reales.dart
    - textos/textos_app.dart
  Pantallas que navegan hacia esta:
    - ui__admin__jugador__lista__desktop.dart
  Pantallas destino:
    - ninguna
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';
import 'package:fantasypro/textos/textos_app.dart';

class UiAdminJugadorEditarDesktop extends StatefulWidget {
  /// Jugador real que se está editando.
  final JugadorReal jugadorReal;

  const UiAdminJugadorEditarDesktop({super.key, required this.jugadorReal});

  @override
  State<UiAdminJugadorEditarDesktop> createState() =>
      _UiAdminJugadorEditarDesktopEstado();
}

class _UiAdminJugadorEditarDesktopEstado
    extends State<UiAdminJugadorEditarDesktop> {
  /// Controlador de jugadores reales.
  final ControladorJugadoresReales _controlador = ControladorJugadoresReales();

  /// Controller para el nombre del jugador real.
  late TextEditingController _ctrlNombre;

  /// Valor de la posición seleccionada.
  late String _posicionSeleccionada;

  /// Controller para la nacionalidad.
  late TextEditingController _ctrlNacionalidad;

  /// Controller para el dorsal.
  late TextEditingController _ctrlDorsal;

  /// Controller para el valor de mercado.
  late TextEditingController _ctrlValorMercado;

  /// Indica si se está guardando la información.
  bool guardando = false;

  /// Indica si hay cambios sin guardar.
  bool hayCambios = false;

  @override
  void initState() {
    super.initState();

    _ctrlNombre = TextEditingController(text: widget.jugadorReal.nombre)
      ..addListener(() => setState(() => hayCambios = true));

    _posicionSeleccionada = widget.jugadorReal.posicion;

    _ctrlNacionalidad = TextEditingController(
      text: widget.jugadorReal.nacionalidad,
    )..addListener(() => setState(() => hayCambios = true));

    _ctrlDorsal = TextEditingController(
      text: widget.jugadorReal.dorsal > 0
          ? widget.jugadorReal.dorsal.toString()
          : "",
    )..addListener(() => setState(() => hayCambios = true));

    _ctrlValorMercado = TextEditingController(
      text: widget.jugadorReal.valorMercado.toString(),
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
      - Future<bool>
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
      Valida todos los campos, construye una copia del jugador real y
      solicita su actualización al controlador.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> guardarCambios() async {
    final nombre = _ctrlNombre.text.trim();
    final nacionalidad = _ctrlNacionalidad.text.trim();

    final dorsalText = _ctrlDorsal.text.trim();
    final dorsal = dorsalText.isEmpty ? 0 : int.tryParse(dorsalText) ?? 0;

    final valorText = _ctrlValorMercado.text.trim();
    final valor = int.tryParse(valorText) ?? 0;

    if (nombre.isEmpty ||
        _posicionSeleccionada.isEmpty ||
        valor < 1 ||
        valor > 1000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(TextosApp.JUGADOR_EDITAR_VALIDACION_CAMPOS),
        ),
      );
      return;
    }

    setState(() => guardando = true);

    final actualizado = widget.jugadorReal.copiarCon(
      nombre: nombre,
      posicion: _posicionSeleccionada,
      nacionalidad: nacionalidad,
      dorsal: dorsal,
      valorMercado: valor,
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

                  /// Campo de posición (Dropdown).
                  DropdownButtonFormField<String>(
                    initialValue: _posicionSeleccionada,
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADOR_EDITAR_LABEL_POSICION,
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: TextosApp.JUGADOR_EDITAR_OPCION_POSICION_POR,
                        child:
                            Text(TextosApp.JUGADOR_EDITAR_OPCION_POSICION_POR),
                      ),
                      DropdownMenuItem(
                        value: TextosApp.JUGADOR_EDITAR_OPCION_POSICION_DEF,
                        child:
                            Text(TextosApp.JUGADOR_EDITAR_OPCION_POSICION_DEF),
                      ),
                      DropdownMenuItem(
                        value: TextosApp.JUGADOR_EDITAR_OPCION_POSICION_MED,
                        child:
                            Text(TextosApp.JUGADOR_EDITAR_OPCION_POSICION_MED),
                      ),
                      DropdownMenuItem(
                        value: TextosApp.JUGADOR_EDITAR_OPCION_POSICION_DEL,
                        child:
                            Text(TextosApp.JUGADOR_EDITAR_OPCION_POSICION_DEL),
                      ),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() {
                        _posicionSeleccionada = v;
                        hayCambios = true;
                      });
                    },
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADOR_EDITAR_LABEL_DORSAL,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Campo valor de mercado con validación por rango.
                  TextFormField(
                    controller: _ctrlValorMercado,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADOR_EDITAR_LABEL_VALOR_MERCADO,
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
