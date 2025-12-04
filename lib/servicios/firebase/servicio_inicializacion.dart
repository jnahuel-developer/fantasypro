/*
  Archivo: servicio_inicializacion.dart
  Descripción:
    Servicio encargado de inicializar Firebase a partir de un archivo de configuración
    en formato JSON. Permite conectar con los emuladores locales de Firebase si así
    se especifica en la configuración.

  Dependencias:
    - firebase_core
    - cloud_firestore
    - firebase_auth
    - servicio_log.dart
    - textos_app.dart

  Archivos que dependen de este archivo:
    - Punto de entrada de la aplicación
    - Controladores o servicios que requieren acceso a Firebase inicializado
*/

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasypro/servicios/utilidades/servicio_log.dart';
import 'package:fantasypro/textos/textos_app.dart';

class ServicioInicializacion {
  /// Instancia de la aplicación Firebase inicializada.
  FirebaseApp? _app;

  /// Servicio de logs para registrar información y errores durante la inicialización.
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Constantes para claves del JSON
  // ---------------------------------------------------------------------------

  static const String _kApiKey = "apiKey";
  static const String _kAppId = "appId";
  static const String _kSenderId = "messagingSenderId";
  static const String _kProjectId = "projectId";
  static const String _kAuthDomain = "authDomain";
  static const String _kStorageBucket = "storageBucket";
  static const String _kMeasurementId = "measurementId";

  static const String _kUsarEmulador = "usarEmulador";
  static const String _kHost = "emuladorHost";
  static const String _kAuthPort = "emuladorAuthPuerto";
  static const String _kFirestorePort = "emuladorFirestorePuerto";

  /*
    Nombre: inicializarDesdeArchivo
    Descripción:
      Inicializa Firebase utilizando los parámetros definidos en un archivo JSON
      de configuración. Si se especifica el uso de emuladores, conecta Firebase Auth
      y Firestore a las instancias locales.

    Entradas:
      - rutaConfig (String): ruta al archivo JSON de configuración.

    Salidas:
      - Future<FirebaseApp>: instancia inicializada de FirebaseApp.
  */
  Future<FirebaseApp> inicializarDesdeArchivo(String rutaConfig) async {
    try {
      final String contenido = await rootBundle.loadString(rutaConfig);
      final Map<String, dynamic> cfg = json.decode(contenido);

      // Crear opciones usando los valores del JSON
      final FirebaseOptions opciones = FirebaseOptions(
        apiKey: cfg[_kApiKey] ?? '',
        appId: cfg[_kAppId] ?? '',
        messagingSenderId: cfg[_kSenderId] ?? '',
        projectId: cfg[_kProjectId] ?? '',
        authDomain: cfg[_kAuthDomain],
        storageBucket: cfg[_kStorageBucket],
        measurementId: cfg[_kMeasurementId],
      );

      _app = await Firebase.initializeApp(options: opciones);

      _log.informacion(TextosApp.LOG_INICIO_FIREBASE_OK);

      // ---------------------------------------------------------------------
      // Conexión a emuladores
      // ---------------------------------------------------------------------
      final bool usarEmulador = cfg[_kUsarEmulador] == true;

      if (usarEmulador) {
        final String host = cfg[_kHost] ?? "localhost";
        final int authPort = (cfg[_kAuthPort] ?? 9099) as int;
        final int firestorePort = (cfg[_kFirestorePort] ?? 8080) as int;

        try {
          await FirebaseAuth.instance.useAuthEmulator(host, authPort);
        } catch (_) {
          // SDK Web a veces ignora esto, no representa error funcional
        }

        FirebaseFirestore.instance.settings = Settings(
          host: "$host:$firestorePort",
          sslEnabled: false,
          persistenceEnabled: false,
        );

        _log.informacion("${TextosApp.LOG_INICIO_FIREBASE_EMULADOR} $host");
      }

      return _app!;
    } catch (e) {
      _log.error("${TextosApp.LOG_INICIO_FIREBASE_ERROR} $e");
      rethrow;
    }
  }

  /// Devuelve la instancia actual de FirebaseApp inicializada, o null si no fue inicializada.
  FirebaseApp? get app => _app;
}
