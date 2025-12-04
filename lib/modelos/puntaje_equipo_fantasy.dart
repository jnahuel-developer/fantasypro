/*
  Archivo: puntaje_equipo_fantasy.dart
  Descripción:
    Modelo de datos que representa el puntaje obtenido por un Equipo Fantasy
    en una fecha específica dentro de una liga. Se persiste como subcolección
    de una participación de liga.

  Dependencias:
    - Ninguna directa.

  Archivos que dependen de este:
    - Servicios de administración de puntajes fantasy.
    - Controladores que calculan y aplican puntajes por fecha.
    - UI de administración de resultados y reportes.
*/

class PuntajeEquipoFantasy {
  /// Identificador único del documento.
  /// En la colección se usa el idFecha como ID del documento.
  final String id;

  /// Identificador de la participación en la liga.
  final String idParticipacion;

  /// Identificador del equipo fantasy al que pertenece este puntaje.
  final String idEquipoFantasy;

  /// Identificador de la liga asociada.
  final String idLiga;

  /// Identificador de la fecha a la cual pertenece este puntaje.
  final String idFecha;

  /// Puntaje total obtenido por el equipo fantasy en esta fecha.
  final int puntajeTotal;

  /// Detalle por jugador: idJugador → puntaje individual.
  final Map<String, int> detalleJugadores;

  /// Timestamp del momento en que se aplicó el puntaje.
  final int timestampAplicacion;

  /// Estado del registro (true = activo).
  final bool activo;

  /*
    Nombre: PuntajeEquipoFantasy (constructor)
    Descripción:
      Construye un registro de puntaje fantasy para un equipo en una fecha dada.
    Entradas:
      - id (String): identificador del documento.
      - idParticipacion (String): referencia a la participación del usuario.
      - idEquipoFantasy (String): identificador del equipo fantasy.
      - idLiga (String): identificador de la liga.
      - idFecha (String): identificador de la fecha de liga.
      - puntajeTotal (int): puntaje total obtenido.
      - detalleJugadores (Map<String,int>): puntajes por jugador.
      - timestampAplicacion (int): momento en que se aplicó el puntaje.
      - activo (bool): estado del registro.
    Salidas:
      - Instancia de PuntajeEquipoFantasy.
  */
  const PuntajeEquipoFantasy({
    required this.id,
    required this.idParticipacion,
    required this.idEquipoFantasy,
    required this.idLiga,
    required this.idFecha,
    required this.puntajeTotal,
    required this.detalleJugadores,
    required this.timestampAplicacion,
    required this.activo,
  });

  /*
    Nombre: desdeMapa
    Descripción:
      Construye una instancia de PuntajeEquipoFantasy a partir de los datos
      serializados obtenidos de Firestore.
    Entradas:
      - id (String): identificador del documento.
      - data (Map<String, dynamic>): mapa con los datos serializados.
    Salidas:
      - Instancia de PuntajeEquipoFantasy.
    Ejemplo:
      final p = PuntajeEquipoFantasy.desdeMapa(doc.id, doc.data());
  */
  factory PuntajeEquipoFantasy.desdeMapa(String id, Map<String, dynamic> data) {
    return PuntajeEquipoFantasy(
      id: id,
      idParticipacion: data['idParticipacion'] ?? '',
      idEquipoFantasy: data['idEquipoFantasy'] ?? '',
      idLiga: data['idLiga'] ?? '',
      idFecha: data['idFecha'] ?? '',
      puntajeTotal: data['puntajeTotal'] ?? 0,
      detalleJugadores: Map<String, int>.from(data['detalleJugadores'] ?? {}),
      timestampAplicacion: data['timestampAplicacion'] ?? 0,
      activo: data['activo'] ?? true,
    );
  }

  /*
    Nombre: aMapa
    Descripción:
      Convierte esta instancia en un mapa serializable para persistencia.
    Entradas:
      - Ninguna.
    Salidas:
      - Map<String, dynamic> con los datos del puntaje.
    Ejemplo:
      await ref.set(puntajeEquipoFantasy.aMapa());
  */
  Map<String, dynamic> aMapa() {
    return {
      'idParticipacion': idParticipacion,
      'idEquipoFantasy': idEquipoFantasy,
      'idLiga': idLiga,
      'idFecha': idFecha,
      'puntajeTotal': puntajeTotal,
      'detalleJugadores': detalleJugadores,
      'timestampAplicacion': timestampAplicacion,
      'activo': activo,
    };
  }
}
