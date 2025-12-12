/*
  Archivo: lib/main.dart
  Descripción:
      Punto de entrada principal de la aplicación FantasyPro.
      Inicializa Firebase, detecta plataforma Web (Desktop/Mobile),
      carga textos desde configuración y dirige el flujo según estado de autenticación.
*/

import 'package:fantasypro/controladores/controlador_router.dart';
import 'package:flutter/material.dart';

// Servicios
import 'servicios/utilidades/servicio_log.dart';
import 'servicios/utilidades/servicio_detector_plataforma.dart';

// Temas
import 'temas/tema_web_desktop.dart';
import 'temas/tema_web_mobile.dart';

// Vistas

// Firebase init
import 'servicios/firebase/servicio_inicializacion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ServicioLog log = ServicioLog();
  final ServicioInicializacion init = ServicioInicializacion();

  log.informacion("Iniciando carga de Firebase...");

  await init.inicializarDesdeArchivo(
    'assets/configuracion/entorno/firebase_produccion.json',
  );

  log.informacion("Firebase inicializado correctamente.");

  runApp(const AplicacionFantasyPro());
}

class AplicacionFantasyPro extends StatefulWidget {
  const AplicacionFantasyPro({super.key});

  @override
  State<AplicacionFantasyPro> createState() => _AplicacionFantasyProEstado();
}

class _AplicacionFantasyProEstado extends State<AplicacionFantasyPro> {
  final ServicioLog servicioLog = ServicioLog();
  final ServicioDetectorPlataforma detector = ServicioDetectorPlataforma();

  bool esDesktop = true;

  Future<void> inicializarSistema(BuildContext context) async {
    final ancho = MediaQuery.of(context).size.width;

    esDesktop = detector.esEscritorio(ancho);
    servicioLog.informacion(
      "Plataforma detectada: ${esDesktop ? "Desktop" : "Mobile"}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, restricciones) {
        return FutureBuilder(
          future: inicializarSistema(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: esDesktop
                  ? obtenerTemaWebDesktop()
                  : obtenerTemaWebMobile(),

              // FLUJO DE AUTENTICACIÓN
              home: ControladorRouter(),
            );
          },
        );
      },
    );
  }
}
