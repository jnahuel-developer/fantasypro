/*
  Archivo: servicio_inicializacion.dart
  Descripción:
    Inicializa Firebase leyendo la configuración desde assets/configuracion/entorno/firebase_desarrollo.json.
    Si el JSON indica usarEmulador=true, conecta los SDKs al Firebase Emulator Suite.
  Dependencias:
    - firebase_core
    - dart:convert
    - rootBundle (flutter/services)
*/

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServicioInicializacion {
  FirebaseApp? _app;

  /// Inicializa Firebase a partir del JSON de configuración.
  /// Entrada:
  ///   - rutaConfig (String): ruta relativa del JSON en assets.
  /// Salida:
  ///   - Future<FirebaseApp>: instancia de FirebaseApp inicializada.
  Future<FirebaseApp> inicializarDesdeArchivo(String rutaConfig) async {
    final String contenido = await rootBundle.loadString(rutaConfig);
    final Map<String, dynamic> cfg = json.decode(contenido);

    final FirebaseOptions opciones = FirebaseOptions(
      apiKey: cfg['apiKey'] ?? '',
      appId: cfg['appId'] ?? '',
      messagingSenderId: cfg['messagingSenderId'] ?? '',
      projectId: cfg['projectId'] ?? '',
      authDomain: cfg['authDomain'],
      storageBucket: cfg['storageBucket'],
      measurementId: cfg['measurementId'],
    );

    _app = await Firebase.initializeApp(options: opciones);

    // Conectar con emuladores si está configurado
    final bool usarEmulador = cfg['usarEmulador'] == true;
    if (usarEmulador) {
      final String host = cfg['emuladorHost'] ?? 'localhost';
      final int authPort = (cfg['emuladorAuthPuerto'] ?? 9099) as int;
      final int firestorePort = (cfg['emuladorFirestorePuerto'] ?? 8080) as int;

      // Auth: para web, se direcciona usando host:port en variable
      try {
        await FirebaseAuth.instance.useAuthEmulator(host, authPort);
      } catch (_) {
        // algunos SDKs ignoran si no aplica
      }

      FirebaseFirestore.instance.settings = Settings(
        host: '$host:$firestorePort',
        sslEnabled: false,
        persistenceEnabled: false,
      );
    }

    return _app!;
  }

  FirebaseApp? get app => _app;
}
