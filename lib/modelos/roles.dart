/*
  Archivo: roles.dart
  Descripción:
    Enumeración que representa los roles posibles dentro del sistema FantasyPro
    y métodos auxiliares para obtener valores de base de datos y textos visibles.

  Dependencias:
    - package:fantasypro/textos/textos_app.dart
  Archivos que dependen de este archivo:
    - Módulos de autenticación, controladores de acceso y vistas de registro.
*/

import 'package:fantasypro/textos/textos_app.dart';

/// Roles disponibles en la plataforma.
enum RolUsuario { usuario, admin }

extension RolUsuarioExt on RolUsuario {
  /*
    Nombre: valorDB
    Descripción:
      Obtiene el valor en texto que debe almacenarse en Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - String representando el rol.
  */
  String get valorDB {
    switch (this) {
      case RolUsuario.usuario:
        return "usuario";
      case RolUsuario.admin:
        return "admin";
    }
  }

  /*
    Nombre: textoVisible
    Descripción:
      Devuelve una representación visible del rol, generalmente asociada
      a textos traducidos dentro de la aplicación.
    Entradas:
      - Ninguna.
    Salidas:
      - String correspondiente al texto visible.
  */
  String get textoVisible {
    switch (this) {
      case RolUsuario.usuario:
        return TextosApp.REGISTRO_DESKTOP_ROL_USUARIO;
      case RolUsuario.admin:
        return TextosApp.REGISTRO_DESKTOP_ROL_ADMIN;
    }
  }

  /*
    Nombre: desdeValorDB
    Descripción:
      Convierte un string proveniente de Firestore en su equivalente RolUsuario.
    Entradas:
      - valor (String): valor almacenado en Firestore.
    Salidas:
      - RolUsuario correspondiente.
  */
  static RolUsuario desdeValorDB(String valor) {
    switch (valor) {
      case "admin":
        return RolUsuario.admin;
      default:
        return RolUsuario.usuario;
    }
  }
}
