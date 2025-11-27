/*
  Archivo: pagina_inicio_desktop.dart
  Descripción:
    Pantalla de inicio para usuarios finales.
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasypro/textos/textos_app.dart';

class PaginaInicioDesktop extends StatelessWidget {
  const PaginaInicioDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextosApp.INICIO_DESKTOP_APPBAR_TITULO),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: TextosApp.INICIO_DESKTOP_TOOLTIP_CERRAR_SESION,
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          TextosApp.INICIO_DESKTOP_TEXTO_BIENVENIDA,
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
