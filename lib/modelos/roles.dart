import 'package:fantasypro/textos/textos_app.dart';

enum RolUsuario { usuario, admin }

extension RolUsuarioExt on RolUsuario {
  String get valorDB {
    switch (this) {
      case RolUsuario.usuario:
        return "usuario";
      case RolUsuario.admin:
        return "admin";
    }
  }

  String get textoVisible {
    switch (this) {
      case RolUsuario.usuario:
        return TextosApp.REGISTRO_DESKTOP_ROL_USUARIO;
      case RolUsuario.admin:
        return TextosApp.REGISTRO_DESKTOP_ROL_ADMIN;
    }
  }
}
