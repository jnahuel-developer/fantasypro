/*
  Archivo: ui__admin__equipo_real__lista__desktop.dart
  Descripción:
    Pantalla de administración para listar, crear, archivar, activar y eliminar
    equipos reales de una liga (ADMIN)

  Dependencias:
    - modelos/equipo_real.dart
    - controladores/controlador_equipos_reales.dart
    - modelos/liga.dart

  Pantallas que navegan hacia esta:
    - ui__admin__liga__lista__desktop.dart

  Pantallas destino:
    - ui__admin__equipo_real__editar__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/equipo_real.dart';
import 'package:fantasypro/controladores/controlador_equipos_reales.dart';

import 'ui__admin__equipo_real__editar__desktop.dart';
import 'ui__admin__jugador__lista__desktop.dart';

class UiAdminEquipoRealListaDesktop extends StatefulWidget {
  final Liga liga;

  const UiAdminEquipoRealListaDesktop({super.key, required this.liga});

  @override
  State<UiAdminEquipoRealListaDesktop> createState() =>
      _UiAdminEquipoRealListaDesktopEstado();
}

class _UiAdminEquipoRealListaDesktopEstado
    extends State<UiAdminEquipoRealListaDesktop> {
  /// Controlador de equipos reales.
  final ControladorEquiposReales _controlador = ControladorEquiposReales();

  bool cargando = true;
  List<EquipoReal> activos = [];
  List<EquipoReal> archivados = [];

  /*
    Nombre: _cargar
    Descripción:
      Carga equipos reales según su estado y los organiza en listas separadas.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _cargar() async {
    setState(() => cargando = true);

    final lista = await _controlador.obtenerPorLiga(widget.liga.id);

    activos = lista.where((e) => e.activo).toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    archivados = lista.where((e) => !e.activo).toList()
      ..sort((a, b) => a.nombre.compareTo(b.nombre));

    setState(() => cargando = false);
  }

  /*
    Nombre: _crearEquipo
    Descripción:
      Muestra diálogo para crear un equipo real dentro de una liga.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _crearEquipo() async {
    final ctrlNombre = TextEditingController();
    final ctrlDescripcion = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Crear equipo real"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrlNombre,
              decoration: const InputDecoration(labelText: "Nombre"),
            ),
            TextField(
              controller: ctrlDescripcion,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Crear"),
            onPressed: () async {
              final nombre = ctrlNombre.text.trim();
              final desc = ctrlDescripcion.text.trim();
              if (nombre.isEmpty) return;

              await _controlador.crearEquipoReal(widget.liga.id, nombre, desc);

              Navigator.pop(context);
              _cargar();
            },
          ),
        ],
      ),
    );
  }

  Widget _item(EquipoReal e) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      child: ListTile(
        title: Text(
          e.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(e.descripcion),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.people),
              tooltip: "Gestionar jugadores",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminJugadorListaDesktop(equipo: e),
                  ),
                );
              },
            ),

            // Editar
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminEquipoRealEditarDesktop(equipo: e),
                  ),
                );
                _cargar();
              },
            ),

            // Archivar / Activar
            IconButton(
              icon: Icon(e.activo ? Icons.archive : Icons.unarchive),
              onPressed: () async {
                if (e.activo) {
                  await _controlador.archivarEquipoReal(e.id);
                } else {
                  await _controlador.activarEquipoReal(e.id);
                }
                _cargar();
              },
            ),

            // Eliminar
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _controlador.eliminarEquipoReal(e.id);
                _cargar();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipos reales — ${widget.liga.nombre}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _crearEquipo,
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
                        "Activos (${activos.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(children: activos.map(_item).toList()),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Archivados (${archivados.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivados.map(_item).toList(),
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
