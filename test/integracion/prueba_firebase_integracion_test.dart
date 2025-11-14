/*
  Archivo: prueba_firebase_integracion_test.dart
  Descripción:
    Test de integración con Firebase Emulator. Crea un usuario de prueba,
    verifica que el documento en 'usuarios' exista y borra el usuario.
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> _leerCfg() async {
  final contenido = await rootBundle.loadString(
    'lib/configuracion/entorno/firebase_desarrollo.json',
  );
  return json.decode(contenido) as Map<String, dynamic>;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Integración Firebase (emulador)', () {
    setUpAll(() async {
      final cfg = await _leerCfg();
      final opciones = FirebaseOptions(
        apiKey: cfg['apiKey'] ?? '',
        appId: cfg['appId'] ?? '',
        messagingSenderId: cfg['messagingSenderId'] ?? '',
        projectId: cfg['projectId'] ?? '',
      );
      await Firebase.initializeApp(options: opciones);

      if (cfg['usarEmulador'] == true) {
        final host = cfg['emuladorHost'] ?? 'localhost';
        final authPort = cfg['emuladorAuthPuerto'] ?? 9099;
        final firestorePort = cfg['emuladorFirestorePuerto'] ?? 8080;
        await FirebaseAuth.instance.useAuthEmulator(host, authPort);
        FirebaseFirestore.instance.settings = Settings(
          host: '$host:$firestorePort',
          sslEnabled: false,
          persistenceEnabled: false,
        );
      }
    });

    test('Crear usuario y documento en Firestore', () async {
      final String correo = 'test_user@example.com';
      final String contrasena = 'contrasena123';

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );
      final uid = cred.user!.uid;

      await FirebaseFirestore.instance.collection('usuarios').doc(uid).set({
        'nombre': 'Usuario Test',
        'email': correo,
        'rol': 'usuario',
      });

      final doc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(uid)
          .get();
      expect(doc.exists, true);

      // cleanup
      await FirebaseFirestore.instance.collection('usuarios').doc(uid).delete();
      await cred.user!.delete();
    });
  });
}
