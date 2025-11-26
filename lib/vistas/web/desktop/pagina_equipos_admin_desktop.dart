/*
  Archivo: pagina_equipos_admin_desktop.dart
  Descripción:
    Pantalla de administración de equipos pertenecientes a una liga.
    Permite:
      - Visualizar equipos activos y archivados.
      - Crear nuevos equipos.
      - Editar un equipo existente.
      - Archivar / activar equipos.
      - Eliminar equipos de forma permanente.
  Dependencias:
    - modelos/liga.dart
    - modelos/equipo.dart
    - controladores/controlador_equipos.dart
    - vistas/web/desktop/pagina_equipo_editar_desktop.dart
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

  /*
    Nombre: cargar
    Descripción:
      Recupera todos los equipos pertenecientes a la liga actual.
      Divide el resultado entre activos y archivados para mostrarlos en columnas separadas.
  */
  Future<void> cargar() async {
    setState(() => cargando = true);

    final todos = await controlador.obtenerPorLiga(widget.liga.id);

    activos = todos.where((e) => e.activo).toList();
    archivados = todos.where((e) => !e.activo).toList();

    setState(() => cargando = false);
  }

  /*
    Nombre: crearEquipo
    Descripción:
      Abre un diálogo para ingresar nombre y descripción del equipo.
  */
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

  /*
    Nombre: itemEquipo
    Descripción:
      Construye un ListTile con acciones de administración para cada equipo.
  */
  Widget itemEquipo(Equipo equipo) {
    return ListTile(
      title: Text(equipo.nombre),
      subtitle: Text(equipo.descripcion),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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

              if (resultado == true) {
                cargar();
              }
            },
          ),

          // Archivar / activar
          IconButton(
            icon: Icon(equipo.activo ? Icons.archive : Icons.unarchive),
            tooltip: equipo.activo ? "Archivar" : "Activar",
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
            tooltip: "Eliminar equipo",
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
      appBar: AppBar(title: Text("Equipos de la liga: ${widget.liga.nombre}")),
      floatingActionButton: FloatingActionButton(
        onPressed: crearEquipo,
        child: const Icon(Icons.add),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // -------------------------------
                // Columnas de equipos activos
                // -------------------------------
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Activos",
                        style: TextStyle(
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

                // -------------------------------
                // Columnas de equipos archivados
                // -------------------------------
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Archivados",
                        style: TextStyle(
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
