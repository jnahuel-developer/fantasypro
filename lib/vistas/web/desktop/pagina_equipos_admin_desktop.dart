/*
  Archivo: pagina_equipos_admin_desktop.dart
  Descripción:
    Administración visual mejorada de equipos de una liga.
    Etapa 5:
      - Botón Volver
      - Botón “Gestionar jugadores (próximamente)”
      - Refuerzo visual de estructura
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/controladores/controlador_equipos.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_equipo_editar_desktop.dart';

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

    final todos = await controlador.obtenerPorLiga(widget.liga.id);

    activos = todos.where((e) => e.activo).toList()
      ..sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );

    archivados = todos.where((e) => !e.activo).toList()
      ..sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );

    setState(() => cargando = false);
  }

  Future<void> crearEquipo() async {
    final controladorNombre = TextEditingController();
    final controladorDescripcion = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Crear equipo en ${widget.liga.nombre}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controladorNombre,
                decoration: const InputDecoration(
                  labelText: "Nombre del equipo",
                ),
              ),
              TextField(
                controller: controladorDescripcion,
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
                final nombre = controladorNombre.text.trim();
                final descripcion = controladorDescripcion.text.trim();
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

  Widget escudo(Equipo equipo) {
    final url = equipo.escudoUrl.trim();

    if (url.isEmpty) {
      return const Icon(Icons.shield, size: 40);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        url,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
      ),
    );
  }

  Widget itemEquipo(Equipo equipo) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: escudo(equipo),
        title: Text(
          equipo.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(equipo.descripcion),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Próximamente: gestionar jugadores
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: "Gestionar jugadores (próximamente)",
              onPressed: null, // desactivado
            ),

            // Editar
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editar equipo",
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaginaEquipoEditarDesktop(equipo: equipo),
                  ),
                );
                if (resultado == true) cargar();
              },
            ),

            // Archivar / Activar
            IconButton(
              icon: Icon(equipo.activo ? Icons.archive : Icons.unarchive),
              tooltip: equipo.activo ? "Archivar" : "Activar",
              onPressed: () async {
                final ok = await confirmar(
                  equipo.activo
                      ? "¿Desea archivar el equipo?"
                      : "¿Desea activar el equipo?",
                );
                if (!ok) return;

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
              tooltip: "Eliminar equipo",
              onPressed: () async {
                final ok = await confirmar(
                  "¿Está seguro que desea eliminar este equipo?",
                );
                if (!ok) return;

                await controlador.eliminar(equipo.id);
                cargar();
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipos – ${widget.liga.nombre}"),
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
                "Gestión de equipos",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
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
                      Text(
                        "Activos (${activos.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: activos.map(itemEquipo).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Archivados
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
                          children: archivados.map(itemEquipo).toList(),
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
