/*
  Archivo: servicio_traducciones.dart
  Descripción: Servicio para cargar archivos de textos desde la carpeta
               assets/configuracion/textos/. Convierte los textos en un mapa clave-valor.
               El servicio acepta rutas con o sin el prefijo 'assets/' y normaliza.
  Dependencias: rootBundle (flutter/services.dart)
*/

import 'package:flutter/services.dart' show rootBundle;

class ServicioTraducciones {
  /*
    Función: cargarTextos
    Entradas:
        - rutaArchivo (String): ruta relativa del archivo de textos.
          Puede ser con o sin prefijo 'assets/'. Ejemplos válidos:
             'assets/configuracion/textos/web/desktop.txt'
             'configuracion/textos/web/desktop.txt'
    Salidas:
        - Future<Map<String, String>>: mapa con los textos cargados.
    Descripción:
        Lee el archivo indicado y convierte sus pares clave-valor en
        un mapa accesible por la aplicación. Los comentarios y líneas vacías
        se ignoran.
  */
  Future<Map<String, String>> cargarTextos(String rutaArchivo) async {
    // Normalizar ruta: asegurar que arranque con 'assets/' porque así se declarará en pubspec.yaml
    String ruta = rutaArchivo.trim();
    if (!ruta.startsWith('assets/')) {
      ruta = 'assets/$ruta';
    }

    // Intento de lectura del asset
    final String contenido = await rootBundle.loadString(ruta);

    final Map<String, String> mapa = <String, String>{};
    final List<String> lineas = contenido.split('\n');

    for (final lineaRaw in lineas) {
      final linea = lineaRaw.trim();
      if (linea.isEmpty) continue;
      if (linea.startsWith('#')) continue;
      final partes = linea.split('=');
      if (partes.length < 2) continue;
      final clave = partes[0].trim();
      final valor = partes
          .sublist(1)
          .join('=')
          .trim(); // por si el valor tiene '='
      if (clave.isNotEmpty) {
        mapa[clave] = valor;
      }
    }

    return mapa;
  }
}
