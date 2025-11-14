/*
  Archivo: pagina_panel_admin_desktop.dart
  Descripción:
    Panel principal para administradores.
    (Placeholder – se completará en mod0005)
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaginaPanelAdminDesktop extends StatelessWidget {
  const PaginaPanelAdminDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel Administrador"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const Center(child: Text("Bienvenido al panel de administrador.")),
    );
  }
}
