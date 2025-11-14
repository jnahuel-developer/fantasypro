/*
  Archivo: lib/main.dart
  Descripción:
      Punto de entrada principal de la aplicación FantasyPro.
      Detecta si es Web Desktop o Web Mobile, carga textos desde configuración
      e inicia la vista correspondiente.
*/

import 'package:flutter/material.dart';

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

void main() {
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
        ? "configuracion/textos/web/desktop.txt"
        : "configuracion/textos/web/mobile.txt";

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
                debugShowCheckedModeBanner: false,
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
              home: esDesktop
                  ? PaginaInicioDesktop(textos: textos)
                  : PaginaInicioMobile(textos: textos),
            );
          },
        );
      },
    );
  }
}
