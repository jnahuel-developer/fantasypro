/*
  Archivo: pagina_equipos_admin_desktop.dart
  Descripción:
    Pantalla de administración de equipos dentro de una liga específica.
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_equipos.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/modelos/liga.dart';

class PaginaEquiposAdminDesktop extends StatefulWidget {
  final Liga liga;

  const PaginaEquiposAdminDesktop({super.key, required this.liga});

  @override
  State<PaginaEquiposAdminDesktop> createState() =>
      _PaginaEquiposAdminDesktopEstado();
}

class _PaginaEquiposAdminDesktopEstado
    extends State<PaginaEquiposAdminDesktop> {
  final ControladorEquipos controlador = ControladorEquipos();

  bool cargando = true;
  List<Equipo> activos = [];
  List<Equipo> archivados = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => cargando = true);

    final lista = await controlador.obtenerPorLiga(widget.liga.id);

    activos = lista.where((e) => e.activo).toList();
    archivados = lista.where((e) => !e.activo).toList();

    setState(() => cargando = false);
  }

  Future<void> crearEquipo() async {
    final txtNombre = TextEditingController();
    final txtDescripcion = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Crear equipo en ${widget.liga.nombre}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: txtNombre,
              decoration: const InputDecoration(labelText: "Nombre del equipo"),
            ),
            TextField(
              controller: txtDescripcion,
              decoration: const InputDecoration(
                labelText: "Descripción (opcional)",
              ),
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
              final nombre = txtNombre.text.trim();
              final descripcion = txtDescripcion.text.trim();

              if (nombre.isEmpty) return;

              await controlador.crearEquipo(
                widget.liga.id,
                nombre,
                descripcion,
              );

              Navigator.pop(context);
              cargar();
            },
          ),
        ],
      ),
    );
  }

  Widget itemEquipo(Equipo equipo) {
    return ListTile(
      title: Text(equipo.nombre),
      subtitle: Text(
        "Desde ${DateTime.fromMillisecondsSinceEpoch(equipo.fechaCreacion)}",
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Archivar / activar
          IconButton(
            icon: Icon(equipo.activo ? Icons.archive : Icons.unarchive),
            onPressed: () async {
              if (equipo.activo) {
                await controlador.archivar(equipo.id);
              } else {
                await controlador.activar(equipo.id);
              }
              cargar();
            },
          ),
          // Eliminar
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await controlador.eliminar(equipo.id);
              cargar();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Equipos de ${widget.liga.nombre}")),
      floatingActionButton: FloatingActionButton(
        onPressed: crearEquipo,
        child: const Icon(Icons.add),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Activos
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Activos",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: activos.map((e) => itemEquipo(e)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Archivados
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Archivados",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivados
                              .map((e) => itemEquipo(e))
                              .toList(),
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
