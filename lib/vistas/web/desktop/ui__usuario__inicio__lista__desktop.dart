/*
  Archivo: ui__usuario__inicio__lista__desktop.dart
  Descripción:
    Pantalla principal del usuario final donde se listan las ligas activas.
    Permite buscar ligas y navegar al detalle para unirse.
  Dependencias:
    - modelos/liga.dart
    - controladores/controlador_ligas.dart
    - servicios/servicio_autenticacion.dart
  Pantallas que navegan hacia esta:
    - ui__comun__autenticacion__login__desktop.dart
  Pantallas destino:
    - ui__usuario__liga__detalle__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/modelos/liga.dart';

import 'ui__usuario__liga__detalle__desktop.dart';
import 'ui__comun__autenticacion__login__desktop.dart';

class UiUsuarioInicioListaDesktop extends StatefulWidget {
  const UiUsuarioInicioListaDesktop({super.key});

  @override
  State<UiUsuarioInicioListaDesktop> createState() =>
      _UiUsuarioInicioListaDesktopEstado();
}

class _UiUsuarioInicioListaDesktopEstado
    extends State<UiUsuarioInicioListaDesktop> {
  /// Controlador de ligas.
  final ControladorLigas controladorLigas = ControladorLigas();

  bool cargando = true;
  List<Liga> ligas = [];
  final TextEditingController ctrlBuscar = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  /*
    Nombre: cargar
    Descripción:
      Obtiene y ordena todas las ligas activas.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> cargar() async {
    setState(() => cargando = true);

    try {
      final resultado = await controladorLigas.obtenerActivas();
      ligas = resultado.toList()
        ..sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
        );
    } catch (_) {}

    setState(() => cargando = false);
  }

  /*
    Nombre: buscar
    Descripción:
      Realiza búsqueda de ligas según texto ingresado.
    Entradas: texto de búsqueda
    Salidas: Future<void>
  */
  Future<void> buscar(String texto) async {
    setState(() => cargando = true);

    try {
      if (texto.trim().isEmpty) {
        ligas = (await controladorLigas.obtenerActivas()).toList();
      } else {
        ligas = (await controladorLigas.buscar(texto.trim())).toList();
      }

      ligas.sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );
    } catch (_) {}

    setState(() => cargando = false);
  }

  /*
    Nombre: itemLiga
    Descripción:
      Construye la tarjeta visual de una liga en la lista.
    Entradas: Liga liga
    Salidas: Widget
  */
  Widget itemLiga(Liga liga) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text(liga.nombre, style: const TextStyle(fontSize: 18)),
        subtitle: Text("Temporada: ${liga.temporada}"),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UiUsuarioLigaDetalleDesktop(liga: liga),
              ),
            ).then((_) => cargar());
          },
          child: const Text("Unirse"),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FantasyPro — Ligas activas"),
        actions: [
          IconButton(
            tooltip: "Cerrar sesión",
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final servicio = ServicioAutenticacion();
              await servicio.cerrarSesion();

              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UiComunAutenticacionLoginDesktop(),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: ctrlBuscar,
              decoration: InputDecoration(
                labelText: "Buscar ligas",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => buscar(ctrlBuscar.text),
                ),
              ),
              onSubmitted: buscar,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : ligas.isEmpty
                  ? const Center(child: Text("No hay ligas disponibles."))
                  : ListView(children: ligas.map(itemLiga).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
