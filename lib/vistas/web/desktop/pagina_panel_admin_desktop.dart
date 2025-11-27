/*
  Archivo: pagina_panel_admin_desktop.dart
  Descripción:
    Panel principal para administradores.
    Desde aquí se accede a la administración de ligas.
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:fantasypro/vistas/web/desktop/pagina_ligas_admin_desktop.dart';

class PaginaPanelAdminDesktop extends StatelessWidget {
  const PaginaPanelAdminDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextosApp.ADMIN_PANEL_DESKTOP_TITULO),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: TextosApp.ADMIN_PANEL_DESKTOP_TOOLTIP_LOGOUT,
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
              // Botón: administrar ligas
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaginaLigasAdminDesktop(),
                    ),
                  );
                },
                child: const Text(TextosApp.ADMIN_PANEL_DESKTOP_BOTON_LIGAS),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
