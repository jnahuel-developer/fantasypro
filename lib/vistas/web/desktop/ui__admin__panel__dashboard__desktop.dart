/*
  Archivo: ui__admin__panel__dashboard__desktop.dart
  Descripción:
    Panel principal para administradores en versión Desktop.
    Desde aquí se accede a la administración de ligas.
  
  Dependencias:
    - firebase_auth/FirebaseAuth
    - textos/textos_app.dart
    - ui__admin__liga__lista__desktop.dart
  
  Pantallas que navegan hacia esta:
    - ui__comun__autenticacion__login__desktop.dart
  
  Pantallas destino:
    - ui__admin__liga__lista__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasypro/textos/textos_app.dart';

import 'ui__admin__liga__lista__desktop.dart';

class UiAdminPanelDashboardDesktop extends StatelessWidget {
  const UiAdminPanelDashboardDesktop({super.key});

  /*
    Nombre: _logout
    Descripción:
      Cierra la sesión actual del administrador.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextosApp.ADMIN_PANEL_DESKTOP_TITULO),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: TextosApp.ADMIN_PANEL_DESKTOP_TOOLTIP_LOGOUT,
            onPressed: _logout,
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UiAdminLigaListaDesktop(),
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
