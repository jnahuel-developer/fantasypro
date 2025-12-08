/*
  Archivo: ui__usuario__dashboard__desktop.dart
  Descripción:
    Pantalla inicial para usuarios finales no administradores. Presenta
    accesos rápidos para crear equipos y revisar resultados por fecha.

  Dependencias:
    - firebase_auth.dart
    - modelos/liga.dart
    - vistas/ui__usuario__inicio__lista__desktop.dart
    - vistas/ui__usuario__resultados_por_fecha__desktop.dart
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fantasypro/modelos/liga.dart';

import 'ui__usuario__inicio__lista__desktop.dart';
import 'ui__usuario__resultados_por_fecha__desktop.dart';

class UiUsuarioDashboardDesktop extends StatelessWidget {
  /// Liga sobre la cual se revisarán resultados.
  final Liga liga;

  /// Usuario autenticado.
  final User usuario;

  const UiUsuarioDashboardDesktop({
    super.key,
    required this.liga,
    required this.usuario,
  });

  /*
    Nombre: _botonAccion
    Descripción:
      Construye un botón elevado con estilo uniforme para las acciones
      principales del dashboard.
    Entradas:
      - texto (String): etiqueta del botón.
      - onPressed (VoidCallback): acción a ejecutar.
    Salidas:
      - Widget
  */
  Widget _botonAccion(String texto, VoidCallback onPressed) {
    return SizedBox(
      width: 260,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Text(texto, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FantasyPro — Inicio"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Bienvenido a FantasyPro",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _botonAccion(
              "Crear equipos",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UiUsuarioInicioListaDesktop(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _botonAccion(
              "Ver resultados",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UiUsuarioResultadosPorFechaDesktop(
                      liga: liga,
                      usuario: usuario,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
