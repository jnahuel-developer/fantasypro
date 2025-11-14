/*
  Archivo: pagina_login_desktop.dart
  Descripción:
    Pantalla de inicio de sesión para Web Desktop.
*/

import 'package:flutter/material.dart';
import '../../../servicios/firebase/servicio_autenticacion.dart';
import 'pagina_registro_desktop.dart';

class PaginaLoginDesktop extends StatefulWidget {
  const PaginaLoginDesktop({super.key});

  @override
  State<PaginaLoginDesktop> createState() => _PaginaLoginDesktopEstado();
}

class _PaginaLoginDesktopEstado extends State<PaginaLoginDesktop> {
  final ServicioAutenticacion _auth = ServicioAutenticacion();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  String mensaje = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("LOGIN - FANTASYPRO", style: TextStyle(fontSize: 22)),
              const SizedBox(height: 20),

              TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: "Correo"),
              ),

              TextField(
                controller: _pass,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Contraseña"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  final user = await _auth.iniciarSesion(
                    _email.text.trim(),
                    _pass.text.trim(),
                  );

                  setState(() {
                    mensaje = user != null
                        ? "Inicio correcto. UID: ${user.uid}"
                        : "Login incorrecto.";
                  });
                },
                child: const Text("Iniciar sesión"),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaginaRegistroDesktop(),
                    ),
                  );
                },
                child: const Text("¿No tienes cuenta? Registrar usuario"),
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
