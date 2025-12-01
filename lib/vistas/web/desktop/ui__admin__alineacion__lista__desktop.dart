/*
  Archivo: ui__admin__alineacion__lista__desktop.dart
  Descripción:
    Administración de alineaciones de un usuario dentro de una liga.
    - Listado Activas / Archivadas
    - Crear alineación
    - Editar alineación
    - Archivar / Activar / Eliminar

  Dependencias:
    - modelos/alineacion.dart
    - controladores/controlador_alineaciones.dart
    - ui__admin__alineacion__editar__desktop.dart

  Pantallas que navegan hacia esta:
    - ui__admin__participacion__lista__desktop.dart

  Pantallas destino:
    - ui__admin__alineacion__editar__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart'
    hide Alineacion;
import 'ui__admin__alineacion__editar__desktop.dart';

class UiAdminAlineacionListaDesktop extends StatefulWidget {
  /// ID de la liga asociada a las alineaciones.
  final String idLiga;

  /// ID del usuario dueño de las alineaciones.
  final String idUsuario;

  const UiAdminAlineacionListaDesktop({
    super.key,
    required this.idLiga,
    required this.idUsuario,
  });

  @override
  State<UiAdminAlineacionListaDesktop> createState() =>
      _UiAdminAlineacionListaDesktopEstado();
}

class _UiAdminAlineacionListaDesktopEstado
    extends State<UiAdminAlineacionListaDesktop> {
  /// Controlador de alineaciones.
  final ControladorAlineaciones _controlador = ControladorAlineaciones();

  bool cargando = true;
  List<Alineacion> activas = [];
  List<Alineacion> archivadas = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  /*
    Nombre: cargar
    Descripción:
      Obtiene las alineaciones del usuario en la liga y las separa
      en activas / archivadas.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> cargar() async {
    setState(() => cargando = true);

    final todas = await _controlador.obtenerPorUsuarioEnLiga(
      widget.idLiga,
      widget.idUsuario,
    );

    activas = todas.where((a) => a.activo).toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));

    archivadas = todas.where((a) => !a.activo).toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));

    setState(() => cargando = false);
  }

  /*
    Nombre: crearAlineacion
    Descripción:
      Abre un diálogo para crear una nueva alineación.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> crearAlineacion() async {
    final ctrlJugadores = TextEditingController();
    final ctrlPuntos = TextEditingController(text: "0");
    String seleccionFormacion = "4-4-2";

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Crear nueva alineación"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Formación
                Row(
                  children: [
                    const Text("Formación:"),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: seleccionFormacion,
                      items: const [
                        DropdownMenuItem(value: "4-4-2", child: Text("4-4-2")),
                        DropdownMenuItem(value: "4-3-3", child: Text("4-3-3")),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        // Nota: aquí no se fuerza rebuild del diálogo;
                        // se mantiene el comportamiento original.
                        seleccionFormacion = v;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Jugadores (IDs)
                TextField(
                  controller: ctrlJugadores,
                  decoration: const InputDecoration(
                    labelText: "IDs de jugadores (separados por coma)",
                    hintText: "ej: j1,j2,j3,j4,j5",
                  ),
                ),
                const SizedBox(height: 12),

                // Puntos iniciales (opcional)
                TextField(
                  controller: ctrlPuntos,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Puntos iniciales (opcional)",
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
                final textoJugadores = ctrlJugadores.text.trim();
                final puntosText = ctrlPuntos.text.trim();
                final puntos = puntosText.isEmpty
                    ? 0
                    : int.tryParse(puntosText) ?? 0;

                if (textoJugadores.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Debe ingresar al menos un jugador."),
                    ),
                  );
                  return;
                }

                final idsJugadores = textoJugadores
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();

                if (idsJugadores.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Formato inválido para la lista de jugadores.",
                      ),
                    ),
                  );
                  return;
                }

                await _controlador.crearAlineacion(
                  widget.idLiga,
                  widget.idUsuario,
                  idsJugadores,
                  formacion: seleccionFormacion,
                  puntosTotales: puntos,
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
    Nombre: confirmar
    Descripción:
      Diálogo genérico de confirmación para operaciones críticas.
    Entradas:
      - mensaje (String)
    Salidas:
      - Future<bool>
  */
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

  /*
    Nombre: itemAlineacion
    Descripción:
      Construye la tarjeta de una alineación en la lista.
    Entradas:
      - a (Alineacion)
    Salidas:
      - Widget
  */
  Widget itemAlineacion(Alineacion a) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.sports_soccer, size: 36),
        title: Text(
          "Alineación ${a.id}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Formación: ${a.formacion} • Jugadores: ${a.jugadoresSeleccionados.length} • Puntos: ${a.puntosTotales}",
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Editar
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Editar alineación",
              onPressed: () async {
                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        UiAdminAlineacionEditarDesktop(alineacion: a),
                  ),
                );
                if (resultado == true) cargar();
              },
            ),

            // Archivar / Activar
            IconButton(
              icon: Icon(a.activo ? Icons.archive : Icons.unarchive),
              tooltip: a.activo ? "Archivar" : "Activar",
              onPressed: () async {
                final ok = await confirmar(
                  a.activo
                      ? "¿Desea archivar esta alineación?"
                      : "¿Desea activar esta alineación?",
                );
                if (!ok) return;

                if (a.activo) {
                  await _controlador.archivar(a.id);
                } else {
                  await _controlador.activar(a.id);
                }
                cargar();
              },
            ),

            // Eliminar
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: "Eliminar alineación",
              onPressed: () async {
                final ok = await confirmar(
                  "¿Eliminar esta alineación definitivamente?",
                );
                if (!ok) return;
                await _controlador.eliminar(a.id);
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
        title: Text("Alineaciones — Usuario ${widget.idUsuario}"),
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
                "Gestión de alineaciones",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: crearAlineacion,
        child: const Icon(Icons.add),
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Activas
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Activas (${activas.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: activas.map(itemAlineacion).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                // Archivadas
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        "Archivadas (${archivadas.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivadas.map(itemAlineacion).toList(),
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
