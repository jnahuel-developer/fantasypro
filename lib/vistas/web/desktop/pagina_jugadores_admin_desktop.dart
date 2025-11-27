/*
  Archivo: pagina_jugadores_admin_desktop.dart
  Descripción:
    Administración de jugadores de un equipo (Web Desktop).
    - Listado Activos / Archivados
    - Crear jugador
    - Editar jugador
    - Archivar / Activar / Eliminar con confirmación
    - Conteos y ordenamiento A–Z
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/controladores/controlador_jugadores.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_jugador_editar_desktop.dart';

class PaginaJugadoresAdminDesktop extends StatefulWidget {
  final Equipo equipo;

  const PaginaJugadoresAdminDesktop({super.key, required this.equipo});

  @override
  State<PaginaJugadoresAdminDesktop> createState() =>
      _PaginaJugadoresAdminDesktopEstado();
}

class _PaginaJugadoresAdminDesktopEstado
    extends State<PaginaJugadoresAdminDesktop> {
  final ControladorJugadores _controlador = ControladorJugadores();

  bool cargando = true;
  List<Jugador> activos = [];
  List<Jugador> archivados = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => cargando = true);

    final todos = await _controlador.obtenerPorEquipo(widget.equipo.id);

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

  Future<void> crearJugador() async {
    final controladorNombre = TextEditingController();
    final controladorPosicion = TextEditingController();
    final controladorNacionalidad = TextEditingController();
    final controladorDorsal = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Crear jugador en ${widget.equipo.nombre}"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controladorNombre,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controladorPosicion,
                  decoration: const InputDecoration(labelText: "Posición"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controladorNacionalidad,
                  decoration: const InputDecoration(labelText: "Nacionalidad"),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controladorDorsal,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Dorsal (opcional)",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Crear"),
              onPressed: () async {
                final nombre = controladorNombre.text.trim();
                final posicion = controladorPosicion.text.trim();
                final nacionalidad = controladorNacionalidad.text.trim();
                final dorsalText = controladorDorsal.text.trim();
                final dorsal = dorsalText.isEmpty
                    ? 0
                    : int.tryParse(dorsalText) ?? 0;

                if (nombre.isEmpty || posicion.isEmpty) {
                  // validación mínima
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Nombre y posición son obligatorios."),
                    ),
                  );
                  return;
                }

                await _controlador.crearJugador(
                  widget.equipo.id,
                  nombre,
                  posicion,
                  nacionalidad: nacionalidad,
                  dorsal: dorsal,
                );

                Navigator.pop(context);
                cargar();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> confirmar(String mensaje) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmación"),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text("Aceptar"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  Widget itemJugador(Jugador j) {
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
        subtitle: Text("${j.posicion} • ${j.nacionalidad}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editar jugador",
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaginaJugadorEditarDesktop(jugador: j),
                  ),
                );
                if (resultado == true) cargar();
              },
            ),
            IconButton(
              icon: Icon(j.activo ? Icons.archive : Icons.unarchive),
              tooltip: j.activo ? "Archivar" : "Activar",
              onPressed: () async {
                final ok = await confirmar(
                  j.activo
                      ? "¿Desea archivar el jugador?"
                      : "¿Desea activar el jugador?",
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
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: "Eliminar jugador",
              onPressed: () async {
                final ok = await confirmar(
                  "¿Seguro que desea eliminar este jugador?",
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
        title: Text("Jugadores — ${widget.equipo.nombre}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: "Volver",
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Gestión de jugadores",
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
                        "Activos (${activos.length})",
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
                        "Archivados (${archivados.length})",
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
