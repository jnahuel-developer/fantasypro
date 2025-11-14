/*
  Archivo: pagina_inicio_desktop.dart
  Descripción: Pantalla inicial para la versión Web Desktop.
*/

import 'package:flutter/material.dart';

class PaginaInicioDesktop extends StatelessWidget {
  final Map<String, String> textos;

  const PaginaInicioDesktop({super.key, required this.textos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          textos["TEXTO_BIENVENIDA"] ?? "Cargando...",
          style: const TextStyle(fontSize: 32),
        ),
      ),
    );
  }
}
