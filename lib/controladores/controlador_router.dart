/*
  Archivo: controlador_router.dart
  Descripción:
    Control router de la aplicación.
    - Escucha cambios de FirebaseAuth.instance.authStateChanges()
    - Cuando hay usuario → consulta Firestore para obtener el rol
    - Redirige a la vista correspondiente (admin / usuario / login)
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../vistas/web/desktop/pagina_login_desktop.dart';
import '../vistas/web/desktop/pagina_panel_admin_desktop.dart';
import '../vistas/web/desktop/pagina_inicio_desktop.dart';

class ControladorRouter extends StatelessWidget {
  const ControladorRouter({super.key});

  Future<String?> obtenerRol(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return doc.data()!["rol"] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final usuario = snapshot.data;

        // No hay usuario logueado
        if (usuario == null) {
          return const PaginaLoginDesktop();
        }

        // Usuario logueado → obtener rol
        return FutureBuilder(
          future: obtenerRol(usuario.uid),
          builder: (context, rolSnap) {
            if (!rolSnap.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final rol = rolSnap.data;

            if (rol == "admin") {
              return const PaginaPanelAdminDesktop();
            } else {
              return PaginaInicioDesktop();
            }
          },
        );
      },
    );
  }
}
