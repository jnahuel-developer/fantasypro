/*
  Archivo: pagina_registro_desktop.dart
  Descripción:
    Pantalla de alta de usuario.
*/

import 'package:flutter/material.dart';
import 'package:fantasypro/textos/textos_app.dart';
import 'package:fantasypro/modelos/roles.dart';
import '../../../servicios/firebase/servicio_autenticacion.dart';
import '../../../servicios/utilidades/servicio_log.dart';

class PaginaRegistroDesktop extends StatefulWidget {
  const PaginaRegistroDesktop({super.key});

  @override
  State<PaginaRegistroDesktop> createState() => _PaginaRegistroDesktopEstado();
}

class _PaginaRegistroDesktopEstado extends State<PaginaRegistroDesktop> {
  final ServicioAutenticacion _auth = ServicioAutenticacion();
  final ServicioLog _log = ServicioLog();

  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  RolUsuario rolSeleccionado = RolUsuario.usuario;
  String mensaje = "";

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
                  setState(() => rolSeleccionado = v!);
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
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

                    _log.informacion(
                      "${TextosApp.LOG_REGISTRO_USUARIO_CREADO} $uid",
                    );
                  } else {
                    setState(() {
                      mensaje = TextosApp.REGISTRO_DESKTOP_MENSAJE_ERROR;
                    });
                  }
                },
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
