/*
  Archivo: servicio_autenticacion.dart
  Descripción:
    Servicio encargado de gestionar la autenticación de usuarios mediante Firebase Auth.
    Permite registrar usuarios, iniciar sesión, cerrar sesión y obtener información de roles
    almacenados en Firestore.

  Dependencias:
    - firebase_auth
    - cloud_firestore
    - servicio_log.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utilidades/servicio_log.dart';

class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  /// Registra un usuario nuevo en Firebase Auth y genera su documento en Firestore.
  /// Entradas:
  ///   - email (String)
  ///   - password (String)
  ///   - nombre (String)
  ///   - rol (String)
  /// Salida:
  ///   - Future<String?>: UID del usuario creado, o null si falla.
  Future<String?> registrarUsuario(
    String email,
    String password,
    String nombre,
    String rol,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      await _db.collection('usuarios').doc(uid).set({
        'uid': uid,
        'nombre': nombre,
        'email': email,
        'rol': rol,
        'creado': DateTime.now().toIso8601String(),
      });

      _log.informacion("Usuario registrado con rol $rol: $email");
      return uid;
    } catch (e) {
      _log.error("Error al registrar usuario: $e");
      return null;
    }
  }

  /// Inicia sesión con correo y contraseña.
  Future<User?> iniciarSesion(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _log.informacion("Inicio de sesión: $email");
      return cred.user;
    } catch (e) {
      _log.error("Error en login: $e");
      return null;
    }
  }

  /// Cierra la sesión del usuario actual.
  Future<void> cerrarSesion() async {
    await _auth.signOut();
    _log.informacion("Sesión cerrada");
  }

  /// Devuelve el usuario actualmente autenticado.
  User? obtenerUsuarioActual() {
    return _auth.currentUser;
  }

  /// Valida si el usuario es administrador
  /// (lee campo "rol" desde Firestore).
  Future<bool> esAdmin(String uid) async {
    try {
      final doc = await _db.collection('usuarios').doc(uid).get();
      if (!doc.exists) return false;
      return doc['rol'] == 'admin';
    } catch (e) {
      _log.error("Error verificando rol de admin: $e");
      return false;
    }
  }
}
