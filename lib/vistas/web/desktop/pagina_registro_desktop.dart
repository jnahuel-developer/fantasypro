/*
  Archivo: pagina_registro_desktop.dart
  Descripción:
    Pantalla de alta de usuario.
    Permite registrar usuarios con nombre, email, contraseña y rol.
    (Por ahora habilitado para todos; en el futuro solo para admins).
*/

import 'package:flutter/material.dart';
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
  String rolSeleccionado = "usuario";
  String mensaje = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar usuario")),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nombre,
                decoration: const InputDecoration(labelText: "Nombre completo"),
              ),
              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Correo"),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),

              const SizedBox(height: 20),

              DropdownButton<String>(
                value: rolSeleccionado,
                items: const [
                  DropdownMenuItem(value: "usuario", child: Text("Usuario")),
                  DropdownMenuItem(
                    value: "admin",
                    child: Text("Administrador"),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    rolSeleccionado = v!;
                  });
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  final uid = await _auth.registrarUsuario(
                    _email.text.trim(),
                    _password.text.trim(),
                    _nombre.text.trim(),
                    rolSeleccionado,
                  );

                  if (uid != null) {
                    setState(() {
                      mensaje = "Usuario creado correctamente";
                    });
                    _log.informacion("Usuario creado con UID $uid");
                  } else {
                    setState(() {
                      mensaje = "Error al crear usuario";
                    });
                  }
                },
                child: const Text("Registrar"),
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
