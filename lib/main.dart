/*
  Archivo: lib/main.dart
  Descripción:
      Punto de entrada principal de la aplicación FantasyPro.
      Inicializa Firebase, detecta plataforma Web (Desktop/Mobile),
      carga textos desde configuración y dirige el flujo según estado de autenticación.
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Servicios
import 'servicios/utilidades/servicio_log.dart';
import 'servicios/utilidades/servicio_detector_plataforma.dart';
import 'servicios/utilidades/servicio_traducciones.dart';

// Temas
import 'temas/tema_web_desktop.dart';
import 'temas/tema_web_mobile.dart';

// Vistas
import 'vistas/web/desktop/pagina_inicio_desktop.dart';
import 'vistas/web/mobile/pagina_inicio_mobile.dart';
import 'vistas/web/desktop/pagina_login_desktop.dart';

// Firebase init
import 'servicios/firebase/servicio_inicializacion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ServicioLog log = ServicioLog();
  final ServicioInicializacion init = ServicioInicializacion();

  log.informacion("Iniciando carga de Firebase...");

  await init.inicializarDesdeArchivo(
    'assets/configuracion/entorno/firebase_desarrollo.json',
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
  final ServicioTraducciones servicioTraducciones = ServicioTraducciones();

  bool esDesktop = true;
  Map<String, String> textos = {};

  Future<void> inicializarSistema(BuildContext context) async {
    final ancho = MediaQuery.of(context).size.width;

    esDesktop = detector.esEscritorio(ancho);
    servicioLog.informacion(
      "Plataforma detectada: ${esDesktop ? "Desktop" : "Mobile"}",
    );

    final String rutaTexto = esDesktop
        ? "assets/configuracion/textos/web/desktop.txt"
        : "assets/configuracion/textos/web/mobile.txt";

    textos = await servicioTraducciones.cargarTextos(rutaTexto);

    servicioLog.informacion("Textos cargados: ${textos.length} ítems");
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
              home: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Usuario NO autenticado → mostrar login
                  if (!snapshot.hasData) {
                    return const PaginaLoginDesktop();
                  }

                  // Usuario autenticado → mostrar inicio
                  return esDesktop
                      ? PaginaInicioDesktop(textos: textos)
                      : PaginaInicioMobile(textos: textos);
                },
              ),
            );
          },
        );
      },
    );
  }
}
