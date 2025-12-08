/*
  Archivo: ui__usuario__appbar__desktop.dart
  Descripción:
    Barra de aplicación reutilizable para las pantallas de usuario final
    en Web Desktop. Incluye acciones de navegación al dashboard, cierre
    de sesión y botón de retroceso opcional.

  Dependencias:
    - servicio_autenticacion.dart
    - ui__comun__autenticacion__login__desktop.dart
    - ui__usuario__dashboard__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';

import '../ui__comun__autenticacion__login__desktop.dart';
import '../ui__usuario__dashboard__desktop.dart';

class UiUsuarioAppBarDesktop extends StatelessWidget
    implements PreferredSizeWidget {
  final String titulo;
  final bool mostrarBotonVolver;
  final bool mostrarBotonHome;
  final bool mostrarBotonLogout;

  const UiUsuarioAppBarDesktop({
    super.key,
    required this.titulo,
    this.mostrarBotonVolver = true,
    this.mostrarBotonHome = true,
    this.mostrarBotonLogout = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /*
    Nombre: _logout
    Descripción:
      Cierra la sesión del usuario actual y redirige a la pantalla de login.
    Entradas:
      - context (BuildContext)
    Salidas:
      - Future<void>
  */
  Future<void> _logout(BuildContext context) async {
    final servicio = ServicioAutenticacion();
    await servicio.cerrarSesion();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const UiComunAutenticacionLoginDesktop(),
      ),
      (route) => false,
    );
  }

  /*
    Nombre: _irAlDashboard
    Descripción:
      Navega al dashboard inicial de usuario, limpiando la pila de navegación.
    Entradas:
      - context (BuildContext)
    Salidas:
      - void
  */
  void _irAlDashboard(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const UiUsuarioDashboardDesktop(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: mostrarBotonVolver && Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(titulo),
      actions: [
        if (mostrarBotonHome)
          IconButton(
            tooltip: "Ir al inicio",
            icon: const Icon(Icons.home),
            onPressed: () => _irAlDashboard(context),
          ),
        if (mostrarBotonLogout)
          IconButton(
            tooltip: "Cerrar sesión",
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        const SizedBox(width: 8),
      ],
    );
  }
}
