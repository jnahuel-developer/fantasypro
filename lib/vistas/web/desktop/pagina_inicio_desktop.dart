/*
  Archivo: pagina_inicio_desktop.dart
  Descripción:
    Home del usuario final — Etapa 1:
    - Listar ligas activas
    - Buscar ligas
    - Navegar a detalles de liga
*/

import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_login_desktop.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/modelos/liga.dart';

import 'pagina_liga_detalle_desktop.dart';

class PaginaInicioDesktop extends StatefulWidget {
  const PaginaInicioDesktop({super.key});

  @override
  State<PaginaInicioDesktop> createState() => _PaginaInicioDesktopEstado();
}

class _PaginaInicioDesktopEstado extends State<PaginaInicioDesktop> {
  final ControladorLigas controladorLigas = ControladorLigas();

  bool cargando = true;
  List<Liga> ligas = [];
  final TextEditingController ctrlBuscar = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => cargando = true);

    try {
      final resultado = await controladorLigas.obtenerActivas();
      ligas = resultado.toList()
        ..sort(
          (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
        );
    } catch (e) {
      // Log simple
      debugPrint("ERROR cargar ligas activas: $e");
    }

    setState(() => cargando = false);
  }

  Future<void> buscar(String texto) async {
    setState(() => cargando = true);

    try {
      if (texto.trim().isEmpty) {
        final resultado = await controladorLigas.obtenerActivas();
        ligas = resultado.toList();
      } else {
        final resultado = await controladorLigas.buscar(texto.trim());
        ligas = resultado.toList();
      }

      ligas.sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );
    } catch (e) {
      debugPrint("ERROR buscar ligas: $e");
    }

    setState(() => cargando = false);
  }

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
                builder: (_) => PaginaLigaDetalleDesktop(liga: liga),
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
                  MaterialPageRoute(builder: (_) => const PaginaLoginDesktop()),
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
            // BUSCADOR
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
