/*
  Archivo: pagina_ligas_admin_desktop.dart
  Descripción:
    Administración de ligas para usuarios administradores.
*/

import 'package:fantasypro/vistas/web/desktop/pagina_equipos_admin_desktop.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/modelos/liga.dart';

class PaginaLigasAdminDesktop extends StatefulWidget {
  const PaginaLigasAdminDesktop({super.key});

  @override
  State<PaginaLigasAdminDesktop> createState() =>
      _PaginaLigasAdminDesktopEstado();
}

class _PaginaLigasAdminDesktopEstado extends State<PaginaLigasAdminDesktop> {
  final ControladorLigas controlador = ControladorLigas();

  bool cargando = true;
  List<Liga> activas = [];
  List<Liga> archivadas = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => cargando = true);

    final todas = await controlador.obtenerTodas();

    activas = todas.where((l) => l.activa).toList();
    archivadas = todas.where((l) => !l.activa).toList();

    setState(() => cargando = false);
  }

  Future<void> crearLiga() async {
    final controladorNombre = TextEditingController();
    final controladorDescripcion = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Crear nueva liga"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controladorNombre,
                decoration: const InputDecoration(
                  labelText: "Nombre de la liga",
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
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () async {
                final nombre = controladorNombre.text.trim();
                final descripcion = controladorDescripcion.text.trim();

                if (nombre.isEmpty) return;

                await controlador.crearLiga(nombre, descripcion);
                Navigator.pop(context);
                cargar();
              },
              child: const Text("Crear"),
            ),
          ],
        );
      },
    );
  }

  Widget itemLiga(Liga liga) {
    return ListTile(
      title: Text(liga.nombre),
      subtitle: Text(liga.temporada),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botón: Administrar equipos
          IconButton(
            icon: const Icon(Icons.groups),
            tooltip: "Administrar equipos",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PaginaEquiposAdminDesktop(liga: liga),
                ),
              );
            },
          ),

          // Archivar / activar
          IconButton(
            icon: Icon(liga.activa ? Icons.archive : Icons.unarchive),
            onPressed: () async {
              if (liga.activa) {
                await controlador.archivar(liga.id);
              } else {
                await controlador.activar(liga.id);
              }
              cargar();
            },
          ),

          // Eliminar
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await controlador.eliminar(liga.id);
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
      appBar: AppBar(title: const Text("Administración de Ligas")),
      floatingActionButton: FloatingActionButton(
        onPressed: crearLiga,
        child: const Icon(Icons.add),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Activas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: activas.map((l) => itemLiga(l)).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Archivadas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivadas.map((l) => itemLiga(l)).toList(),
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
