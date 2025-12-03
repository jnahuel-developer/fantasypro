/*
  Archivo: ui__admin__alineacion__lista__desktop.dart
  Descripción:
    Administración de alineaciones de un usuario dentro de una liga específica.
    Permite:
    - Visualizar listas separadas de alineaciones activas y archivadas
    - Crear una nueva alineación fantasy manual
    - Editar una alineación existente
    - Archivar, activar o eliminar alineaciones

  Dependencias:
    - modelos/alineacion.dart: para representar las alineaciones fantasy del usuario
    - controladores/controlador_alineaciones.dart: para gestionar las operaciones de CRUD sobre las alineaciones

  Pantallas destino:
    - ui__admin__alineacion__editar__desktop.dart: se navega hacia esta pantalla al presionar el botón de edición en una alineación, para modificar sus datos
*/

import 'package:fantasypro/controladores/controlador_alineaciones.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/alineacion.dart';
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

  /// Estado de carga.
  bool cargando = true;

  /// Alineaciones activas.
  List<Alineacion> activas = [];

  /// Alineaciones archivadas.
  List<Alineacion> archivadas = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  /*
    Nombre: cargar
    Descripción:
      Carga y separa alineaciones activas y archivadas del usuario en la liga.
    Entradas: ninguna
    Salidas:
      - Future<void>: sin valor devuelto
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
      Abre un diálogo para crear una nueva alineación, solicitando formación,
      IDs de jugadores y el ID del equipo fantasy.
    Entradas: ninguna
    Salidas:
      - Future<void>: sin valor devuelto
  */
  Future<void> crearAlineacion() async {
    final ctrlJugadores = TextEditingController();
    final ctrlPuntos = TextEditingController(text: "0");
    final ctrlIdEquipoFantasy = TextEditingController();
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
                        seleccionFormacion = v;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ID equipo fantasy
                TextField(
                  controller: ctrlIdEquipoFantasy,
                  decoration: const InputDecoration(
                    labelText: "ID del equipo fantasy",
                  ),
                ),
                const SizedBox(height: 12),

                // Jugadores
                TextField(
                  controller: ctrlJugadores,
                  decoration: const InputDecoration(
                    labelText: "IDs de jugadores (separados por coma)",
                    hintText: "ej: j1,j2,j3,j4,j5",
                  ),
                ),
                const SizedBox(height: 12),

                // Puntos
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
                final idEquipoFantasy = ctrlIdEquipoFantasy.text.trim();
                final puntos = puntosText.isEmpty
                    ? 0
                    : int.tryParse(puntosText) ?? 0;

                if (textoJugadores.isEmpty || idEquipoFantasy.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Debe ingresar jugadores y ID de equipo."),
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
                        "Formato inválido para los IDs de jugadores.",
                      ),
                    ),
                  );
                  return;
                }

                await _controlador.crearAlineacion(
                  widget.idLiga,
                  widget.idUsuario,
                  idEquipoFantasy,
                  idsJugadores,
                  formacion: seleccionFormacion,
                  puntosTotales: puntos,
                );

                if (!mounted) return;
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
      Abre diálogo de confirmación para acciones críticas.
    Entradas:
      - mensaje (String): texto a mostrar
    Salidas:
      - Future<bool>: true si el usuario confirma
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
      Renderiza la tarjeta visual de una alineación individual.
    Entradas:
      - a (Alineacion): alineación a mostrar
    Salidas:
      - Widget: tarjeta de alineación
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
