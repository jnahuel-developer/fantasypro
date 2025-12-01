/*
  Archivo: ui__comun__autenticacion__login__desktop.dart
  Descripción:
    Pantalla de inicio de sesión para Web Desktop.
    Permite ingresar email y contraseña, ejecutar login y navegar a registro.

  Dependencias:
    - textos/textos_app.dart
    - servicios/firebase/servicio_autenticacion.dart
    - ui__comun__autenticacion__registro__desktop.dart

  Pantallas que navegan hacia esta:
    - (según flujo general: router / main)

  Pantallas destino:
    - ui__comun__autenticacion__registro__desktop.dart
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';

import 'ui__comun__autenticacion__registro__desktop.dart';

class UiComunAutenticacionLoginDesktop extends StatefulWidget {
  const UiComunAutenticacionLoginDesktop({super.key});

  @override
  State<UiComunAutenticacionLoginDesktop> createState() =>
      _UiComunAutenticacionLoginDesktopEstado();
}

class _UiComunAutenticacionLoginDesktopEstado
    extends State<UiComunAutenticacionLoginDesktop> {
  /// Servicio de autenticación.
  final ServicioAutenticacion _auth = ServicioAutenticacion();

  /// Controller para email.
  final TextEditingController _email = TextEditingController();

  /// Controller para contraseña.
  final TextEditingController _pass = TextEditingController();

  /// Mensaje informativo de resultado de login.
  String mensaje = "";

  /*
    Nombre: _iniciarSesion
    Descripción:
      Ejecuta el inicio de sesión con email y password,
      y actualiza el mensaje de resultado.
    Entradas:
      - ninguna
    Salidas:
      - Future<void>
  */
  Future<void> _iniciarSesion() async {
    final user = await _auth.iniciarSesion(
      _email.text.trim(),
      _pass.text.trim(),
    );

    setState(() {
      if (user != null) {
        mensaje = TextosApp.LOGIN_DESKTOP_MENSAJE_LOGIN_OK.replaceAll(
          "{UID}",
          user.uid,
        );
      } else {
        mensaje = TextosApp.LOGIN_DESKTOP_MENSAJE_LOGIN_ERROR;
      }
    });
  }

  /*
    Nombre: _irARegistro
    Descripción:
      Navega a la pantalla de registro de usuario.
    Entradas:
      - ninguna
    Salidas:
      - void
  */
  void _irARegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UiComunAutenticacionRegistroDesktop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                TextosApp.LOGIN_DESKTOP_TITULO,
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),

              // Email
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: TextosApp.LOGIN_DESKTOP_INPUT_EMAIL,
                ),
              ),

              // Password
              TextField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: TextosApp.LOGIN_DESKTOP_INPUT_PASSWORD,
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _iniciarSesion,
                child: const Text(TextosApp.LOGIN_DESKTOP_BOTON_INICIAR),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: _irARegistro,
                child: const Text(TextosApp.LOGIN_DESKTOP_BOTON_REGISTRAR),
              ),

              const SizedBox(height: 20),

              Text(mensaje, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
