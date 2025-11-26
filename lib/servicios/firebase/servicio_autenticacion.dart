/*
  Archivo: servicio_autenticacion.dart
  Descripción:
    Servicio encargado de gestionar la autenticación mediante Firebase Auth
    y la administración de los documentos de usuario en Firestore.

  Dependencias:
    - firebase_auth
    - cloud_firestore
    - servicio_log.dart
    - roles.dart
    - textos_app.dart
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasypro/modelos/roles.dart';
import 'package:fantasypro/textos/textos_app.dart';
import '../utilidades/servicio_log.dart';

class ServicioAutenticacion {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final ServicioLog _log = ServicioLog();

  // ---------------------------------------------------------------------------
  // Constantes internas: nombres de colección y campos Firestore
  // ---------------------------------------------------------------------------
  static const String _coleccionUsuarios = "usuarios";

  static const String _campoUid = "uid";
  static const String _campoNombre = "nombre";
  static const String _campoEmail = "email";
  static const String _campoRol = "rol";
  static const String _campoCreado = "creado";

  // ---------------------------------------------------------------------------
  // Registrar usuario
  // ---------------------------------------------------------------------------
  Future<String?> registrarUsuario(
    String email,
    String password,
    String nombre,
    String rolDB, // debe venir de RolUsuario.valorDB
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      await _db.collection(_coleccionUsuarios).doc(uid).set({
        _campoUid: uid,
        _campoNombre: nombre,
        _campoEmail: email,
        _campoRol: rolDB,
        _campoCreado: DateTime.now().millisecondsSinceEpoch,
      });

      _log.informacion(
        "${TextosApp.LOG_AUTH_USUARIO_REGISTRADO} $email (rol: $rolDB)",
      );

      return uid;
    } catch (e) {
      _log.error("${TextosApp.LOG_AUTH_REGISTRO_FALLIDO} $e");
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Inicio de sesión
  // ---------------------------------------------------------------------------
  Future<User?> iniciarSesion(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _log.informacion("${TextosApp.LOG_AUTH_INICIO_SESION} $email");
      return cred.user;
    } catch (e) {
      _log.error("${TextosApp.LOG_AUTH_LOGIN_ERROR} $e");
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Cerrar sesión
  // ---------------------------------------------------------------------------
  Future<void> cerrarSesion() async {
    await _auth.signOut();
    _log.informacion(TextosApp.LOG_AUTH_LOGOUT);
  }

  // ---------------------------------------------------------------------------
  // Usuario actual
  // ---------------------------------------------------------------------------
  User? obtenerUsuarioActual() {
    return _auth.currentUser;
  }

  // ---------------------------------------------------------------------------
  // Validación de rol administrador
  // ---------------------------------------------------------------------------
  Future<bool> esAdmin(String uid) async {
    try {
      final doc = await _db.collection(_coleccionUsuarios).doc(uid).get();
      if (!doc.exists) return false;

      final rolDB = (doc[_campoRol] ?? "") as String;
      return RolUsuarioExt.desdeValorDB(rolDB) == RolUsuario.admin;
    } catch (e) {
      _log.error("${TextosApp.LOG_AUTH_ERROR_ROL} $e");
      return false;
    }
  }
}
