/*
  Archivo: pagina_participaciones_admin_desktop.dart
  Descripción:
    Administración de participaciones de usuarios dentro de una liga (Web Desktop).
    Flujo aprobado por PM:
      - El Admin puede crear participaciones directamente con ServicioParticipaciones.
      - Debe construir manualmente el modelo ParticipacionLiga.
*/

import 'package:fantasypro/vistas/web/desktop/pagina_alineaciones_admin_desktop.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_participacion_editar_desktop.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';

class PaginaParticipacionesAdminDesktop extends StatefulWidget {
  final Liga liga;

  const PaginaParticipacionesAdminDesktop({super.key, required this.liga});

  @override
  State<PaginaParticipacionesAdminDesktop> createState() =>
      _PaginaParticipacionesAdminDesktopEstado();
}

class _PaginaParticipacionesAdminDesktopEstado
    extends State<PaginaParticipacionesAdminDesktop> {
  final ControladorParticipaciones _controlador = ControladorParticipaciones();
  final ServicioParticipaciones servicioParticipaciones =
      ServicioParticipaciones();

  bool cargando = true;
  List<ParticipacionLiga> activos = [];
  List<ParticipacionLiga> archivados = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => cargando = true);

    final todos = await _controlador.obtenerPorLiga(widget.liga.id);

    activos = todos.where((p) => p.activo).toList()
      ..sort(
        (a, b) => a.nombreEquipoFantasy.toLowerCase().compareTo(
          b.nombreEquipoFantasy.toLowerCase(),
        ),
      );

    archivados = todos.where((p) => !p.activo).toList()
      ..sort(
        (a, b) => a.nombreEquipoFantasy.toLowerCase().compareTo(
          b.nombreEquipoFantasy.toLowerCase(),
        ),
      );

    setState(() => cargando = false);
  }

  Future<void> crearParticipacion() async {
    final ctrlIdUsuario = TextEditingController();
    final ctrlNombreEquipo = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Crear participación en ${widget.liga.nombre}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlIdUsuario,
                decoration: const InputDecoration(labelText: "ID de usuario"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: ctrlNombreEquipo,
                decoration: const InputDecoration(
                  labelText: "Nombre del equipo fantasy",
                ),
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
                final idUsuario = ctrlIdUsuario.text.trim();
                final nombre = ctrlNombreEquipo.text.trim();

                if (idUsuario.isEmpty || nombre.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "El usuario y el nombre del equipo no pueden estar vacíos.",
                      ),
                    ),
                  );
                  return;
                }

                final participacion = ParticipacionLiga(
                  id: "", // Firestore generará uno nuevo
                  idLiga: widget.liga.id,
                  idUsuario: idUsuario,
                  nombreEquipoFantasy: nombre,
                  puntos: 0,
                  fechaCreacion: DateTime.now().millisecondsSinceEpoch,
                  activo: true,
                );

                await servicioParticipaciones.crearParticipacion(participacion);

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

  Future<bool> confirmar(String mensaje) async {
    final r = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmación"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );

    return r ?? false;
  }

  Widget avatar(ParticipacionLiga p) {
    final inicial = p.nombreEquipoFantasy.isNotEmpty
        ? p.nombreEquipoFantasy[0].toUpperCase()
        : "?";

    return CircleAvatar(child: Text(inicial));
  }

  Widget itemParticipacion(ParticipacionLiga p) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: avatar(p),
        title: Text(
          p.nombreEquipoFantasy,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Usuario: ${p.idUsuario}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Alineaciones
            IconButton(
              icon: const Icon(Icons.sports_soccer),
              tooltip: "Gestionar alineaciones",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaginaAlineacionesAdminDesktop(
                      idLiga: widget.liga.id,
                      idUsuario: p.idUsuario,
                    ),
                  ),
                ).then((_) => cargar());
              },
            ),

            // Editar
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editar participación",
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PaginaParticipacionEditarDesktop(participacion: p),
                  ),
                );

                if (resultado == true) cargar();
              },
            ),

            // Archivar / Activar
            IconButton(
              icon: Icon(p.activo ? Icons.archive : Icons.unarchive),
              tooltip: p.activo ? "Archivar" : "Activar",
              onPressed: () async {
                final ok = await confirmar(
                  p.activo
                      ? "¿Desea archivar la participación?"
                      : "¿Desea activar la participación?",
                );
                if (!ok) return;

                if (p.activo) {
                  await _controlador.archivar(p.id);
                } else {
                  await _controlador.activar(p.id);
                }

                cargar();
              },
            ),

            // Eliminar
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: "Eliminar participación",
              onPressed: () async {
                final ok = await confirmar(
                  "¿Está seguro que desea eliminar esta participación?",
                );
                if (!ok) return;

                await _controlador.eliminar(p.id);
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
        title: Text("Participantes — ${widget.liga.nombre}"),
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
                "Gestión de participaciones",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crearParticipacion,
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
                          children: activos.map(itemParticipacion).toList(),
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
                          children: archivados.map(itemParticipacion).toList(),
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
