/*
  Archivo: servicio_autenticacion.dart
  Descripción:
    Servicio encargado de gestionar el proceso de autenticación utilizando Firebase Auth,
    así como la creación y consulta de usuarios en la colección "usuarios" de Firestore.

  Dependencias:
    - firebase_auth
    - cloud_firestore
    - servicio_log.dart
    - roles.dart
    - textos_app.dart

  Archivos que dependen de este archivo:
    - Controladores de registro, login y gestión de sesión del usuario
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fantasypro/modelos/roles.dart';
import 'package:fantasypro/textos/textos_app.dart';
import '../utilidades/servicio_log.dart';

class ServicioAutenticacion {
  /// Instancia de Firebase Auth para operaciones de autenticación.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Instancia de Firestore para consultar o guardar datos del usuario.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Servicio de logs para registrar eventos y errores.
  final ServicioLog _log = ServicioLog();

  /*
    Nombre: registrarUsuario
    Descripción:
      Registra un nuevo usuario con email y contraseña en Firebase Auth, y guarda
      su información adicional en Firestore en la colección "usuarios".
    Entradas:
      - email (String): correo electrónico del nuevo usuario.
      - password (String): contraseña de acceso.
      - nombre (String): nombre visible del usuario.
      - rolDB (String): rol del usuario (debe provenir de RolUsuario.valorDB).
    Salidas:
      - Future<String?>: UID del nuevo usuario, o null si ocurre un error.
  */
  Future<String?> registrarUsuario(
    String email,
    String password,
    String nombre,
    String rolDB,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = cred.user!.uid;

      await _db.collection("usuarios").doc(uid).set({
        "uid": uid,
        "nombre": nombre,
        "email": email,
        "rol": rolDB,
        "creado": DateTime.now().millisecondsSinceEpoch,
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

  /*
    Nombre: iniciarSesion
    Descripción:
      Inicia sesión con las credenciales provistas (email y contraseña) mediante Firebase Auth.
    Entradas:
      - email (String): correo del usuario.
      - password (String): contraseña del usuario.
    Salidas:
      - Future<User?>: instancia del usuario autenticado o null si falla.
  */
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

  /*
    Nombre: cerrarSesion
    Descripción:
      Cierra la sesión actual del usuario autenticado.
    Entradas:
      - Ninguna.
    Salidas:
      - Future<void>
  */
  Future<void> cerrarSesion() async {
    await _auth.signOut();
    _log.informacion(TextosApp.LOG_AUTH_LOGOUT);
  }

  /*
    Nombre: obtenerUsuarioActual
    Descripción:
      Retorna la instancia del usuario actualmente autenticado.
    Entradas:
      - Ninguna.
    Salidas:
      - User?: instancia del usuario actual o null si no hay sesión activa.
  */
  User? obtenerUsuarioActual() {
    return _auth.currentUser;
  }

  /*
    Nombre: esAdmin
    Descripción:
      Verifica si el usuario especificado tiene rol de administrador.
    Entradas:
      - uid (String): ID del usuario a consultar.
    Salidas:
      - Future<bool>: true si es administrador, false en cualquier otro caso.
  */
  Future<bool> esAdmin(String uid) async {
    try {
      final doc = await _db.collection("usuarios").doc(uid).get();
      if (!doc.exists) return false;

      final rolDB = (doc["rol"] ?? "") as String;
      return RolUsuarioExt.desdeValorDB(rolDB) == RolUsuario.admin;
    } catch (e) {
      _log.error("${TextosApp.LOG_AUTH_ERROR_ROL} $e");
      return false;
    }
  }
}
