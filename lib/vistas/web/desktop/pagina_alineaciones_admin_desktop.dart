/*
  Archivo: pagina_alineaciones_admin_desktop.dart
  Descripción:
    Administración de alineaciones de un usuario dentro de una liga.
    - Listado Activas / Archivadas
    - Crear alineación (formación, jugadores, puntos iniciales)
    - Editar alineación
    - Archivar / Activar / Eliminar con confirmación
    - Conteos y ordenamiento por fecha
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/alineacion.dart';
import 'package:fantasypro/controladores/controlador_alineaciones.dart'
    hide Alineacion;
import 'package:fantasypro/vistas/web/desktop/pagina_alineacion_editar_desktop.dart';

class PaginaAlineacionesAdminDesktop extends StatefulWidget {
  final String idLiga;
  final String idUsuario;

  const PaginaAlineacionesAdminDesktop({
    super.key,
    required this.idLiga,
    required this.idUsuario,
  });

  @override
  State<PaginaAlineacionesAdminDesktop> createState() =>
      _PaginaAlineacionesAdminDesktopEstado();
}

class _PaginaAlineacionesAdminDesktopEstado
    extends State<PaginaAlineacionesAdminDesktop> {
  final ControladorAlineaciones _controlador = ControladorAlineaciones();

  bool cargando = true;
  List<Alineacion> activas = [];
  List<Alineacion> archivadas = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => cargando = true);

    final todas = await _controlador.obtenerPorUsuarioEnLiga(
      widget.idLiga,
      widget.idUsuario,
    );

    activas = todas.where((a) => a.activo).toList()
      ..sort(
        (a, b) => b.fechaCreacion.compareTo(a.fechaCreacion),
      ); // más recientes primero

    archivadas = todas.where((a) => !a.activo).toList()
      ..sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));

    setState(() => cargando = false);
  }

  // ---------------------------
  // Crear alineación
  // ---------------------------
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
                        seleccionFormacion = v;
                        // force rebuild of dialog - use setState on dialog via StatefulBuilder
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

                // Llamada al controlador.
                // Nota: el controlador debe aceptar el parámetro 'formacion'.
                // Si el controlador aún no soporta 'formacion', ajustar su firma para:
                // crearAlineacion(String idLiga, String idUsuario, List<String> jugadores, { String formacion = '4-4-2', int puntosTotales = 0 })
                await _controlador.crearAlineacion(
                  widget.idLiga,
                  widget.idUsuario,
                  idsJugadores,
                  // intento pasar formacion y puntosTotales por nombre (si el controlador los acepta)
                  // si tu controlador no soporta 'formacion', remueve ese parámetro y añade la formacion en el modelo desde el servicio.
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

  // ---------------------------
  // Confirmación genérica
  // ---------------------------
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

  // ---------------------------
  // Item alineación
  // ---------------------------
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
                        PaginaAlineacionEditarDesktop(alineacion: a),
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

  // ---------------------------
  // Build
  // ---------------------------
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
