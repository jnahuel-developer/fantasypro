/*
  Archivo: pagina_jugadores_admin_desktop.dart
  Descripción:
    Administración de jugadores de un equipo (Web Desktop).
    - Listado Activos / Archivados
    - Crear jugador
    - Editar jugador
    - Archivar / Activar / Eliminar con confirmación
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/jugador.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/controladores/controlador_jugadores.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_jugador_editar_desktop.dart';
import 'package:fantasypro/textos/textos_app.dart';

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
    final ctrlNombre = TextEditingController();
    final ctrlPosicion = TextEditingController();
    final ctrlNacionalidad = TextEditingController();
    final ctrlDorsal = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            TextosApp.JUGADORES_ADMIN_CREAR_TITULO.replaceAll(
              "{EQUIPO}",
              widget.equipo.nombre,
            ),
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
                const SizedBox(height: 8),
                TextField(
                  controller: ctrlPosicion,
                  decoration: const InputDecoration(
                    labelText: TextosApp.JUGADORES_ADMIN_CREAR_LABEL_POSICION,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ctrlNacionalidad,
                  decoration: const InputDecoration(
                    labelText:
                        TextosApp.JUGADORES_ADMIN_CREAR_LABEL_NACIONALIDAD,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ctrlDorsal,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: TextosApp.JUGADORES_ADMIN_CREAR_LABEL_DORSAL,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text(TextosApp.JUGADORES_ADMIN_CREAR_BOTON_CANCELAR),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text(TextosApp.JUGADORES_ADMIN_CREAR_BOTON_CREAR),
              onPressed: () async {
                final nombre = ctrlNombre.text.trim();
                final posicion = ctrlPosicion.text.trim();
                final nacionalidad = ctrlNacionalidad.text.trim();
                final dorsalText = ctrlDorsal.text.trim();
                final dorsal = dorsalText.isEmpty
                    ? 0
                    : int.tryParse(dorsalText) ?? 0;

                if (nombre.isEmpty || posicion.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        TextosApp.JUGADORES_ADMIN_VALIDACION_OBLIGATORIOS,
                      ),
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
              tooltip: TextosApp.JUGADORES_ADMIN_TOOLTIP_EDITAR,
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
              tooltip: j.activo
                  ? TextosApp.JUGADORES_ADMIN_TOOLTIP_ARCHIVAR
                  : TextosApp.JUGADORES_ADMIN_TOOLTIP_ACTIVAR,
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
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: TextosApp.JUGADORES_ADMIN_TOOLTIP_ELIMINAR,
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
