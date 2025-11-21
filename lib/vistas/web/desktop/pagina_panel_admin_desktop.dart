/*
  Archivo: pagina_panel_admin_desktop.dart
  Descripción:
    Panel principal para administradores.
    Desde aquí se accede a la administración de ligas.
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_ligas_admin_desktop.dart';

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
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text("Administrar Ligas"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaginaLigasAdminDesktop(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
