/*
  Archivo: ui__admin__jugador__lista__desktop.dart
  Descripción:
    Lista y administración de jugadores de un equipo real.
    Permite crear, editar, archivar, activar y eliminar jugadores.
  Dependencias:
    - modelos/jugador_real.dart
    - modelos/equipo_real.dart
    - controladores/controlador_jugadores_reales.dart
    - ui__admin__jugador__editar__desktop.dart
  Pantallas que navegan hacia esta:
    - ui__admin__equipo_real__lista__desktop.dart
  Pantallas destino:
    - ui__admin__jugador__editar__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fantasypro/modelos/jugador_real.dart';
import 'package:fantasypro/modelos/equipo_real.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';
import 'package:fantasypro/textos/textos_app.dart';

import 'ui__admin__jugador__editar__desktop.dart';

class UiAdminJugadorListaDesktop extends StatefulWidget {
  final EquipoReal equipo;

  const UiAdminJugadorListaDesktop({super.key, required this.equipo});

  @override
  State<UiAdminJugadorListaDesktop> createState() =>
      _UiAdminJugadorListaDesktopEstado();
}

class _UiAdminJugadorListaDesktopEstado
    extends State<UiAdminJugadorListaDesktop> {
  /// Controlador de jugadores reales.
  final ControladorJugadoresReales _controlador = ControladorJugadoresReales();

  bool cargando = true;
  List<JugadorReal> activos = [];
  List<JugadorReal> archivados = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  /*
    Nombre: cargar
    Descripción:
      Recupera jugadores reales por equipo y separa activos/archivados.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> cargar() async {
    setState(() => cargando = true);

    final todos = await _controlador.obtenerPorEquipoReal(widget.equipo.id);

    activos = todos.where((j) => j.activo).toList()
      ..sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );

    archivados = todos.where((j) => !j.activo).toList()
      ..sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );

    setState(() => cargando = false);
  }

  /*
    Nombre: crearJugador
    Descripción:
      Crea un jugador real dentro del equipo real.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> crearJugador() async {
    final ctrlNombre = TextEditingController();
    final ctrlNacionalidad = TextEditingController();
    final ctrlDorsal = TextEditingController();
    final ctrlValor = TextEditingController();

    String posicionSeleccionada = TextosApp.JUGADOR_EDITAR_OPCION_POSICION_POR;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(
              TextosApp.JUGADORES_ADMIN_CREAR_TITULO
                  .replaceFirst("{EQUIPO}", widget.equipo.nombre),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: ctrlNombre,
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADORES_ADMIN_CREAR_LABEL_NOMBRE,
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: posicionSeleccionada,
                    decoration: const InputDecoration(
                      labelText: TextosApp.JUGADORES_ADMIN_CREAR_LABEL_POSICION,
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
                      if (v != null) {
                        setStateDialog(() => posicionSeleccionada = v);
                      }
                    },
                  ),
                  TextField(
                    controller: ctrlNacionalidad,
                    decoration: const InputDecoration(
                      labelText:
                          TextosApp.JUGADORES_ADMIN_CREAR_LABEL_NACIONALIDAD,
                    ),
                  ),
                  TextField(
                    controller: ctrlDorsal,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText:
                          TextosApp.JUGADORES_ADMIN_CREAR_LABEL_DORSAL,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  TextField(
                    controller: ctrlValor,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText:
                          TextosApp.JUGADORES_ADMIN_CREAR_LABEL_VALOR_MERCADO,
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text(TextosApp.COMUN_BOTON_CREAR),
                onPressed: () async {
                  final nombre = ctrlNombre.text.trim();
                  final nacionalidad = ctrlNacionalidad.text.trim();
                  final dorsal = int.tryParse(ctrlDorsal.text.trim()) ?? 0;
                  final valor = int.tryParse(ctrlValor.text.trim()) ?? 0;

                  if (nombre.isEmpty || valor < 1 || valor > 1000) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(TextosApp
                            .JUGADORES_ADMIN_VALIDACION_CAMPOS_OBLIGATORIOS_GENERICO),
                      ),
                    );
                    return;
                  }

                  await _controlador.crearJugadorReal(
                    widget.equipo.id,
                    nombre,
                    posicionSeleccionada,
                    nacionalidad: nacionalidad,
                    dorsal: dorsal,
                    valorMercado: valor,
                  );

                  Navigator.pop(context);
                  cargar();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  /*
    Nombre: confirmar
    Descripción:
      Solicita confirmación al usuario mediante un diálogo.
    Entradas: mensaje
    Salidas: Future<bool>
  */
  Future<bool> confirmar(String mensaje) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(TextosApp.JUGADORES_ADMIN_CONFIRMAR_TITULO),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: const Text(TextosApp.JUGADORES_ADMIN_CONFIRMAR_CANCELAR),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text(TextosApp.JUGADORES_ADMIN_CONFIRMAR_ACEPTAR),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    return r ?? false;
  }

  /*
    Nombre: itemJugador
    Descripción:
      Renderiza un jugador dentro del listado.
    Entradas: JugadorReal j
    Salidas: Widget
  */
  Widget itemJugador(JugadorReal j) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            j.dorsal > 0
                ? j.dorsal.toString()
                : j.nombre.isNotEmpty
                ? j.nombre[0].toUpperCase()
                : '?',
          ),
        ),
        title: Text(
          j.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          TextosApp.JUGADORES_ADMIN_SUBTITULO_ITEM
              .replaceFirst("{POSICION}", j.posicion)
              .replaceFirst("{NACIONALIDAD}", j.nacionalidad)
              .replaceFirst("{VALOR}", j.valorMercado.toString()),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Editar
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminJugadorEditarDesktop(jugadorReal: j),
                  ),
                );
                if (res == true) cargar();
              },
            ),

            // Archivar / activar
            IconButton(
              icon: Icon(j.activo ? Icons.archive : Icons.unarchive),
              onPressed: () async {
                final ok = await confirmar(
                  j.activo
                      ? TextosApp.JUGADORES_ADMIN_CONFIRMAR_ARCHIVAR
                      : TextosApp.JUGADORES_ADMIN_CONFIRMAR_ACTIVAR,
                );
                if (!ok) return;

                if (j.activo) {
                  await _controlador.archivar(j.id);
                } else {
                  await _controlador.activar(j.id);
                }

                cargar();
              },
            ),

            // Eliminar
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final ok = await confirmar(
                  TextosApp.JUGADORES_ADMIN_CONFIRMAR_ELIMINAR,
                );
                if (!ok) return;

                await _controlador.eliminar(j.id);
                cargar();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextosApp.JUGADORES_ADMIN_APPBAR_TITULO.replaceAll(
            "{EQUIPO}",
            widget.equipo.nombre,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: TextosApp.JUGADORES_ADMIN_APPBAR_VOLVER,
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                TextosApp.JUGADORES_ADMIN_APPBAR_GESTION_TEXTO,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crearJugador,
        child: const Icon(Icons.add),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.JUGADORES_ADMIN_COLUMNA_ACTIVOS.replaceAll(
                          "{CANT}",
                          activos.length.toString(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: activos.map(itemJugador).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.JUGADORES_ADMIN_COLUMNA_ARCHIVADOS.replaceAll(
                          "{CANT}",
                          archivados.length.toString(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivados.map(itemJugador).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
