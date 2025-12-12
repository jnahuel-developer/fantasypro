import 'package:fantasypro/textos/textos_app.dart';

/// Fuente central de textos para controladores.
///
/// Se almacenan con la convención `controller_name.message_key` y permiten
/// interpolar parámetros mediante la función [text].
class AppStrings {
  const AppStrings._();

  // Controlador Fechas
  static const controladorFechasIdLigaVacio =
      'controlador_fechas.id_liga_vacio';
  static const controladorFechasLogCreando =
      'controlador_fechas.log_creando';
  static const controladorFechasErrorLigaNoEncontrada =
      'controlador_fechas.error_liga_no_encontrada';
  static const controladorFechasErrorMaximo =
      'controlador_fechas.error_maximo_fechas';
  static const controladorFechasErrorActiva =
      'controlador_fechas.error_fecha_activa';
  static const controladorFechasNombre = 'controlador_fechas.nombre';
  static const controladorFechasLogActualizarContador =
      'controlador_fechas.log_actualizar_contador';
  static const controladorFechasLogListar = 'controlador_fechas.log_listar';
  static const controladorFechasLogCerrar = 'controlador_fechas.log_cerrar';
  static const controladorFechasErrorNoActiva =
      'controlador_fechas.error_no_activa';
  static const controladorFechasErrorFaltanPuntajes =
      'controlador_fechas.error_faltan_puntajes';
  static const controladorFechasLogAplicarPuntajes =
      'controlador_fechas.log_aplicar_puntajes';
  static const controladorFechasErrorLigaAsociada =
      'controlador_fechas.error_liga_asociada';
  static const controladorFechasLogArchivarLiga =
      'controlador_fechas.log_archivar_liga';
  static const controladorFechasLogCerradaOk =
      'controlador_fechas.log_cerrada_ok';

  // Controlador Participaciones
  static const controladorParticipacionesIdLigaVacio =
      'controlador_participaciones.id_liga_vacio';
  static const controladorParticipacionesIdUsuarioVacio =
      'controlador_participaciones.id_usuario_vacio';
  static const controladorParticipacionesNombreEquipoVacio =
      'controlador_participaciones.nombre_equipo_vacio';
  static const controladorParticipacionesLogVerificar =
      'controlador_participaciones.log_verificar';
  static const controladorParticipacionesLogDuplicado =
      'controlador_participaciones.log_duplicado';
  static const controladorParticipacionesErrorDuplicado =
      'controlador_participaciones.error_duplicado';
  static const controladorParticipacionesLogCrear =
      'controlador_participaciones.log_crear';
  static const controladorParticipacionesLogCrearEquipo =
      'controlador_participaciones.log_crear_equipo';
  static const controladorParticipacionesLogListarLiga =
      'controlador_participaciones.log_listar_liga';
  static const controladorParticipacionesLogListarUsuario =
      'controlador_participaciones.log_listar_usuario';
  static const controladorParticipacionesLogObtener =
      'controlador_participaciones.log_obtener';
  static const controladorParticipacionesLogListarPuntajes =
      'controlador_participaciones.log_listar_puntajes';
  static const controladorParticipacionesLogNoEncontrada =
      'controlador_participaciones.log_no_encontrada';
  static const controladorParticipacionesLogArchivar =
      'controlador_participaciones.log_archivar';
  static const controladorParticipacionesLogActivar =
      'controlador_participaciones.log_activar';
  static const controladorParticipacionesLogEliminar =
      'controlador_participaciones.log_eliminar';
  static const controladorParticipacionesIdParticipacionVacio =
      'controlador_participaciones.id_participacion_vacio';
  static const controladorParticipacionesErrorPuntosNegativos =
      'controlador_participaciones.error_puntos_negativos';
  static const controladorParticipacionesLogEditar =
      'controlador_participaciones.log_editar';
  static const controladorParticipacionesIdFechaVacio =
      'controlador_participaciones.id_fecha_vacio';
  static const controladorParticipacionesLogInicioCalculo =
      'controlador_participaciones.log_inicio_calculo';
  static const controladorParticipacionesErrorFechaInvalida =
      'controlador_participaciones.error_fecha_invalida';
  static const controladorParticipacionesErrorFechaNoCerrada =
      'controlador_participaciones.error_fecha_no_cerrada';
  static const controladorParticipacionesLogActivasEncontradas =
      'controlador_participaciones.log_activas_encontradas';
  static const controladorParticipacionesLogProcesando =
      'controlador_participaciones.log_procesando';
  static const controladorParticipacionesLogEquipoNoEncontrado =
      'controlador_participaciones.log_equipo_no_encontrado';
  static const controladorParticipacionesLogAlineacionNoEncontrada =
      'controlador_participaciones.log_alineacion_no_encontrada';
  static const controladorParticipacionesLogPuntajeExistente =
      'controlador_participaciones.log_puntaje_existente';
  static const controladorParticipacionesLogGuardarPuntaje =
      'controlador_participaciones.log_guardar_puntaje';
  static const controladorParticipacionesLogPuntosActualizados =
      'controlador_participaciones.log_puntos_actualizados';
  static const controladorParticipacionesLogError =
      'controlador_participaciones.log_error';
  static const controladorParticipacionesLogCalculoFinalizado =
      'controlador_participaciones.log_calculo_finalizado';

  // Controlador Alineaciones
  static const controladorAlineacionesFormacionDefault =
      'controlador_alineaciones.formacion_default';
  static const controladorAlineacionesFormacionAlternativa =
      'controlador_alineaciones.formacion_alternativa';

  // Controlador Puntajes Reales
  static const controladorPuntajesRealesLogObtenerJugadores =
      'controlador_puntajes_reales.log_obtener_jugadores';
  static const controladorPuntajesRealesLogGuardar =
      'controlador_puntajes_reales.log_guardar';
  static const controladorPuntajesRealesErrorRango =
      'controlador_puntajes_reales.error_rango';
  static const controladorPuntajesRealesErrorJugadorInactivo =
      'controlador_puntajes_reales.error_jugador_inactivo';
  static const controladorPuntajesRealesLogVerificarCompletitud =
      'controlador_puntajes_reales.log_verificar_completitud';
  static const controladorPuntajesRealesLogMapa =
      'controlador_puntajes_reales.log_mapa';

  // Controlador Jugadores Reales
  static const controladorJugadoresRealesIdEquipoVacio =
      'controlador_jugadores_reales.id_equipo_vacio';
  static const controladorJugadoresRealesNombreVacio =
      'controlador_jugadores_reales.nombre_vacio';
  static const controladorJugadoresRealesPosicionInvalida =
      'controlador_jugadores_reales.posicion_invalida';
  static const controladorJugadoresRealesDorsalRango =
      'controlador_jugadores_reales.dorsal_rango';
  static const controladorJugadoresRealesValorRango =
      'controlador_jugadores_reales.valor_rango';
  static const controladorJugadoresRealesLogCrear =
      'controlador_jugadores_reales.log_crear';
  static const controladorJugadoresRealesLogListar =
      'controlador_jugadores_reales.log_listar';
  static const controladorJugadoresRealesLogOrdenados =
      'controlador_jugadores_reales.log_ordenados';
  static const controladorJugadoresRealesIdJugadorVacio =
      'controlador_jugadores_reales.id_jugador_vacio';
  static const controladorJugadoresRealesLogEditar =
      'controlador_jugadores_reales.log_editar';
  static const controladorJugadoresRealesLogArchivar =
      'controlador_jugadores_reales.log_archivar';
  static const controladorJugadoresRealesLogActivar =
      'controlador_jugadores_reales.log_activar';
  static const controladorJugadoresRealesLogEliminar =
      'controlador_jugadores_reales.log_eliminar';
  static const controladorJugadoresRealesIdsVacios =
      'controlador_jugadores_reales.ids_vacios';
  static const controladorJugadoresRealesLogObtenerIds =
      'controlador_jugadores_reales.log_obtener_ids';
  static const controladorJugadoresRealesLogIdsOrdenados =
      'controlador_jugadores_reales.log_ids_ordenados';

  // Controlador Ligas
  static const controladorLigasTotalFechasRango =
      'controlador_ligas.total_fechas_rango';
  static const controladorLigasTemporada = 'controlador_ligas.temporada';
  static const controladorLigasLogCreando = 'controlador_ligas.log_creando';
  static const controladorLigasIdLigaVacio = 'controlador_ligas.id_liga_vacio';
  static const controladorLigasLogRecuperando =
      'controlador_ligas.log_recuperando';
  static const controladorLigasLogBusquedaVacia =
      'controlador_ligas.log_busqueda_vacia';
  static const controladorLigasLogBuscar = 'controlador_ligas.log_buscar';
  static const controladorLigasFechasNegativas =
      'controlador_ligas.fechas_negativas';
  static const controladorLigasLogEditar = 'controlador_ligas.log_editar';
  static const controladorLigasLogArchivar = 'controlador_ligas.log_archivar';
  static const controladorLigasLogActivar = 'controlador_ligas.log_activar';
  static const controladorLigasLogEliminar = 'controlador_ligas.log_eliminar';
  static const controladorLigasLogObtenerActivas =
      'controlador_ligas.log_obtener_activas';

  static const Map<String, String> _es = {
    controladorFechasIdLigaVacio: 'El idLiga no puede estar vacío.',
    controladorFechasLogCreando:
        '${TextosApp.LOG_CTRL_FECHAS_CREAR} {idLiga}',
    controladorFechasErrorLigaNoEncontrada:
        TextosApp.ERR_CTRL_LIGA_NO_ENCONTRADA,
    controladorFechasErrorMaximo:
        'La liga ya alcanzó el número máximo de fechas ({total}).',
    controladorFechasErrorActiva:
        TextosApp.ERR_CTRL_LIGA_CON_FECHA_ACTIVA_PARA_CREAR,
    controladorFechasNombre: 'Fecha {numeroFecha}',
    controladorFechasLogActualizarContador:
        '${TextosApp.LOG_CTRL_FECHAS_ACTUALIZAR_CONTADOR} {creadas}/{total}',
    controladorFechasLogListar:
        '${TextosApp.LOG_CTRL_FECHAS_OBTENER} {idLiga}',
    controladorFechasLogCerrar: '${TextosApp.LOG_CTRL_FECHAS_CERRAR} {idFecha}',
    controladorFechasErrorNoActiva: TextosApp.ERR_CTRL_FECHA_NO_ACTIVA,
    controladorFechasErrorFaltanPuntajes: TextosApp.ERR_CTRL_FALTAN_PUNTAJES,
    controladorFechasLogAplicarPuntajes:
        '${TextosApp.LOG_CTRL_FECHAS_APLICAR_PUNTAJES} {idLiga} para la fecha {idFecha}',
    controladorFechasErrorLigaAsociada:
        TextosApp.ERR_CTRL_LIGA_ASOCIADA_NO_ENCONTRADA,
    controladorFechasLogArchivarLiga:
        '${TextosApp.LOG_CTRL_FECHAS_ARCHIVAR_LIGA} {idLiga}',
    controladorFechasLogCerradaOk: 'Fecha {idFecha} cerrada correctamente.',

    controladorParticipacionesIdLigaVacio:
        TextosApp.ERR_CTRL_ID_LIGA_VACIO,
    controladorParticipacionesIdUsuarioVacio:
        TextosApp.ERR_CTRL_ID_USUARIO_VACIO,
    controladorParticipacionesNombreEquipoVacio:
        TextosApp.ERR_CTRL_NOMBRE_EQUIPO_VACIO,
    controladorParticipacionesLogVerificar:
        'Verificando si usuario {idUsuario} ya participa en liga {idLiga}',
    controladorParticipacionesLogDuplicado:
        'El usuario ya participa en la liga',
    controladorParticipacionesErrorDuplicado:
        'El usuario ya participa en esta liga.',
    controladorParticipacionesLogCrear: 'Creando participación (Etapa 1)',
    controladorParticipacionesLogCrearEquipo:
        'Creando equipo fantasy automáticamente tras registrar participación: usuario={idUsuario}, liga={idLiga}, nombreEquipo={nombre}',
    controladorParticipacionesLogListarLiga:
        'Listando participaciones de liga {idLiga}',
    controladorParticipacionesLogListarUsuario:
        'Listando participaciones del usuario {idUsuario}',
    controladorParticipacionesLogObtener:
        'Obteniendo participación de usuario {idUsuario} en liga {idLiga}',
    controladorParticipacionesLogListarPuntajes:
        'Obteniendo puntajes fantasy para usuario {idUsuario} en liga {idLiga}',
    controladorParticipacionesLogNoEncontrada:
        'No se encontró participación para usuario {idUsuario} en liga {idLiga}',
    controladorParticipacionesLogArchivar:
        'Archivando participación {idParticipacion}',
    controladorParticipacionesLogActivar:
        'Activando participación {idParticipacion}',
    controladorParticipacionesLogEliminar:
        'Eliminando participación {idParticipacion}',
    controladorParticipacionesIdParticipacionVacio:
        'El ID de la participación no puede estar vacío.',
    controladorParticipacionesErrorPuntosNegativos:
        TextosApp.ERR_CTRL_PUNTOS_NEGATIVOS,
    controladorParticipacionesLogEditar:
        'Editando participación {idParticipacion}',
    controladorParticipacionesIdFechaVacio:
        'El ID de la fecha no puede estar vacío.',
    controladorParticipacionesLogInicioCalculo:
        'Iniciando cálculo de puntajes fantasy para liga {idLiga}, fecha {idFecha}',
    controladorParticipacionesErrorFechaInvalida:
        'Fecha no válida para la liga especificada.',
    controladorParticipacionesErrorFechaNoCerrada:
        'La fecha {idFecha} no está cerrada.',
    controladorParticipacionesLogActivasEncontradas:
        'Participaciones activas encontradas: {total}',
    controladorParticipacionesLogProcesando:
        'Procesando participación {idParticipacion} (usuario {idUsuario})',
    controladorParticipacionesLogEquipoNoEncontrado:
        'No se encuentra equipo fantasy para participación {idParticipacion} — se saltea.',
    controladorParticipacionesLogAlineacionNoEncontrada:
        'No se encontró alineación para usuario {idUsuario} — se saltea.',
    controladorParticipacionesLogPuntajeExistente:
        'Puntaje fantasy ya aplicado para participación {idParticipacion}, fecha {idFecha} — se saltea.',
    controladorParticipacionesLogGuardarPuntaje:
        'Guardando puntaje fantasy para participación {idParticipacion}: total={puntajeTotal}',
    controladorParticipacionesLogPuntosActualizados:
        'Puntos acumulados actualizados para participación {idParticipacion}',
    controladorParticipacionesLogError:
        'Error procesando participación {idParticipacion}: {error}',
    controladorParticipacionesLogCalculoFinalizado:
        'Cálculo de puntajes fantasy finalizado para liga {idLiga}, fecha {idFecha}',

    controladorAlineacionesFormacionDefault: '4-4-2',
    controladorAlineacionesFormacionAlternativa: '4-3-3',

    controladorPuntajesRealesLogObtenerJugadores:
        'Obteniendo jugadores reales por equipo para liga {idLiga}',
    controladorPuntajesRealesLogGuardar:
        'Guardando puntajes para fecha {idFecha} (Liga {idLiga})',
    controladorPuntajesRealesErrorRango:
        'El puntaje del jugador real {idJugadorReal} debe estar entre 1 y 10.',
    controladorPuntajesRealesErrorJugadorInactivo:
        'Jugador real no encontrado o no activo: {idJugadorReal}',
    controladorPuntajesRealesLogVerificarCompletitud:
        'Verificando completitud de puntajes en fecha {idFecha} (Liga {idLiga})',
    controladorPuntajesRealesLogMapa:
        'Obteniendo mapa de puntajes reales para liga {idLiga}, fecha {idFecha}',

    controladorJugadoresRealesIdEquipoVacio:
        'El idEquipoReal no puede estar vacío.',
    controladorJugadoresRealesNombreVacio:
        'El nombre del jugador no puede estar vacío.',
    controladorJugadoresRealesPosicionInvalida:
        'La posición debe ser POR, DEF, MED o DEL.',
    controladorJugadoresRealesDorsalRango:
        'El dorsal debe estar entre 1 y 99.',
    controladorJugadoresRealesValorRango:
        'El valor de mercado debe estar entre 1 y 1000.',
    controladorJugadoresRealesLogCrear:
        'Creando jugador real en equipo {idEquipoReal} ({nombre})',
    controladorJugadoresRealesLogListar:
        'Listando jugadores reales del equipo {idEquipoReal}',
    controladorJugadoresRealesLogOrdenados:
        'Jugadores obtenidos: {total} del equipo {idEquipoReal} (ordenados por posición)',
    controladorJugadoresRealesIdJugadorVacio:
        TextosApp.ERR_CTRL_ID_JUGADOR_VACIO,
    controladorJugadoresRealesLogEditar:
        '${TextosApp.LOG_CTRL_JUGADORES_REALES_EDITAR} {idJugador}',
    controladorJugadoresRealesLogArchivar:
        '${TextosApp.LOG_CTRL_JUGADORES_REALES_ARCHIVAR} {idJugador}',
    controladorJugadoresRealesLogActivar:
        '${TextosApp.LOG_CTRL_JUGADORES_REALES_ACTIVAR} {idJugador}',
    controladorJugadoresRealesLogEliminar:
        '${TextosApp.LOG_CTRL_JUGADORES_REALES_ELIMINAR} {idJugador}',
    controladorJugadoresRealesIdsVacios:
        'La lista de IDs no puede estar vacía.',
    controladorJugadoresRealesLogObtenerIds:
        'Obteniendo jugadores reales por IDs (solicitados={solicitados}, unicos={unicos})',
    controladorJugadoresRealesLogIdsOrdenados:
        'Jugadores obtenidos por IDs: {total} (ordenados)',

    controladorLigasTotalFechasRango:
        'El total de fechas debe estar entre 34 y 50.',
    controladorLigasTemporada:
        '${TextosApp.LIGA_TEXTO_TEMPORADA} {anio}/{anioSiguiente}',
    controladorLigasLogCreando: 'Creando liga: {nombre}',
    controladorLigasIdLigaVacio: 'El idLiga no puede estar vacío.',
    controladorLigasLogRecuperando:
        'Recuperando liga por id: {idLiga}',
    controladorLigasLogBusquedaVacia:
        TextosApp.ERR_CTRL_BUSQUEDA_TEXTO_VACIO,
    controladorLigasLogBuscar: "Buscando ligas con texto: '{texto}'",
    controladorLigasFechasNegativas:
        TextosApp.ERR_CTRL_FECHAS_CREADAS_NEGATIVAS,
    controladorLigasLogEditar: 'Editando liga: {idLiga}',
    controladorLigasLogArchivar: 'Archivando liga: {idLiga}',
    controladorLigasLogActivar: 'Activando liga: {idLiga}',
    controladorLigasLogEliminar: 'Eliminando liga: {idLiga}',
    controladorLigasLogObtenerActivas: 'Obteniendo ligas activas',
  };

  /// Obtiene el texto asociado a la [key] y reemplaza parámetros con [args].
  static String text(String key, {Map<String, String>? args}) {
    String value = _es[key] ?? key;
    if (args != null) {
      args.forEach((placeholder, replacement) {
        value = value.replaceAll('{$placeholder}', replacement);
      });
    }
    return value;
  }
}
