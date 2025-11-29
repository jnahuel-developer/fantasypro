/*
  Archivo: pagina_ligas_admin_desktop.dart
  Descripción:
    Administración de ligas para usuarios administradores.
*/

import 'package:fantasypro/vistas/web/desktop/pagina_equipos_admin_desktop.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_participaciones_admin_desktop.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/textos/textos_app.dart';

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

    activas = todas.where((l) => l.activa).toList()
      ..sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );

    archivadas = todas.where((l) => !l.activa).toList()
      ..sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );

    setState(() => cargando = false);
  }

  Future<void> crearLiga() async {
    final ctrlNombre = TextEditingController();
    final ctrlDescripcion = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(TextosApp.LIGAS_ADMIN_DESKTOP_BOTON_CREAR),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ctrlNombre,
              decoration: const InputDecoration(
                labelText: TextosApp.LIGAS_ADMIN_DESKTOP_INPUT_NOMBRE,
              ),
            ),
            TextField(
              controller: ctrlDescripcion,
              decoration: const InputDecoration(
                labelText: TextosApp.LIGAS_ADMIN_DESKTOP_INPUT_DESCRIPCION,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(TextosApp.LIGAS_ADMIN_DESKTOP_ACCION_CANCELAR),
          ),
          ElevatedButton(
            onPressed: () async {
              final nombre = ctrlNombre.text.trim();
              final descripcion = ctrlDescripcion.text.trim();

              if (nombre.isEmpty) return;

              await controlador.crearLiga(nombre, descripcion);
              Navigator.pop(context);
              cargar();
            },
            child: const Text(TextosApp.LIGAS_ADMIN_DESKTOP_ACCION_CREAR),
          ),
        ],
      ),
    );
  }

  Widget itemLiga(Liga liga) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      elevation: 2,
      child: ListTile(
        title: Text(
          liga.nombre,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(liga.temporada),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Acceso a participaciones (navegación añadida)
            IconButton(
              icon: const Icon(Icons.supervised_user_circle),
              tooltip: "Participaciones",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PaginaParticipacionesAdminDesktop(liga: liga),
                  ),
                ).then((_) => cargar());
              },
            ),

            // Administrar equipos
            IconButton(
              icon: const Icon(Icons.groups),
              tooltip: TextosApp.LIGAS_ADMIN_DESKTOP_TOOLTIP_ADMIN_EQUIPOS,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaginaEquiposAdminDesktop(liga: liga),
                  ),
                );
              },
            ),

            // Archivar / Activar
            IconButton(
              icon: Icon(liga.activa ? Icons.archive : Icons.unarchive),
              tooltip: liga.activa
                  ? TextosApp.LIGAS_ADMIN_DESKTOP_TOOLTIP_ARCHIVAR
                  : TextosApp.LIGAS_ADMIN_DESKTOP_TOOLTIP_ACTIVAR,
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
              tooltip: TextosApp.LIGAS_ADMIN_DESKTOP_TOOLTIP_ELIMINAR,
              onPressed: () async {
                await controlador.eliminar(liga.id);
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
        title: const Text(TextosApp.LIGAS_ADMIN_DESKTOP_APPBAR_TITULO),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: TextosApp.LIGAS_ADMIN_DESKTOP_TOOLTIP_VOLVER,
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                TextosApp.LIGAS_ADMIN_DESKTOP_APPBAR_INDICADOR,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: crearLiga,
        child: const Icon(Icons.add),
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Columna ACTIVO
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.LIGAS_ADMIN_DESKTOP_TITULO_ACTIVAS.replaceAll(
                          "{CANT}",
                          activas.length.toString(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: activas.map(itemLiga).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Columna ARCHIVADO
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.LIGAS_ADMIN_DESKTOP_TITULO_ARCHIVADAS
                            .replaceAll("{CANT}", archivadas.length.toString()),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivadas.map(itemLiga).toList(),
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
