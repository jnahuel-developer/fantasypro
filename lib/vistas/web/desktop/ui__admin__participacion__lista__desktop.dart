/*
  Archivo: ui__admin__participacion__lista__desktop.dart
  Descripción:
    Administración de participaciones de usuarios dentro de una liga.
    Permite crear, editar, archivar, activar y eliminar participaciones.
  Dependencias:
    - modelos/liga.dart
    - modelos/participacion_liga.dart
    - controladores/controlador_participaciones.dart
    - servicio_participaciones.dart
    - ui__admin__participacion__editar__desktop.dart
    - ui__admin__alineacion__lista__desktop.dart
  Pantallas que navegan hacia esta:
    - ui__admin__liga__lista__desktop.dart
  Pantallas destino:
    - ui__admin__participacion__editar__desktop.dart
    - ui__admin__alineacion__lista__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/modelos/participacion_liga.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/servicios/firebase/servicio_participaciones.dart';

import 'ui__admin__participacion__editar__desktop.dart';
import 'ui__admin__alineacion__lista__desktop.dart';

class UiAdminParticipacionListaDesktop extends StatefulWidget {
  final Liga liga;

  const UiAdminParticipacionListaDesktop({super.key, required this.liga});

  @override
  State<UiAdminParticipacionListaDesktop> createState() =>
      _UiAdminParticipacionListaDesktopEstado();
}

class _UiAdminParticipacionListaDesktopEstado
    extends State<UiAdminParticipacionListaDesktop> {
  /// Controlador de participaciones.
  final ControladorParticipaciones _controlador = ControladorParticipaciones();

  /// Servicio directo de participaciones (creación manual).
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

  /*
    Nombre: cargar
    Descripción:
      Recupera las participaciones por liga y las separa en activas/archivadas.
    Entradas: ninguna
    Salidas: Future<void>
  */
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

  /*
    Nombre: crearParticipacion
    Descripción:
      Crea una participación manualmente construyendo el modelo.
    Entradas: ninguna
    Salidas: Future<void>
  */
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
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Crear"),
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

                final model = ParticipacionLiga(
                  id: "",
                  idLiga: widget.liga.id,
                  idUsuario: idUsuario,
                  nombreEquipoFantasy: nombre,
                  puntos: 0,
                  fechaCreacion: DateTime.now().millisecondsSinceEpoch,
                  activo: true,
                );

                await servicioParticipaciones.crearParticipacion(model);

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
    Nombre: confirmar
    Descripción:
      Diálogo genérico para confirmar operaciones de riesgo.
    Entradas: mensaje
    Salidas: Future<bool>
  */
  Future<bool> confirmar(String mensaje) async {
    final r = await showDialog<bool>(
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

    return r ?? false;
  }

  /*
    Nombre: itemParticipacion
    Descripción:
      Renderiza la tarjeta visual de una participación.
    Entradas: ParticipacionLiga p
    Salidas: Widget
  */
  Widget itemParticipacion(ParticipacionLiga p) {
    final inicial = p.nombreEquipoFantasy.isNotEmpty
        ? p.nombreEquipoFantasy[0].toUpperCase()
        : "?";

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(child: Text(inicial)),
        title: Text(
          p.nombreEquipoFantasy,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Usuario: ${p.idUsuario}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gestionar alineaciones
            IconButton(
              icon: const Icon(Icons.sports_soccer),
              tooltip: "Gestionar alineaciones",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminAlineacionListaDesktop(
                      idLiga: widget.liga.id,
                      idUsuario: p.idUsuario,
                    ),
                  ),
                ).then((_) => cargar());
              },
            ),

            // Editar participación
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editar participación",
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        UiAdminParticipacionEditarDesktop(participacion: p),
                  ),
                );
                if (result == true) cargar();
              },
            ),

            // Archivar / activar
            IconButton(
              icon: Icon(p.activo ? Icons.archive : Icons.unarchive),
              tooltip: p.activo ? "Archivar" : "Activar",
              onPressed: () async {
                final ok = await confirmar(
                  p.activo
                      ? "¿Archivar esta participación?"
                      : "¿Activar esta participación?",
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
                  "¿Eliminar esta participación definitivamente?",
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
