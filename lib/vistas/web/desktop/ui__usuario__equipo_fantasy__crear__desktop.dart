/*
  Archivo: ui__usuario__equipo_fantasy__crear__desktop.dart
  Descripción:
    Pantalla utilizada por el usuario final para crear su Equipo Fantasy dentro
    de una liga específica.

  Dependencias:
    - modelos/equipo_fantasy.dart
    - controladores/controlador_equipo_fantasy.dart
    - servicios/firebase/servicio_autenticacion.dart

  Pantallas que navegan hacia esta:
    - ui__usuario__liga__detalle__desktop.dart

  Pantallas destino:
    - ui__usuario__inicio__lista__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';
import 'package:fantasypro/controladores/controlador_equipo_fantasy.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'ui__usuario__inicio__lista__desktop.dart';

class UiUsuarioEquipoFantasyCrearDesktop extends StatefulWidget {
  final Liga liga;

  const UiUsuarioEquipoFantasyCrearDesktop({super.key, required this.liga});

  @override
  State<UiUsuarioEquipoFantasyCrearDesktop> createState() =>
      _UiUsuarioEquipoFantasyCrearDesktopEstado();
}

class _UiUsuarioEquipoFantasyCrearDesktopEstado
    extends State<UiUsuarioEquipoFantasyCrearDesktop> {
  /// Controlador de equipos fantasy.
  final ControladorEquipoFantasy _controladorFantasy =
      ControladorEquipoFantasy();

  /// Servicio de autenticación para obtener ID del usuario.
  final ServicioAutenticacion _auth = ServicioAutenticacion();

  final TextEditingController _ctrlNombre = TextEditingController();

  bool cargando = false;
  String? mensaje;

  /*
    Nombre: _crearEquipo
    Descripción:
      Crea un equipo fantasy para el usuario logueado y navega hacia la pantalla
      principal de inicio. Maneja validaciones mínimas y estados de carga.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _crearEquipo() async {
    final nombre = _ctrlNombre.text.trim();

    if (nombre.isEmpty) {
      setState(() => mensaje = "El nombre no puede estar vacío.");
      return;
    }

    setState(() {
      cargando = true;
      mensaje = null;
    });

    final usuario = _auth.obtenerUsuarioActual();
    if (usuario == null) {
      setState(() {
        mensaje = "No hay usuario autenticado.";
        cargando = false;
      });
      return;
    }

    try {
      await _controladorFantasy.crearEquipoParaLiga(
        usuario.uid,
        widget.liga.id,
        nombre,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UiUsuarioInicioListaDesktop()),
      );
    } catch (e) {
      setState(() {
        mensaje = "Error al crear el equipo.";
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear equipo fantasy")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Liga: ${widget.liga.nombre}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                if (mensaje != null)
                  Text(mensaje!, style: const TextStyle(color: Colors.red)),

                TextField(
                  controller: _ctrlNombre,
                  decoration: const InputDecoration(
                    labelText: "Nombre del equipo",
                  ),
                ),
                const SizedBox(height: 20),

                cargando
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _crearEquipo,
                        child: const Text("Crear equipo"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
