/*
  Archivo: puntaje_jugador_fecha.dart
  Descripción:
    Modelo de datos que representa el puntaje real obtenido por un JugadorReal
    en una FechaLiga determinada. Utilizado para registrar y persistir
    calificaciones oficiales dentro del sistema.
  Responsabilidades:
    - Representar un puntaje individual por jugador y por fecha.
    - Permitir serialización y deserialización hacia/desde Firestore.
    - Permitir creación de copias controladas (copiarCon).
  Dependencias directas:
    - Ninguna.
*/

class PuntajeJugadorFecha {
  /// Identificador único del documento en Firestore.
  final String id;

  /// Identificador de la fecha a la que pertenece este puntaje (FechaLiga).
  final String idFecha;

  /// Identificador redundante de la liga para facilitar consultas.
  final String idLiga;

  /// Identificador del equipo real al que pertenece el jugador.
  final String idEquipoReal;

  /// Identificador del jugador real al que corresponde el puntaje.
  final String idJugadorReal;

  /// Puntuación numérica (el controlador validará el rango).
  final int puntuacion;

  /// Timestamp de creación del registro en milisegundos.
  final int fechaCreacion;

  /*
    Nombre: Constructor principal de PuntajeJugadorFecha
    Firma:
      const PuntajeJugadorFecha({
        required String id,
        required String idFecha,
        required String idLiga,
        required String idEquipoReal,
        required String idJugadorReal,
        required int puntuacion,
        required int fechaCreacion,
      })
    Descripción:
      Crea una nueva instancia del modelo con todos sus valores obligatorios.
    Entradas:
      - id: identificador único del registro.
      - idFecha: referencia a la fecha de liga.
      - idLiga: referencia redundante a la liga.
      - idEquipoReal: referencia al equipo real del jugador.
      - idJugadorReal: referencia al jugador real.
      - puntuacion: calificación del jugador.
      - fechaCreacion: timestamp de creación.
    Salidas:
      - Instancia de PuntajeJugadorFecha.
  */
  const PuntajeJugadorFecha({
    required this.id,
    required this.idFecha,
    required this.idLiga,
    required this.idEquipoReal,
    required this.idJugadorReal,
    required this.puntuacion,
    required this.fechaCreacion,
  });

  /*
    Nombre: desdeMapa
    Firma: factory PuntajeJugadorFecha.desdeMapa(String id, Map<String, dynamic> datos)
    Descripción:
      Crea una instancia del modelo tomando los valores desde un mapa obtenido
      de Firestore.
    Entradas:
      - id: identificador del documento en Firestore.
      - datos: mapa con los datos sin procesar.
    Salidas:
      - Una instancia de PuntajeJugadorFecha.
    Ejemplo de uso:
      final p = PuntajeJugadorFecha.desdeMapa("P1", snapshot.data());
  */
  factory PuntajeJugadorFecha.desdeMapa(String id, Map<String, dynamic> datos) {
    return PuntajeJugadorFecha(
      id: id,
      idFecha: datos['idFecha'] ?? '',
      idLiga: datos['idLiga'] ?? '',
      idEquipoReal: datos['idEquipoReal'] ?? '',
      idJugadorReal: datos['idJugadorReal'] ?? '',
      puntuacion: datos['puntuacion'] ?? 0,
      fechaCreacion: datos['fechaCreacion'] ?? 0,
    );
  }

  /*
    Nombre: aMapa
    Firma: Map<String, dynamic> aMapa()
    Descripción:
      Convierte la instancia actual en un mapa listo para enviarse a Firestore.
    Entradas:
      - Ninguna.
    Salidas:
      - Mapa con los campos serializados.
    Ejemplo de uso:
      db.set("puntajes_reales/P1", puntaje.aMapa());
  */
  Map<String, dynamic> aMapa() {
    return {
      'idFecha': idFecha,
      'idLiga': idLiga,
      'idEquipoReal': idEquipoReal,
      'idJugadorReal': idJugadorReal,
      'puntuacion': puntuacion,
      'fechaCreacion': fechaCreacion,
    };
  }

  /*
    Nombre: copiarCon
    Firma:
      PuntajeJugadorFecha copiarCon({
        String? id,
        String? idFecha,
        String? idLiga,
        String? idEquipoReal,
        String? idJugadorReal,
        int? puntuacion,
        int? fechaCreacion,
      })
    Descripción:
      Devuelve una nueva instancia tomando los valores actuales y reemplazando
      únicamente aquellos provistos de manera opcional.
    Entradas:
      - Campos opcionales a reemplazar.
    Salidas:
      - Nueva instancia de PuntajeJugadorFecha.
    Ejemplo de uso:
      final actualizado = p.copiarCon(puntuacion: 7);
  */
  PuntajeJugadorFecha copiarCon({
    String? id,
    String? idFecha,
    String? idLiga,
    String? idEquipoReal,
    String? idJugadorReal,
    int? puntuacion,
    int? fechaCreacion,
  }) {
    return PuntajeJugadorFecha(
      id: id ?? this.id,
      idFecha: idFecha ?? this.idFecha,
      idLiga: idLiga ?? this.idLiga,
      idEquipoReal: idEquipoReal ?? this.idEquipoReal,
      idJugadorReal: idJugadorReal ?? this.idJugadorReal,
      puntuacion: puntuacion ?? this.puntuacion,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
