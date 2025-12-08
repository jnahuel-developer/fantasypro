/*
  Archivo: controlador_router.dart
  Descripción:
    Router principal de la aplicación.
    - Escucha cambios de FirebaseAuth.instance.authStateChanges()
    - Cuando hay usuario → consulta ServicioAutenticacion.esAdmin(uid)
    - Redirige a la vista correspondiente (admin / usuario / login)
*/

import 'package:fantasypro/vistas/web/desktop/ui__admin__panel__dashboard__desktop.dart';
import 'package:fantasypro/vistas/web/desktop/ui__comun__autenticacion__login__desktop.dart';
import 'package:fantasypro/vistas/web/desktop/ui__usuario__dashboard__desktop.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../servicios/firebase/servicio_autenticacion.dart';
import '../textos/textos_app.dart';

class ControladorRouter extends StatelessWidget {
  const ControladorRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicioAutenticacion auth = ServicioAutenticacion();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        // ---------------------------------------------------------------------
        // Estado de carga inicial
        // ---------------------------------------------------------------------
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final User? usuario = snapshot.data;

        // ---------------------------------------------------------------------
        // No hay usuario autenticado → ir al login
        // ---------------------------------------------------------------------
        if (usuario == null) {
          return const UiComunAutenticacionLoginDesktop();
        }

        // ---------------------------------------------------------------------
        // Usuario autenticado → comprobar si es admin mediante ServicioAutenticacion
        // ---------------------------------------------------------------------
        return FutureBuilder<bool>(
          future: auth.esAdmin(usuario.uid),
          builder: (_, adminSnap) {
            if (adminSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // En caso de error o resultado false → tratar como usuario normal
            if (adminSnap.hasError) {
              return Scaffold(
                body: Center(child: Text(TextosApp.ERROR_ROL_DESCONOCIDO)),
              );
            }

            final bool esAdmin = adminSnap.data ?? false;

            if (esAdmin) {
              return const UiAdminPanelDashboardDesktop();
            } else {
              return const UiUsuarioDashboardDesktop();
            }
          },
        );
      },
    );
  }
}
