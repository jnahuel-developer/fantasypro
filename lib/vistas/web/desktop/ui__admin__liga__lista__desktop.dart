/*
  Archivo: ui__admin__liga__lista__desktop.dart
  Descripción:
    Lista de ligas para administradores. Permite crear, activar, archivar y
    eliminar ligas, además de navegar hacia la gestión de equipos reales,
    participaciones y fechas.

  Dependencias:
    - modelos/liga.dart
    - controladores/controlador_ligas.dart
    - ui__admin__equipo_real__lista__desktop.dart
    - ui__admin__participacion__lista__desktop.dart
    - ui__admin__fecha__lista__desktop.dart

  Pantallas que navegan hacia esta:
    - ui__admin__panel__dashboard__desktop.dart

  Pantallas destino:
    - ui__admin__equipo_real__lista__desktop.dart
    - ui__admin__participacion__lista__desktop.dart
    - ui__admin__fecha__lista__desktop.dart
*/

import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:flutter/material.dart';
import 'ui__admin__equipo_real__lista__desktop.dart';
import 'ui__admin__participacion__lista__desktop.dart';
import 'ui__admin__fecha__lista__desktop.dart';

class UiAdminLigaListaDesktop extends StatefulWidget {
  const UiAdminLigaListaDesktop({super.key});

  @override
  State<UiAdminLigaListaDesktop> createState() =>
      _UiAdminLigaListaDesktopEstado();
}

class _UiAdminLigaListaDesktopEstado extends State<UiAdminLigaListaDesktop> {
  /// Controlador de ligas.
  final ControladorLigas _controlador = ControladorLigas();

  bool cargando = true;
  List<Liga> activas = [];
  List<Liga> archivadas = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  /*
    Nombre: _cargar
    Descripción:
      Obtiene todas las ligas y las separa en activas y archivadas.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _cargar() async {
    setState(() => cargando = true);

    final todas = await _controlador.obtenerTodas();

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

  /*
    Nombre: _crearLiga
    Descripción:
      Muestra diálogo para crear una liga nueva, incluyendo validación del
      total de fechas de la temporada.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _crearLiga() async {
    final ctrlNombre = TextEditingController();
    final ctrlDesc = TextEditingController();
    final ctrlTotalFechas = TextEditingController(text: "38");

    String? error;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, actualizar) => AlertDialog(
          title: const Text(TextosApp.ADMIN_LIGA_LISTA_DESKTOP_DIALOGO_CREAR_TITULO),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: ctrlNombre,
                decoration: const InputDecoration(
                  labelText: TextosApp.ADMIN_LIGA_LISTA_DESKTOP_LABEL_NOMBRE,
                ),
              ),
              TextField(
                controller: ctrlDesc,
                decoration: const InputDecoration(
                  labelText: TextosApp.ADMIN_LIGA_LISTA_DESKTOP_LABEL_DESCRIPCION,
                ),
              ),
              TextField(
                controller: ctrlTotalFechas,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      TextosApp.ADMIN_LIGA_LISTA_DESKTOP_LABEL_TOTAL_FECHAS,
                  errorText: error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text(TextosApp.COMUN_BOTON_CANCELAR),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text(TextosApp.COMUN_BOTON_CREAR),
              onPressed: () async {
                final nombre = ctrlNombre.text.trim();
                final desc = ctrlDesc.text.trim();
                final tf = int.tryParse(ctrlTotalFechas.text.trim()) ?? 0;

                if (nombre.isEmpty) {
                  actualizar(() =>
                      error = TextosApp.ADMIN_LIGA_LISTA_DESKTOP_ERROR_NOMBRE_OBLIGATORIO);
                  return;
                }
                if (tf < 34 || tf > 50) {
                  actualizar(() =>
                      error = TextosApp.ADMIN_LIGA_LISTA_DESKTOP_ERROR_RANGO_FECHAS);
                  return;
                }

                await _controlador.crearLiga(
                  nombre,
                  desc,
                  totalFechasTemporada: tf,
                );

                if (context.mounted) Navigator.pop(context);
                _cargar();
              },
            ),
          ],
        ),
      ),
    );
  }

  /*
    Nombre: _item
    Descripción:
      Renderiza una liga dentro de las listas activa/archivada.
    Entradas:
      - Liga l
    Salidas: Widget
  */
  Widget _item(Liga l) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: ListTile(
        title: Text(l.nombre),
        subtitle: Text(
          TextosApp.ADMIN_LIGA_LISTA_DESKTOP_SUBTITULO_FECHAS
              .replaceFirst("{CREADAS}", l.fechasCreadas.toString())
              .replaceFirst("{TOTAL}", l.totalFechasTemporada.toString()),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Participaciones
            IconButton(
              icon: const Icon(Icons.supervised_user_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminParticipacionListaDesktop(liga: l),
                  ),
                ).then((_) => _cargar());
              },
            ),

            // Equipos reales
            IconButton(
              icon: const Icon(Icons.groups),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminEquipoRealListaDesktop(liga: l),
                  ),
                );
              },
            ),

            // Gestionar fechas
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiAdminFechaListaDesktop(liga: l),
                  ),
                );
              },
            ),

            // Archivar / activar
            IconButton(
              icon: Icon(l.activa ? Icons.archive : Icons.unarchive),
              onPressed: () async {
                if (l.activa) {
                  await _controlador.archivar(l.id);
                } else {
                  await _controlador.activar(l.id);
                }
                _cargar();
              },
            ),

            // Eliminar
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await _controlador.eliminar(l.id);
                _cargar();
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
        title: const Text(TextosApp.ADMIN_LIGA_LISTA_DESKTOP_TITULO_APPBAR),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                TextosApp.ADMIN_LIGA_LISTA_DESKTOP_TEXTO_GESTION,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _crearLiga,
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
                        TextosApp.ADMIN_LIGA_LISTA_DESKTOP_TITULO_ACTIVAS
                            .replaceFirst(
                          "{CANT}",
                          activas.length.toString(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(children: activas.map(_item).toList()),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        TextosApp.ADMIN_LIGA_LISTA_DESKTOP_TITULO_ARCHIVADAS
                            .replaceFirst(
                          "{CANT}",
                          archivadas.length.toString(),
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: archivadas.map(_item).toList(),
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
