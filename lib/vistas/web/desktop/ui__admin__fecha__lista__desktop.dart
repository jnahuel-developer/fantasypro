/*
  Archivo: ui__admin__fecha__lista__desktop.dart
  Descripción:
    Lista de fechas asociadas a una liga. Permite crear nuevas fechas,
    visualizar fecha activa, listar fechas cerradas, cerrar fecha activa,
    y cargar puntajes reales (mod0016).

  Dependencias:
    - modelos/fecha_liga.dart
    - modelos/liga.dart
    - controladores/controlador_fechas.dart
    - ui__admin__puntajes_reales__lista__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/fecha_liga.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/controladores/controlador_fechas.dart';
import 'ui__admin__puntajes_reales__lista__desktop.dart';

class UiAdminFechaListaDesktop extends StatefulWidget {
  final Liga liga;

  const UiAdminFechaListaDesktop({super.key, required this.liga});

  @override
  State<UiAdminFechaListaDesktop> createState() =>
      _UiAdminFechaListaDesktopEstado();
}

class _UiAdminFechaListaDesktopEstado extends State<UiAdminFechaListaDesktop> {
  final ControladorFechas _controlador = ControladorFechas();

  bool cargando = true;

  FechaLiga? fechaActiva;
  List<FechaLiga> fechasCerradas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Recupera todas las fechas de la liga, separa activa y cerradas.
  */
  Future<void> _cargar() async {
    setState(() => cargando = true);

    final lista = await _controlador.obtenerPorLiga(widget.liga.id);

    final candidatas = lista.where((f) => f.activa && !f.cerrada).toList();
    fechaActiva = candidatas.isEmpty ? null : candidatas.first;

    fechasCerradas = lista.where((f) => f.cerrada).toList()
      ..sort((a, b) => a.numeroFecha.compareTo(b.numeroFecha));

    setState(() => cargando = false);
  }

  /*
    Nombre: _cerrarFecha
    Descripción:
      Intenta cerrar la fecha activa. Muestra mensajes según resultado.
  */
  Future<void> _cerrarFecha() async {
    if (fechaActiva == null) return;

    final ok = await showDialog<bool>(
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

    if (ok != true) return;

    try {
      await _controlador.cerrarFecha(fechaActiva!);

      // EXITO
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fecha cerrada exitosamente")),
        );
      }

      _cargar();
    } catch (e) {
      // ERROR: faltan puntajes
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("No se puede cerrar la fecha"),
            content: const Text(
              "Faltan puntajes por cargar. Complete los puntajes y vuelva a intentarlo.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      }
    }
  }

  /*
    Nombre: _confirmarCrearFecha
    Descripción:
      Diálogo de confirmación previo a crear una nueva fecha.
  */
  Future<void> _confirmarCrearFecha() async {
    final ok = await showDialog<bool>(
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

    if (ok != true) return;

    await _controlador.crearFecha(widget.liga.id);
    _cargar();
  }

  /*
    Nombre: _itemFechaCerrada
    Descripción:
      Renderiza un item de la lista de fechas cerradas.
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
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      UiAdminPuntajesRealesListaDesktop(
                                        liga: widget.liga,
                                        fecha: fechaActiva!,
                                      ),
                                ),
                              );
                            },
                            child: const Text("Cargar puntajes"),
                          ),
                          ElevatedButton(
                            onPressed: _cerrarFecha,
                            child: const Text("Cerrar fecha"),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      "No hay fecha activa",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),

                const Divider(),

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
