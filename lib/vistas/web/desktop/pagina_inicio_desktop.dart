/*
  Archivo: pagina_inicio_desktop.dart
  Descripción:
    Pantalla de inicio para usuarios finales.
    Ahora incluye botón de cierre de sesión.
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaginaInicioDesktop extends StatelessWidget {
  final Map<String, String> textos;

  const PaginaInicioDesktop({super.key, required this.textos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FantasyPro - Usuario"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Cerrar sesión",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          textos["TEXTO_BIENVENIDA"] ?? "Bienvenido",
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
