/*
  Archivo: ui__admin__fecha__lista__desktop.dart
  Descripción:
    Lista de fechas asociadas a una liga. Permite crear nuevas fechas,
    visualizar fecha activa, listar fechas cerradas y cerrar la fecha activa.

  Dependencias:
    - modelos/fecha_liga.dart
    - modelos/liga.dart
    - controladores/controlador_fechas.dart

  Pantallas que navegan hacia esta:
    - ui__admin__liga__lista__desktop.dart

  Pantallas destino:
    - ninguna
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/controladores/controlador_fechas.dart';

class UiAdminFechaListaDesktop extends StatefulWidget {
  final Liga liga;

  const UiAdminFechaListaDesktop({super.key, required this.liga});

  @override
  State<UiAdminFechaListaDesktop> createState() =>
      _UiAdminFechaListaDesktopEstado();
}

class _UiAdminFechaListaDesktopEstado extends State<UiAdminFechaListaDesktop> {
  /// Controlador encargado de administrar fechas de liga.
  final ControladorFechas _controlador = ControladorFechas();

  bool cargando = true;

  /// Almacena la fecha activa (si existe).
  FechaLiga? fechaActiva;

  /// Almacena la lista de fechas cerradas.
  List<FechaLiga> fechasCerradas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Recupera todas las fechas de la liga, separa la activa y las cerradas,
      y refresca el estado visual.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _cargar() async {
    setState(() => cargando = true);

    final lista = await _controlador.obtenerPorLiga(widget.liga.id);

    // Buscar fecha activa sin forzar un valor nulo en firstWhere.
    final candidatasActiva = lista
        .where((f) => f.activa && !f.cerrada)
        .toList();
    fechaActiva = candidatasActiva.isEmpty ? null : candidatasActiva.first;

    fechasCerradas = lista.where((f) => f.cerrada).toList()
      ..sort((a, b) => a.numeroFecha.compareTo(b.numeroFecha));

    setState(() => cargando = false);
  }

  /*
    Nombre: _confirmarCrearFecha
    Descripción:
      Muestra un diálogo previo a la creación de una nueva fecha.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _confirmarCrearFecha() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Crear nueva fecha"),
        content: const Text("¿Desea abrir una nueva fecha para esta liga?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Crear"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await _controlador.crearFecha(widget.liga.id);
    _cargar();
  }

  /*
    Nombre: _cerrarFecha
    Descripción:
      Cierra la fecha activa si existe, previa confirmación.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _cerrarFecha() async {
    if (fechaActiva == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cerrar fecha"),
        content: Text(
          "¿Desea cerrar la fecha ${fechaActiva!.numeroFecha}? Esta acción no puede revertirse.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    await _controlador.cerrarFecha(fechaActiva!);
    _cargar();
  }

  /*
    Nombre: _itemFechaCerrada
    Descripción:
      Renderiza una fecha cerrada dentro de la lista.
    Entradas:
      - FechaLiga f
    Salidas:
      - Widget
  */
  Widget _itemFechaCerrada(FechaLiga f) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text("Fecha ${f.numeroFecha} — ${f.nombre}"),
        subtitle: const Text("Estado: Cerrada"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.liga.totalFechasTemporada;
    final creadas = widget.liga.fechasCreadas;

    final puedeCrear = fechaActiva == null && creadas < total;

    return Scaffold(
      appBar: AppBar(
        title: Text("Fechas — ${widget.liga.nombre}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      floatingActionButton: puedeCrear
          ? FloatingActionButton(
              onPressed: _confirmarCrearFecha,
              child: const Icon(Icons.add),
            )
          : null,

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),

                // Fecha activa
                if (fechaActiva != null)
                  Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      title: Text(
                        "Fecha activa — ${fechaActiva!.nombre}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Número: ${fechaActiva!.numeroFecha}"),
                      trailing: ElevatedButton(
                        onPressed: _cerrarFecha,
                        child: const Text("Cerrar fecha"),
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "No hay fecha activa",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                const Divider(),

                // Fechas cerradas
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    "Fechas cerradas",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),

                Expanded(
                  child: ListView(
                    children: fechasCerradas.map(_itemFechaCerrada).toList(),
                  ),
                ),
              ],
            ),
    );
  }
}
