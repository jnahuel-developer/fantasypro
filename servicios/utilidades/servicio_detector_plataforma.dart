/*
  Archivo: servicio_detector_plataforma.dart
  Descripción: Servicio destinado a detectar si el usuario está utilizando una
               versión Web Desktop o Web Mobile en función del tamaño de la
               pantalla. Este servicio permitirá bifurcar el flujo del sistema.
  Dependencias: Ninguna.
*/

class ServicioDetectorPlataforma {
  /// Retorna true si la resolución indica un dispositivo estilo Desktop.
  bool esEscritorio(double anchoPantalla) {
    return anchoPantalla >= 900;
  }

  /// Retorna true si la resolución indica un dispositivo estilo Mobile.
  bool esMovil(double anchoPantalla) {
    return anchoPantalla < 900;
  }
}
