/*
  Archivo: ui__comun__autenticacion__registro__desktop.dart
  Descripción:
    Pantalla de registro de usuario en versión Desktop.
    Permite:
      - Ingresar nombre, email, password
      - Seleccionar rol (usuario / admin)
      - Crear usuario mediante ServicioAutenticacion

  Dependencias:
    - modelos/roles.dart
    - textos/textos_app.dart
    - servicios/firebase/servicio_autenticacion.dart
    - servicios/utilidades/servicio_log.dart

  Pantallas que navegan hacia esta:
    - ui__comun__autenticacion__login__desktop.dart
  
  Pantallas destino:
    - ninguna
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:fantasypro/modelos/roles.dart';
import 'package:fantasypro/servicios/firebase/servicio_autenticacion.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';

class UiComunAutenticacionRegistroDesktop extends StatefulWidget {
  const UiComunAutenticacionRegistroDesktop({super.key});

  @override
  State<UiComunAutenticacionRegistroDesktop> createState() =>
      _UiComunAutenticacionRegistroDesktopEstado();
}

class _UiComunAutenticacionRegistroDesktopEstado
    extends State<UiComunAutenticacionRegistroDesktop> {
  /// Servicios
  final ServicioAutenticacion _auth = ServicioAutenticacion();
  final ServicioLog _log = ServicioLog();

  /// Controllers
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  RolUsuario rolSeleccionado = RolUsuario.usuario;

  String mensaje = "";

  /*
    Nombre: _registrar
    Descripción:
      Ejecuta el registro usando el servicio de autenticación.
    Entradas: ninguna
    Salidas: Future<void>
  */
  Future<void> _registrar() async {
    final uid = await _auth.registrarUsuario(
      _email.text.trim(),
      _password.text.trim(),
      _nombre.text.trim(),
      rolSeleccionado.valorDB,
    );

    if (uid != null) {
      setState(() {
        mensaje = TextosApp.REGISTRO_DESKTOP_MENSAJE_OK;
      });

      _log.informacion("${TextosApp.LOG_REGISTRO_USUARIO_CREADO} $uid");
    } else {
      setState(() {
        mensaje = TextosApp.REGISTRO_DESKTOP_MENSAJE_ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TextosApp.REGISTRO_DESKTOP_TITULO),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: TextosApp.REGISTRO_DESKTOP_TOOLTIP_VOLVER,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nombre,
                decoration: const InputDecoration(
                  labelText: TextosApp.REGISTRO_DESKTOP_INPUT_NOMBRE,
                ),
              ),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: TextosApp.REGISTRO_DESKTOP_INPUT_CORREO,
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: TextosApp.REGISTRO_DESKTOP_INPUT_PASSWORD,
                ),
              ),
              const SizedBox(height: 20),

              DropdownButton<RolUsuario>(
                value: rolSeleccionado,
                items: [
                  DropdownMenuItem(
                    value: RolUsuario.usuario,
                    child: Text(RolUsuario.usuario.textoVisible),
                  ),
                  DropdownMenuItem(
                    value: RolUsuario.admin,
                    child: Text(RolUsuario.admin.textoVisible),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => rolSeleccionado = v);
                  }
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _registrar,
                child: const Text(TextosApp.REGISTRO_DESKTOP_BOTON_REGISTRAR),
              ),

              const SizedBox(height: 20),
              Text(mensaje),
            ],
          ),
        ),
      ),
    );
  }
}
