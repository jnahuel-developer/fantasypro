/*
  Archivo: servicio_log.dart
  Descripción: Servicio encargado de centralizar el manejo de logs internos de
               la aplicación. Por el momento solo imprime en consola, pero será
               ampliado para registrar errores y advertencias.
  Dependencias: Ninguna.
*/

class ServicioLog {
  /// Imprime un mensaje informativo.
  void informacion(String mensaje) {
    print("[INFO] $mensaje");
  }

  /// Imprime un mensaje de advertencia.
  void advertencia(String mensaje) {
    print("[ADVERTENCIA] $mensaje");
  }

  /// Imprime un mensaje de error.
  void error(String mensaje) {
    print("[ERROR] $mensaje");
  }
}
