/*
  Archivo: pagina_inicio_mobile.dart
  Descripción: Pantalla inicial para la versión Web Mobile.
*/

import 'package:flutter/material.dart';

class PaginaInicioMobile extends StatelessWidget {
  final Map<String, String> textos;

  const PaginaInicioMobile({super.key, required this.textos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          textos["TEXTO_BIENVENIDA"] ?? "Cargando...",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
