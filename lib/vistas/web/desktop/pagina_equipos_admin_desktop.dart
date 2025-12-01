/*
  Archivo: pagina_equipos_admin_desktop.dart
  Descripción:
    Administración visual mejorada de equipos de una liga.
      - Botón Volver
      - Botón “Gestionar jugadores (próximamente)”
      - Refuerzo visual de estructura
*/

import 'package:fantasypro/vistas/web/desktop/pagina_jugadores_admin_desktop.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/equipo.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/controladores/controlador_equipos.dart';
import 'package:fantasypro/servicios/firebase/servicio_equipos.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_equipo_editar_desktop.dart';
import 'package:fantasypro/textos/textos_app.dart';

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
          title: Text(
            TextosApp.EQUIPOS_ADMIN_CREAR_TITULO.replaceAll(
              "{LIGA}",
              widget.liga.nombre,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controladorNombre,
                decoration: const InputDecoration(
                  labelText: TextosApp.EQUIPOS_ADMIN_CREAR_LABEL_NOMBRE,
                ),
              ),
              TextField(
                controller: controladorDescripcion,
                decoration: const InputDecoration(
                  labelText: TextosApp.EQUIPOS_ADMIN_CREAR_LABEL_DESCRIPCION,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(TextosApp.EQUIPOS_ADMIN_CREAR_BOTON_CANCELAR),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text(TextosApp.EQUIPOS_ADMIN_CREAR_BOTON_CREAR),
              onPressed: () async {
                final nombre = controladorNombre.text.trim();
                final descripcion = controladorDescripcion.text.trim();
                if (nombre.isEmpty) return;

                final equipo = Equipo(
                  id: "", // Firestore generará uno nuevo
                  idUsuario: "", // ← requerido por el modelo actual
                  idLiga: widget.liga.id,
                  nombre: nombre,
                  descripcion: descripcion,
                  escudoUrl: "",
                  fechaCreacion: DateTime.now().millisecondsSinceEpoch,
                  activo: true,
                );

                final servicio = ServicioEquipos();
                await servicio.crearEquipo(equipo);

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
        title: const Text(TextosApp.EQUIPOS_ADMIN_CONFIRMAR_TITULO),
        content: Text(mensaje),
        actions: [
          TextButton(
            child: const Text(TextosApp.EQUIPOS_ADMIN_CONFIRMAR_CANCELAR),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text(TextosApp.EQUIPOS_ADMIN_CONFIRMAR_ACEPTAR),
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
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: TextosApp.EQUIPOS_ADMIN_TOOLTIP_GESTION_JUGADORES,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaginaJugadoresAdminDesktop(equipo: equipo),
                  ),
                ).then((_) => cargar()); // recargar al volver
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: TextosApp.EQUIPOS_ADMIN_TOOLTIP_EDITAR,
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
            IconButton(
              icon: Icon(equipo.activo ? Icons.archive : Icons.unarchive),
              tooltip: equipo.activo
                  ? TextosApp.EQUIPOS_ADMIN_TOOLTIP_ARCHIVAR
                  : TextosApp.EQUIPOS_ADMIN_TOOLTIP_ACTIVAR,
              onPressed: () async {
                final ok = await confirmar(
                  equipo.activo
                      ? TextosApp.EQUIPOS_ADMIN_CONFIRMAR_ARCHIVAR
                      : TextosApp.EQUIPOS_ADMIN_CONFIRMAR_ACTIVAR,
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
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: TextosApp.EQUIPOS_ADMIN_TOOLTIP_ELIMINAR,
              onPressed: () async {
                final ok = await confirmar(
                  TextosApp.EQUIPOS_ADMIN_CONFIRMAR_ELIMINAR,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextosApp.EQUIPOS_ADMIN_APPBAR_TITULO.replaceAll(
            "{LIGA}",
            widget.liga.nombre,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: TextosApp.EQUIPOS_ADMIN_APPBAR_VOLVER,
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                TextosApp.EQUIPOS_ADMIN_APPBAR_GESTION_TEXTO,
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
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.EQUIPOS_ADMIN_COLUMNA_ACTIVOS.replaceAll(
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
                          children: activos.map(itemEquipo).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.EQUIPOS_ADMIN_COLUMNA_ARCHIVADOS.replaceAll(
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
