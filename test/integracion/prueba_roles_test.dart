/*
  Archivo: prueba_roles_test.dart
  Descripción:
    Prueba básica de integración para verificar que:
    - Firebase Auth loguea usuario
    - Se obtiene el rol desde Firestore
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fantasypro/servicios/firebase/servicio_inicializacion.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group("Prueba de roles", () {
    test("Crear usuario de prueba y verificar rol", () async {
      final init = ServicioInicializacion();
      await init.inicializarDesdeArchivo(
        'assets/configuracion/entorno/firebase_desarrollo.json',
      );

      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;

      final cred = await auth.createUserWithEmailAndPassword(
        email: "test_roles@example.com",
        password: "123456",
      );

      final uid = cred.user!.uid;

      await db.collection("usuarios").doc(uid).set({
        "rol": "usuario",
        "email": "test_roles@example.com",
      });

      final snap = await db.collection("usuarios").doc(uid).get();

      expect(snap.data()!["rol"], "usuario");
    });
  });
}
