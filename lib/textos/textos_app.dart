// ignore_for_file: constant_identifier_names

/*
  Archivo: textos_app.dart
  Descripción:
    Centraliza todos los textos visibles de la aplicación.
    Estructura:
      PANTALLA_COMPONENTE_ACCION
*/

class TextosApp {
  TextosApp._(); // Constructor privado

  // -----------------------------------------------------------------------------
  // Comunes de la aplicación
  // Archivo: textos_app.dart
  // Prefijo: COMUN_
  // -----------------------------------------------------------------------------

  static const String COMUN_BOTON_CANCELAR = "Cancelar";
  static const String COMUN_BOTON_ACEPTAR = "Aceptar";
  static const String COMUN_BOTON_SALIR = "Salir";
  static const String COMUN_BOTON_VOLVER = "Volver";
  static const String COMUN_BOTON_CERRAR = "Cerrar";
  static const String COMUN_BOTON_OK = "OK";
  static const String COMUN_BOTON_CREAR = "Crear";
  static const String COMUN_BOTON_GUARDAR = "Guardar";
  static const String COMUN_BOTON_GUARDAR_CAMBIOS = "Guardar cambios";
  static const String COMUN_TITULO_CONFIRMACION = "Confirmación";
  static const String COMUN_MENSAJE_ACCION_NO_PERMITIDA =
      "Acción no permitida.";
  // ---------------------------------------------------------------------------
  // Mensajes de log
  // ---------------------------------------------------------------------------

  static const LOG_REGISTRO_USUARIO_CREADO = "Usuario creado con UID";

  // ---------------------------------------------------------------------------
  // Logs - Autenticación
  // ---------------------------------------------------------------------------
  static const LOG_AUTH_USUARIO_REGISTRADO = "Usuario registrado:";
  static const LOG_AUTH_REGISTRO_FALLIDO = "Error al registrar usuario:";
  static const LOG_AUTH_INICIO_SESION = "Inicio de sesión:";
  static const LOG_AUTH_LOGIN_ERROR = "Error en login:";
  static const LOG_AUTH_LOGOUT = "Sesión cerrada";
  static const LOG_AUTH_ERROR_ROL = "Error verificando rol de administrador:";

  // ---------------------------------------------------------------------------
  // Logs - Base de Datos
  // ---------------------------------------------------------------------------
  static const LOG_BD_GUARDAR_USUARIO = "Guardar/actualizar usuario:";
  static const LOG_BD_OBTENER_USUARIO = "Obtener usuario:";
  static const LOG_BD_CREAR_LIGA = "Crear liga:";
  static const LOG_BD_LISTAR_LIGAS = "Listar ligas (stream):";
  static const LOG_BD_ERROR = "Error en operación de BD:";

  // ---------------------------------------------------------------------------
  // Logs - Equipos
  // ---------------------------------------------------------------------------
  static const LOG_EQUIPOS_CREAR = "Crear equipo:";
  static const LOG_EQUIPOS_EDITAR = "Editar equipo:";
  static const LOG_EQUIPOS_ARCHIVAR = "Archivar equipo:";
  static const LOG_EQUIPOS_ACTIVAR = "Activar equipo:";
  static const LOG_EQUIPOS_ELIMINAR = "Eliminar equipo:";
  static const LOG_EQUIPOS_LISTAR = "Listar equipos de liga:";
  static const LOG_EQUIPOS_ERROR = "Error en operación de equipos:";

  // ---------------------------------------------------------------------------
  // Logs - Inicialización Firebase
  // ---------------------------------------------------------------------------
  static const LOG_INICIO_FIREBASE_OK = "Firebase inicializado correctamente.";
  static const LOG_INICIO_FIREBASE_EMULADOR =
      "Firebase conectado al Emulator Suite en";
  static const LOG_INICIO_FIREBASE_ERROR = "Error al inicializar Firebase:";

  // ---------------------------------------------------------------------------
  // Logs – Ligas
  // ---------------------------------------------------------------------------
  static const LOG_LIGA_CREADA = "Liga creada:";
  static const LOG_LIGA_ERROR_CREAR = "Error al crear liga:";
  static const LOG_LIGA_NO_ENCONTRADA = "Liga no encontrada:";
  static const LOG_LIGA_ERROR_OBTENER = "Error al obtener liga:";
  static const LOG_LIGA_ERROR_LISTAR_ACTIVAS = "Error al listar ligas activas:";
  static const LOG_LIGA_ERROR_LISTAR_TODAS = "Error al listar todas las ligas:";
  static const LOG_LIGA_EDITADA = "Liga editada:";
  static const LOG_LIGA_ERROR_EDITAR = "Error al editar liga:";
  static const LOG_LIGA_ARCHIVADA = "Liga archivada:";
  static const LOG_LIGA_ERROR_ARCHIVAR = "Error al archivar liga:";
  static const LOG_LIGA_ACTIVADA = "Liga activada:";
  static const LOG_LIGA_ERROR_ACTIVAR = "Error al activar liga:";
  static const LOG_LIGA_ELIMINADA = "Liga eliminada:";
  static const LOG_LIGA_ERROR_ELIMINAR = "Error al eliminar liga:";

  // ---------------------------------------------------------------------------
  // Logs - Jugadores
  // ---------------------------------------------------------------------------
  static const LOG_JUGADORES_CREAR = "Crear jugador:";
  static const LOG_JUGADORES_EDITAR = "Editar jugador:";
  static const LOG_JUGADORES_ARCHIVAR = "Archivar jugador:";
  static const LOG_JUGADORES_ACTIVAR = "Activar jugador:";
  static const LOG_JUGADORES_ELIMINAR = "Eliminar jugador:";
  static const LOG_JUGADORES_LISTAR = "Listar jugadores de equipo:";
  static const LOG_JUGADORES_ERROR = "Error en operación de jugadores:";

  // ---------------------------------------------------------------------------
  // Errores – Equipos
  // ---------------------------------------------------------------------------
  static const ERR_EQUIPO_ID_LIGA_VACIO =
      "El identificador de liga no puede estar vacío.";
  static const ERR_EQUIPO_NOMBRE_VACIO =
      "El nombre del equipo no puede quedar vacío.";

  // ---------------------------------------------------------------------------
  // Valores por defecto – Equipos
  // ---------------------------------------------------------------------------
  static const EQUIPO_DESCRIPCION_POR_DEFECTO =
      "Equipo creado por el administrador.";
  static const EQUIPO_ESCUDO_PENDIENTE = "pendiente";

  // ---------------------------------------------------------------------------
  // Logs – Equipos
  // ---------------------------------------------------------------------------
  static const LOG_EQUIPO_CREANDO = "Creando equipo en liga";
  static const LOG_EQUIPO_ARCHIVANDO = "Archivando equipo";
  static const LOG_EQUIPO_ACTIVANDO = "Activando equipo";
  static const LOG_EQUIPO_ELIMINANDO = "Eliminando equipo";
  static const LOG_EQUIPO_EDITANDO = "Editando equipo";

  // ---------------------------------------------------------------------------
  // Errores – Ligas
  // ---------------------------------------------------------------------------
  static const ERR_LIGA_NOMBRE_VACIO =
      "El nombre de la liga no puede quedar vacío.";

  // ---------------------------------------------------------------------------
  // Valores por defecto – Ligas
  // ---------------------------------------------------------------------------
  static const LIGA_DESCRIPCION_POR_DEFECTO =
      "Liga generada por el administrador.";
  static const LIGA_TEXTO_TEMPORADA = "Temporada";

  // ---------------------------------------------------------------------------
  // Logs – Ligas
  // ---------------------------------------------------------------------------
  static const LOG_LIGA_CREANDO = "Creando liga";
  static const LOG_LIGA_ARCHIVANDO = "Archivando liga";
  static const LOG_LIGA_ACTIVANDO = "Activando liga";
  static const LOG_LIGA_ELIMINANDO = "Eliminando liga";

  // ---------------------------------------------------------------------------
  // Errores – Jugadores
  // ---------------------------------------------------------------------------
  static const ERR_JUGADOR_ID_EQUIPO_VACIO =
      "El identificador del equipo no puede estar vacío.";
  static const ERR_JUGADOR_NOMBRE_VACIO =
      "El nombre del jugador no puede quedar vacío.";
  static const ERR_JUGADOR_POSICION_VACIO =
      "La posición del jugador no puede quedar vacía.";
  static const ERR_JUGADOR_DORSAL_NEGATIVO =
      "El número de dorsal no puede ser negativo.";

  // ---------------------------------------------------------------------------
  // Valores por defecto – Jugadores
  // ---------------------------------------------------------------------------
  static const JUGADOR_NACIONALIDAD_POR_DEFECTO = "";
  static const JUGADOR_DORSAL_POR_DEFECTO = 0;

  // ---------------------------------------------------------------------------
  // Logs – Jugadores
  // ---------------------------------------------------------------------------
  static const LOG_JUGADOR_CREANDO = "Creando jugador en equipo";
  static const LOG_JUGADOR_LISTANDO = "Solicitando jugadores del equipo";
  static const LOG_JUGADOR_ARCHIVANDO = "Archivando jugador";
  static const LOG_JUGADOR_ACTIVANDO = "Activando jugador";
  static const LOG_JUGADOR_ELIMINANDO = "Eliminando jugador";
  static const LOG_JUGADOR_EDITANDO = "Editando jugador";

  // ---------------------------------------------------------------------------
  // Errores – Roles
  // ---------------------------------------------------------------------------
  static const ERROR_ROL_DESCONOCIDO =
      "No se pudo determinar el rol del usuario.";

  // ---------------------------------------------------------------------------
  // Login
  // ---------------------------------------------------------------------------
  static const LOGIN_MENSAJE_BIENVENIDA =
      "Bienvenido a FantasyPro. Inicie sesión para continuar.";

  // ---------------------------------------------------------------------------
  // Usuario Final
  // ---------------------------------------------------------------------------
  static const TEXTO_BIENVENIDA_GENERAL = "Bienvenido al panel de usuario.";

  // ---------------------------------------------------------------------------
  // Controladores - Mensajes comunes
  // Archivos: lib/controladores/*
  // Prefijo: CTRL_COMUN_
  // ---------------------------------------------------------------------------
  static const String CTRL_COMUN_ERROR_ID_LIGA_VACIO =
      "El identificador de la liga no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_ID_USUARIO_VACIO =
      "El identificador del usuario no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_ID_EQUIPO_FANTASY_VACIO =
      "El identificador del equipo fantasy no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_ID_ALINEACION_VACIO =
      "El identificador de la alineación no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_ID_EQUIPO_REAL_VACIO =
      "El identificador del equipo real no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_ID_PARTICIPACION_VACIO =
      "El identificador de la participación no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_ID_FECHA_VACIO =
      "El identificador de la fecha no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_ID_JUGADOR_VACIO =
      "El identificador del jugador no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_NOMBRE_EQUIPO_VACIO =
      "El nombre del equipo no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_TEXTO_BUSQUEDA_VACIO =
      "El texto de búsqueda no puede estar vacío.";
  static const String CTRL_COMUN_ERROR_PUNTOS_NEGATIVOS =
      "Los puntos no pueden ser negativos.";
  static const String CTRL_COMUN_ERROR_LISTA_IDS_VACIA =
      "La lista de identificadores no puede estar vacía.";

  // ---------------------------------------------------------------------------
  // Controlador: Alineaciones
  // Archivo: controlador_alineaciones.dart
  // Prefijo: CTRL_ALINEACIONES_
  // ---------------------------------------------------------------------------
  static const String CTRL_ALINEACIONES_ERROR_JUGADOR_REQUERIDO =
      "Debe seleccionar al menos un jugador.";
  static const String CTRL_ALINEACIONES_ERROR_FORMACION_INVALIDA =
      "Formación no válida: {FORMACION}";
  static const String CTRL_ALINEACIONES_LOG_CREAR =
      "Creando alineación para usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_ALINEACIONES_LOG_LISTAR_USUARIO_LIGA =
      "Listando alineaciones de usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_ALINEACIONES_LOG_ARCHIVAR =
      "Archivando alineación {ALINEACION}";
  static const String CTRL_ALINEACIONES_LOG_ACTIVAR =
      "Activando alineación {ALINEACION}";
  static const String CTRL_ALINEACIONES_LOG_ELIMINAR =
      "Eliminando alineación {ALINEACION}";
  static const String CTRL_ALINEACIONES_LOG_EDITAR =
      "Editando alineación {ALINEACION}";
  static const String CTRL_ALINEACIONES_ERROR_PLANTEL_INICIAL =
      "Debe seleccionar exactamente 15 jugadores.";
  static const String CTRL_ALINEACIONES_ERROR_PLANTEL_CON_FECHA_ACTIVA =
      "No se puede armar el plantel: la liga tiene una fecha activa.";
  static const String CTRL_ALINEACIONES_LOG_GUARDAR_PLANTEL =
      "Guardando plantel inicial para usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_ALINEACIONES_ERROR_CAMPOS_OBLIGATORIOS =
      "Los campos idLiga, idUsuario y idAlineacion son obligatorios.";
  static const String CTRL_ALINEACIONES_ERROR_TITULARES =
      "Debe seleccionar exactamente 11 titulares.";
  static const String CTRL_ALINEACIONES_ERROR_SUPLENTES =
      "Debe seleccionar exactamente 4 suplentes.";
  static const String CTRL_ALINEACIONES_ERROR_NO_ENCONTRADA =
      "Alineación no encontrada.";
  static const String CTRL_ALINEACIONES_ERROR_JUGADORES_INVALIDOS =
      "Los jugadores seleccionados no coinciden con el plantel registrado.";
  static const String CTRL_ALINEACIONES_LOG_BUSCAR_PARTICIPACION =
      "Buscando participación del usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_ALINEACIONES_ERROR_PARTICIPACION_NO_ENCONTRADA =
      "Participación no encontrada.";
  static const String CTRL_ALINEACIONES_LOG_PARTICIPACION_ENCONTRADA =
      "Participación encontrada: {PARTICIPACION}";
  static const String CTRL_ALINEACIONES_LOG_PLANTEL_COMPLETO =
      "Marcando la participación {PARTICIPACION} como plantel completo.";
  static const String CTRL_ALINEACIONES_LOG_PARTICIPACION_ACTUALIZADA =
      "Participación actualizada correctamente.";
  static const String CTRL_ALINEACIONES_LOG_BUSCAR_ACTIVA =
      "Buscando alineación activa o más reciente para usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_ALINEACIONES_LOG_ACTIVA_ENCONTRADA =
      "Alineación activa encontrada: {ALINEACION}";
  static const String CTRL_ALINEACIONES_LOG_RECIENTE =
      "No hay alineación activa; se devuelve la más reciente: {ALINEACION}";

  // ---------------------------------------------------------------------------
  // Controlador: Equipo Fantasy
  // Archivo: controlador_equipo_fantasy.dart
  // Prefijo: CTRL_EQUIPO_FANTASY_
  // ---------------------------------------------------------------------------
  static const String CTRL_EQUIPO_FANTASY_ERROR_NOMBRE_VACIO =
      "El nombre del equipo fantasy no puede estar vacío.";
  static const String CTRL_EQUIPO_FANTASY_LOG_CREAR =
      "Creando equipo fantasy para usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_EQUIPO_FANTASY_LOG_YA_EXISTE =
      "El usuario ya tiene un equipo en esta liga.";
  static const String CTRL_EQUIPO_FANTASY_ERROR_YA_EXISTE =
      "Ya existe un equipo fantasy para este usuario en esta liga.";
  static const String CTRL_EQUIPO_FANTASY_LOG_FECHA_ACTIVA =
      "No se puede crear equipo: ya existe una fecha activa en la liga.";
  static const String CTRL_EQUIPO_FANTASY_ERROR_FECHA_ACTIVA =
      "No se puede crear un equipo con fechas activas en la liga.";
  static const String CTRL_EQUIPO_FANTASY_LOG_CREADO =
      "Equipo fantasy creado exitosamente: {EQUIPO}";
  static const String CTRL_EQUIPO_FANTASY_LOG_LISTAR_USUARIO =
      "Listando equipos fantasy del usuario {USUARIO}";
  static const String CTRL_EQUIPO_FANTASY_LOG_LISTAR_USUARIO_LIGA =
      "Listando equipos fantasy del usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_EQUIPO_FANTASY_ERROR_IDS_OBLIGATORIOS =
      "El identificador del usuario y el de la liga no pueden estar vacíos.";
  static const String CTRL_EQUIPO_FANTASY_LOG_EDITAR =
      "Editando equipo fantasy {EQUIPO}";
  static const String CTRL_EQUIPO_FANTASY_LOG_ARCHIVAR =
      "Archivando equipo fantasy {EQUIPO}";
  static const String CTRL_EQUIPO_FANTASY_LOG_ACTIVAR =
      "Activando equipo fantasy {EQUIPO}";
  static const String CTRL_EQUIPO_FANTASY_LOG_ELIMINAR =
      "Eliminando equipo fantasy {EQUIPO}";
  static const String CTRL_EQUIPO_FANTASY_LOG_OBTENER =
      "Obteniendo equipo fantasy para usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_EQUIPO_FANTASY_ERROR_ID_EQUIPO_VACIO =
      "El identificador del equipo no puede estar vacío.";
  static const String CTRL_EQUIPO_FANTASY_ERROR_PLANTEL_TAMANIO =
      "El plantel inicial debe tener 15 jugadores.";
  static const String CTRL_EQUIPO_FANTASY_LOG_GUARDAR_PLANTEL =
      "Guardando plantel inicial para equipo {EQUIPO} (jugadores={CANTIDAD}, presupuesto={PRESUPUESTO})";
  static const String CTRL_EQUIPO_FANTASY_LOG_PLANTEL_GUARDADO =
      "Plantel inicial guardado correctamente.";

  // ---------------------------------------------------------------------------
  // Controlador: Equipos Reales
  // Archivo: controlador_equipos_reales.dart
  // Prefijo: CTRL_EQUIPOS_REALES_
  // ---------------------------------------------------------------------------
  static const String CTRL_EQUIPOS_REALES_ERROR_NOMBRE_VACIO =
      "El nombre del equipo no puede estar vacío.";
  static const String CTRL_EQUIPOS_REALES_LOG_CREAR =
      "Creando equipo real en liga {LIGA} ({NOMBRE})";
  static const String CTRL_EQUIPOS_REALES_LOG_LISTAR =
      "Listando equipos reales de liga {LIGA}";
  static const String CTRL_EQUIPOS_REALES_LOG_EDITAR =
      "Editando equipo real {EQUIPO}";
  static const String CTRL_EQUIPOS_REALES_LOG_ACTIVAR =
      "Activando equipo real {EQUIPO}";
  static const String CTRL_EQUIPOS_REALES_LOG_ARCHIVAR =
      "Archivando equipo real {EQUIPO}";
  static const String CTRL_EQUIPOS_REALES_LOG_ELIMINAR =
      "Eliminando equipo real {EQUIPO}";

  // ---------------------------------------------------------------------------
  // Controlador: Fechas
  // Archivo: controlador_fechas.dart
  // Prefijo: CTRL_FECHAS_
  // ---------------------------------------------------------------------------
  static const String CTRL_FECHAS_LOG_CREAR =
      "Creando nueva fecha para liga {LIGA}";
  static const String CTRL_FECHAS_ERROR_LIGA_NO_ENCONTRADA =
      "No se encontró la liga solicitada.";
  static const String CTRL_FECHAS_ERROR_LIGA_MAXIMO =
      "La liga ya alcanzó el número máximo de fechas ({TOTAL}).";
  static const String CTRL_FECHAS_ERROR_FECHA_ACTIVA =
      "No se puede crear una nueva fecha mientras exista otra activa.";
  static const String CTRL_FECHAS_LOG_ACTUALIZAR_CONTADOR =
      "Actualizando contador de fechas de la liga: {CREADAS}/{TOTAL}";
  static const String CTRL_FECHAS_LOG_OBTENER_LIGA =
      "Obteniendo fechas de liga {LIGA}";
  static const String CTRL_FECHAS_LOG_CERRAR =
      "Intentando cerrar fecha {FECHA}";
  static const String CTRL_FECHAS_ERROR_CERRAR_INACTIVA =
      "Solo se pueden cerrar fechas activas.";
  static const String CTRL_FECHAS_ERROR_FALTAN_PUNTAJES =
      "Faltan puntajes para cerrar la fecha.";
  static const String CTRL_FECHAS_LOG_APLICAR_PUNTAJES =
      "Aplicando puntajes fantasy a participaciones de la liga {LIGA} para la fecha {FECHA}";
  static const String CTRL_FECHAS_ERROR_LIGA_ASOCIADA =
      "No se encontró la liga asociada.";
  static const String CTRL_FECHAS_LOG_ARCHIVAR_LIGA =
      "La última fecha fue cerrada; archivando liga {LIGA}";
  static const String CTRL_FECHAS_LOG_CERRADA =
      "Fecha {FECHA} cerrada correctamente.";

  // ---------------------------------------------------------------------------
  // Controlador: Participaciones
  // Archivo: controlador_participaciones.dart
  // Prefijo: CTRL_PARTICIPACIONES_
  // ---------------------------------------------------------------------------
  static const String CTRL_PARTICIPACIONES_ERROR_NOMBRE_EQUIPO_VACIO =
      "El nombre del equipo fantasy no puede estar vacío.";
  static const String CTRL_PARTICIPACIONES_LOG_VERIFICAR_EXISTENCIA =
      "Verificando si usuario {USUARIO} ya participa en liga {LIGA}";
  static const String CTRL_PARTICIPACIONES_LOG_YA_PARTICIPA =
      "El usuario ya participa en la liga";
  static const String CTRL_PARTICIPACIONES_ERROR_YA_PARTICIPA =
      "El usuario ya participa en esta liga.";
  static const String CTRL_PARTICIPACIONES_LOG_CREAR =
      "Creando participación (Etapa 1)";
  static const String CTRL_PARTICIPACIONES_LOG_CREAR_EQUIPO =
      "Creando equipo fantasy automáticamente tras registrar participación: usuario={USUARIO}, liga={LIGA}, nombreEquipo={NOMBRE}";
  static const String CTRL_PARTICIPACIONES_LOG_LISTAR_LIGA =
      "Listando participaciones de liga {LIGA}";
  static const String CTRL_PARTICIPACIONES_LOG_LISTAR_USUARIO =
      "Listando participaciones del usuario {USUARIO}";
  static const String CTRL_PARTICIPACIONES_LOG_OBTENER =
      "Obteniendo participación de usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_PARTICIPACIONES_LOG_OBTENER_PUNTAJES =
      "Obteniendo puntajes fantasy para usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_PARTICIPACIONES_LOG_SIN_PARTICIPACION =
      "No se encontró participación para usuario {USUARIO} en liga {LIGA}";
  static const String CTRL_PARTICIPACIONES_LOG_ARCHIVAR =
      "Archivando participación {PARTICIPACION}";
  static const String CTRL_PARTICIPACIONES_LOG_ACTIVAR =
      "Activando participación {PARTICIPACION}";
  static const String CTRL_PARTICIPACIONES_LOG_ELIMINAR =
      "Eliminando participación {PARTICIPACION}";
  static const String CTRL_PARTICIPACIONES_LOG_EDITAR =
      "Editando participación {PARTICIPACION}";
  static const String CTRL_PARTICIPACIONES_LOG_CALCULO_INICIO =
      "Iniciando cálculo de puntajes fantasy para liga {LIGA}, fecha {FECHA}";
  static const String CTRL_PARTICIPACIONES_ERROR_FECHA_INVALIDA =
      "Fecha no válida para la liga especificada.";
  static const String CTRL_PARTICIPACIONES_ERROR_FECHA_NO_CERRADA =
      "La fecha {FECHA} no está cerrada.";
  static const String CTRL_PARTICIPACIONES_LOG_PARTICIPACIONES_ENCONTRADAS =
      "Participaciones activas encontradas: {CANTIDAD}";
  static const String CTRL_PARTICIPACIONES_LOG_PROCESANDO =
      "Procesando participación {PARTICIPACION} (usuario {USUARIO})";
  static const String CTRL_PARTICIPACIONES_LOG_SIN_EQUIPO =
      "No se encuentra equipo fantasy para participación {PARTICIPACION} — se omite.";
  static const String CTRL_PARTICIPACIONES_LOG_SIN_ALINEACION =
      "No se encontró alineación para usuario {USUARIO} — se omite.";
  static const String CTRL_PARTICIPACIONES_LOG_YA_APLICADO =
      "Puntaje fantasy ya aplicado para participación {PARTICIPACION}, fecha {FECHA} — se omite.";
  static const String CTRL_PARTICIPACIONES_LOG_GUARDAR_PUNTAJE =
      "Guardando puntaje fantasy para participación {PARTICIPACION}: total={TOTAL}";
  static const String CTRL_PARTICIPACIONES_LOG_ACTUALIZAR_PUNTOS =
      "Puntos acumulados actualizados para participación {PARTICIPACION}";
  static const String CTRL_PARTICIPACIONES_ERROR_PROCESO =
      "Error procesando participación {PARTICIPACION}: {DETALLE}";
  static const String CTRL_PARTICIPACIONES_LOG_CALCULO_FIN =
      "Cálculo de puntajes fantasy finalizado para liga {LIGA}, fecha {FECHA}";

  // ---------------------------------------------------------------------------
  // Controlador: Jugadores Reales
  // Archivo: controlador_jugadores_reales.dart
  // Prefijo: CTRL_JUGADORES_REALES_
  // ---------------------------------------------------------------------------
  static const String CTRL_JUGADORES_REALES_ERROR_NOMBRE_VACIO =
      "El nombre del jugador no puede estar vacío.";
  static const String CTRL_JUGADORES_REALES_ERROR_POSICION =
      "La posición debe ser POR, DEF, MED o DEL.";
  static const String CTRL_JUGADORES_REALES_ERROR_DORSAL =
      "El dorsal debe estar entre 1 y 99.";
  static const String CTRL_JUGADORES_REALES_ERROR_VALOR_MERCADO =
      "El valor de mercado debe estar entre 1 y 1000.";
  static const String CTRL_JUGADORES_REALES_LOG_CREAR =
      "Creando jugador real en equipo {EQUIPO} ({NOMBRE})";
  static const String CTRL_JUGADORES_REALES_LOG_LISTAR =
      "Listando jugadores reales del equipo {EQUIPO}";
  static const String CTRL_JUGADORES_REALES_LOG_LISTAR_RESUMEN =
      "Jugadores obtenidos: {CANTIDAD} del equipo {EQUIPO} (ordenados por posición)";
  static const String CTRL_JUGADORES_REALES_LOG_EDITAR =
      "Editando jugador real {JUGADOR}";
  static const String CTRL_JUGADORES_REALES_LOG_ARCHIVAR =
      "Archivando jugador real {JUGADOR}";
  static const String CTRL_JUGADORES_REALES_LOG_ACTIVAR =
      "Activando jugador real {JUGADOR}";
  static const String CTRL_JUGADORES_REALES_LOG_ELIMINAR =
      "Eliminando jugador real {JUGADOR}";
  static const String CTRL_JUGADORES_REALES_ERROR_IDS_VACIOS =
      "La lista de IDs no puede estar vacía.";
  static const String CTRL_JUGADORES_REALES_LOG_OBTENER_IDS =
      "Obteniendo jugadores reales por IDs (solicitados={SOLICITADOS}, unicos={UNICOS})";
  static const String CTRL_JUGADORES_REALES_LOG_OBTENIDOS =
      "Jugadores obtenidos por IDs: {CANTIDAD} (ordenados)";

  // ---------------------------------------------------------------------------
  // Controlador: Ligas
  // Archivo: controlador_ligas.dart
  // Prefijo: CTRL_LIGAS_
  // ---------------------------------------------------------------------------
  static const String CTRL_LIGAS_ERROR_TOTAL_FECHAS =
      "El total de fechas debe estar entre 34 y 50.";
  static const String CTRL_LIGAS_ERROR_FECHAS_CREADAS =
      "Las fechas creadas no pueden ser negativas.";
  static const String CTRL_LIGAS_LOG_CREAR = "Creando liga: {NOMBRE}";
  static const String CTRL_LIGAS_LOG_OBTENER_ACTIVAS =
      "Obteniendo ligas activas";
  static const String CTRL_LIGAS_LOG_RECUPERAR =
      "Recuperando liga por id: {LIGA}";
  static const String CTRL_LIGAS_LOG_BUSCAR =
      "Buscando ligas con texto: '{TEXTO}'";
  static const String CTRL_LIGAS_LOG_EDITAR = "Editando liga: {LIGA}";
  static const String CTRL_LIGAS_LOG_ARCHIVAR = "Archivando liga: {LIGA}";
  static const String CTRL_LIGAS_LOG_ACTIVAR = "Activando liga: {LIGA}";
  static const String CTRL_LIGAS_LOG_ELIMINAR = "Eliminando liga: {LIGA}";

  // ---------------------------------------------------------------------------
  // Controlador: Puntajes Reales
  // Archivo: controlador_puntajes_reales.dart
  // Prefijo: CTRL_PUNTAJES_REALES_
  // ---------------------------------------------------------------------------
  static const String CTRL_PUNTAJES_REALES_LOG_OBTENER_JUGADORES =
      "Obteniendo jugadores reales por equipo para liga {LIGA}";
  static const String CTRL_PUNTAJES_REALES_LOG_GUARDAR =
      "Guardando puntajes para fecha {FECHA} (Liga {LIGA})";
  static const String CTRL_PUNTAJES_REALES_ERROR_RANGO =
      "El puntaje del jugador real {JUGADOR} debe estar entre 1 y 10.";
  static const String CTRL_PUNTAJES_REALES_ERROR_JUGADOR_NO_ENCONTRADO =
      "Jugador real no encontrado o no activo: {JUGADOR}";
  static const String CTRL_PUNTAJES_REALES_LOG_COMPLETITUD =
      "Verificando completitud de puntajes en fecha {FECHA} (Liga {LIGA})";
  static const String CTRL_PUNTAJES_REALES_LOG_OBTENER_MAPA =
      "Obteniendo mapa de puntajes reales para liga {LIGA}, fecha {FECHA}";

  // ---------------------------------------------------------------------------
  // Pantalla: Inicio Desktop para usuarios
  // Archivo: pagina_inicio_desktop.dart
  // Prefijo: INICIO_DESKTOP_
  // ---------------------------------------------------------------------------

  static const INICIO_DESKTOP_APPBAR_TITULO = "FantasyPro - Usuario";
  static const INICIO_DESKTOP_TOOLTIP_CERRAR_SESION = "Cerrar sesión";
  static const INICIO_DESKTOP_TEXTO_BIENVENIDA = "Bienvenido";

  // ---------------------------------------------------------------------------
  // Pantalla: Login Web Desktop
  // Archivo: pagina_login_desktop.dart
  // Prefijo: LOGIN_DESKTOP_
  // ---------------------------------------------------------------------------

  static const LOGIN_DESKTOP_TITULO = "LOGIN - FANTASYPRO";
  static const LOGIN_DESKTOP_INPUT_EMAIL = "Correo";
  static const LOGIN_DESKTOP_INPUT_PASSWORD = "Contraseña";
  static const LOGIN_DESKTOP_BOTON_INICIAR = "Iniciar sesión";
  static const LOGIN_DESKTOP_BOTON_REGISTRAR =
      "¿No tienes cuenta? Registrar usuario";
  static const LOGIN_DESKTOP_MENSAJE_LOGIN_OK = "Inicio correcto. UID: {UID}";
  static const LOGIN_DESKTOP_MENSAJE_LOGIN_ERROR = "Login incorrecto.";

  // ---------------------------------------------------------------------------
  // Pantalla: Panel Administrador Web Desktop
  // Archivo: pagina_panel_admin_desktop.dart
  // Prefijo: ADMIN_PANEL_DESKTOP_
  // ---------------------------------------------------------------------------

  static const ADMIN_PANEL_DESKTOP_TITULO = "Panel Administrador";
  static const ADMIN_PANEL_DESKTOP_BOTON_LIGAS = "Administrar ligas";
  static const ADMIN_PANEL_DESKTOP_TOOLTIP_LOGOUT = "Cerrar sesión";
  static const ADMIN_PANEL_DESKTOP_MENSAJE_SALUDO = "Bienvenido, administrador";
  static const String ADMIN_PANEL_DESKTOP_LOADER_CARGANDO_DATOS =
      "Cargando datos...";
  static const String ADMIN_PANEL_DESKTOP_DIALOGO_CARGA_TITULO =
      "Carga completada – {LIGA}";
  static const String ADMIN_PANEL_DESKTOP_DIALOGO_CARGA_MENSAJE =
      "Los datos fueron cargados correctamente.";
  static const String ADMIN_PANEL_DESKTOP_DIALOGO_BOTON_OK = "OK";
  static const String ADMIN_PANEL_DESKTOP_DIALOGO_ERROR_TITULO = "Error";
  static const String ADMIN_PANEL_DESKTOP_DIALOGO_ERROR_MENSAJE =
      "No se pudo completar la carga: {DETALLE}";
  static const String ADMIN_PANEL_DESKTOP_DIALOGO_BOTON_CERRAR = "Cerrar";
  static const String ADMIN_PANEL_DESKTOP_BOTON_CARGA_ESPANA =
      "Carga Masiva – España";
  static const String ADMIN_PANEL_DESKTOP_BOTON_CARGA_ITALIA =
      "Carga Masiva – Italia";
  static const String ADMIN_PANEL_DESKTOP_BOTON_CARGA_INGLATERRA =
      "Carga Masiva – Inglaterra";
  static const String ADMIN_PANEL_DESKTOP_NOMBRE_LIGA_ESPANA = "Liga Española";
  static const String ADMIN_PANEL_DESKTOP_NOMBRE_LIGA_ITALIA = "Liga Italiana";
  static const String ADMIN_PANEL_DESKTOP_NOMBRE_LIGA_INGLATERRA =
      "Liga Inglesa";

  // ---------------------------------------------------------------------------
  // Pantalla: Registro de usuario Web Desktop
  // Archivo: pagina_registro_desktop.dart
  // Prefijo: REGISTRO_DESKTOP_
  // ---------------------------------------------------------------------------

  static const REGISTRO_DESKTOP_TITULO = "Registrar usuario";
  static const REGISTRO_DESKTOP_INPUT_NOMBRE = "Nombre completo";
  static const REGISTRO_DESKTOP_INPUT_CORREO = "Correo";
  static const REGISTRO_DESKTOP_INPUT_PASSWORD = "Contraseña";
  static const REGISTRO_DESKTOP_ROL_USUARIO = "Usuario";
  static const REGISTRO_DESKTOP_ROL_ADMIN = "Administrador";
  static const REGISTRO_DESKTOP_BOTON_REGISTRAR = "Registrar";
  static const REGISTRO_DESKTOP_MENSAJE_OK = "Usuario creado correctamente";
  static const REGISTRO_DESKTOP_MENSAJE_ERROR = "Error al crear usuario";
  static const REGISTRO_DESKTOP_TOOLTIP_VOLVER = "Volver";

  // ---------------------------------------------------------------------------
  // Pantalla: Administración de Ligas (Desktop)
  // Archivo: pagina_ligas_admin_desktop.dart
  // Prefijo: LIGAS_ADMIN_DESKTOP_
  // ---------------------------------------------------------------------------

  static const LIGAS_ADMIN_DESKTOP_APPBAR_TITULO = "Administración de Ligas";
  static const LIGAS_ADMIN_DESKTOP_APPBAR_INDICADOR = "Gestión de ligas";
  static const LIGAS_ADMIN_DESKTOP_TOOLTIP_VOLVER = "Volver";
  static const LIGAS_ADMIN_DESKTOP_BOTON_CREAR = "Crear nueva liga";
  static const LIGAS_ADMIN_DESKTOP_INPUT_NOMBRE = "Nombre de la liga";
  static const LIGAS_ADMIN_DESKTOP_INPUT_DESCRIPCION = "Descripción";
  static const LIGAS_ADMIN_DESKTOP_ACCION_CANCELAR = "Cancelar";
  static const LIGAS_ADMIN_DESKTOP_ACCION_CREAR = "Crear";
  static const LIGAS_ADMIN_DESKTOP_TOOLTIP_ADMIN_EQUIPOS =
      "Administrar equipos";
  static const LIGAS_ADMIN_DESKTOP_TOOLTIP_ARCHIVAR = "Archivar";
  static const LIGAS_ADMIN_DESKTOP_TOOLTIP_ACTIVAR = "Activar";
  static const LIGAS_ADMIN_DESKTOP_TOOLTIP_ELIMINAR = "Eliminar liga";

  // Títulos de columnas con contador dinámico
  static const LIGAS_ADMIN_DESKTOP_TITULO_ACTIVAS = "Activas ({CANT})";
  static const LIGAS_ADMIN_DESKTOP_TITULO_ARCHIVADAS = "Archivadas ({CANT})";

  // ---------------------------------------------------------------------------
  // Pantalla: Edición de equipo
  // Archivo: pagina_equipo_editar_desktop.dart
  // Prefijo: EQUIPO_EDITAR_
  // ---------------------------------------------------------------------------

  static const EQUIPO_EDITAR_TITULO = "Editar equipo";
  static const EQUIPO_EDITAR_BOTON_VOLVER = "Volver";

  static const EQUIPO_EDITAR_LABEL_NOMBRE = "Nombre del equipo";
  static const EQUIPO_EDITAR_LABEL_DESCRIPCION = "Descripción";
  static const EQUIPO_EDITAR_LABEL_ESCUDO = "URL del escudo (opcional)";

  static const EQUIPO_EDITAR_BOTON_GUARDAR = "Guardar cambios";

  static const EQUIPO_EDITAR_VALIDACION_NOMBRE_VACIO =
      "El nombre del equipo no puede estar vacío.";

  static const EQUIPO_EDITAR_DIALOGO_DESCARTAR_TITULO = "Descartar cambios";
  static const EQUIPO_EDITAR_DIALOGO_DESCARTAR_MENSAJE =
      "Hay cambios sin guardar. ¿Desea salir igualmente?";
  static const EQUIPO_EDITAR_DIALOGO_DESCARTAR_BOTON_CANCELAR = "Cancelar";
  static const EQUIPO_EDITAR_DIALOGO_DESCARTAR_BOTON_SALIR = "Salir";

  // ---------------------------------------------------------------------------
  // Pantalla: Administración de equipos de una liga
  // Archivo: pagina_equipos_admin_desktop.dart
  // Prefijo: EQUIPOS_ADMIN_
  // ---------------------------------------------------------------------------

  // AppBar
  static const EQUIPOS_ADMIN_APPBAR_TITULO = "Equipos – {LIGA}";
  static const EQUIPOS_ADMIN_APPBAR_VOLVER = "Volver";
  static const EQUIPOS_ADMIN_APPBAR_GESTION_TEXTO = "Gestión de equipos";

  // Crear equipo
  static const EQUIPOS_ADMIN_CREAR_TITULO = "Crear equipo en {LIGA}";
  static const EQUIPOS_ADMIN_CREAR_LABEL_NOMBRE = "Nombre del equipo";
  static const EQUIPOS_ADMIN_CREAR_LABEL_DESCRIPCION = "Descripción";
  static const EQUIPOS_ADMIN_CREAR_BOTON_CANCELAR = "Cancelar";
  static const EQUIPOS_ADMIN_CREAR_BOTON_CREAR = "Crear";

  // Confirmaciones
  static const EQUIPOS_ADMIN_CONFIRMAR_TITULO = "Confirmación";
  static const EQUIPOS_ADMIN_CONFIRMAR_CANCELAR = "Cancelar";
  static const EQUIPOS_ADMIN_CONFIRMAR_ACEPTAR = "Aceptar";

  static const EQUIPOS_ADMIN_CONFIRMAR_ARCHIVAR = "¿Desea archivar el equipo?";
  static const EQUIPOS_ADMIN_CONFIRMAR_ACTIVAR = "¿Desea activar el equipo?";
  static const EQUIPOS_ADMIN_CONFIRMAR_ELIMINAR =
      "¿Está seguro que desea eliminar este equipo?";

  // Tooltips
  static const EQUIPOS_ADMIN_TOOLTIP_GESTION_JUGADORES =
      "Gestionar jugadores (próximamente)";
  static const EQUIPOS_ADMIN_TOOLTIP_EDITAR = "Editar equipo";
  static const EQUIPOS_ADMIN_TOOLTIP_ARCHIVAR = "Archivar";
  static const EQUIPOS_ADMIN_TOOLTIP_ACTIVAR = "Activar";
  static const EQUIPOS_ADMIN_TOOLTIP_ELIMINAR = "Eliminar equipo";

  // Columnas
  static const EQUIPOS_ADMIN_COLUMNA_ACTIVOS = "Activos ({CANT})";
  static const EQUIPOS_ADMIN_COLUMNA_ARCHIVADOS = "Archivados ({CANT})";

  // ---------------------------------------------------------------------------
  // Pantalla: Edición de jugador
  // Archivo: pagina_jugador_editar_desktop.dart
  // Prefijo: JUGADOR_EDITAR_
  // ---------------------------------------------------------------------------

  static const JUGADOR_EDITAR_TITULO = "Editar jugador";
  static const JUGADOR_EDITAR_BOTON_VOLVER = "Volver";

  static const JUGADOR_EDITAR_LABEL_NOMBRE = "Nombre";
  static const JUGADOR_EDITAR_LABEL_POSICION = "Posición";
  static const JUGADOR_EDITAR_LABEL_NACIONALIDAD = "Nacionalidad";
  static const JUGADOR_EDITAR_LABEL_DORSAL = "Dorsal (opcional)";
  static const String JUGADOR_EDITAR_LABEL_VALOR_MERCADO =
      "Valor de mercado (1 a 1000)";
  static const String JUGADOR_EDITAR_OPCION_POSICION_POR = "POR";
  static const String JUGADOR_EDITAR_OPCION_POSICION_DEF = "DEF";
  static const String JUGADOR_EDITAR_OPCION_POSICION_MED = "MED";
  static const String JUGADOR_EDITAR_OPCION_POSICION_DEL = "DEL";
  static const String JUGADOR_EDITAR_VALIDACION_CAMPOS =
      "Verifique los campos obligatorios.";

  static const JUGADOR_EDITAR_BOTON_GUARDAR = "Guardar cambios";

  static const JUGADOR_EDITAR_VALIDACION_OBLIGATORIOS =
      "Los campos Nombre y Posición son obligatorios.";

  static const JUGADOR_EDITAR_DIALOGO_DESCARTAR_TITULO = "Descartar cambios";
  static const JUGADOR_EDITAR_DIALOGO_DESCARTAR_MENSAJE =
      "Hay cambios sin guardar. ¿Desea salir igualmente?";
  static const JUGADOR_EDITAR_DIALOGO_DESCARTAR_BOTON_CANCELAR = "Cancelar";
  static const JUGADOR_EDITAR_DIALOGO_DESCARTAR_BOTON_SALIR = "Salir";

  // ---------------------------------------------------------------------------
  // Pantalla: Administración de jugadores de un equipo
  // Archivo: pagina_jugadores_admin_desktop.dart
  // Prefijo: JUGADORES_ADMIN_
  // ---------------------------------------------------------------------------

  // AppBar
  static const JUGADORES_ADMIN_APPBAR_TITULO = "Jugadores — {EQUIPO}";
  static const JUGADORES_ADMIN_APPBAR_VOLVER = "Volver";
  static const JUGADORES_ADMIN_APPBAR_GESTION_TEXTO = "Gestión de jugadores";

  // Crear jugador
  static const JUGADORES_ADMIN_CREAR_TITULO = "Crear jugador en {EQUIPO}";
  static const JUGADORES_ADMIN_CREAR_LABEL_NOMBRE = "Nombre";
  static const JUGADORES_ADMIN_CREAR_LABEL_POSICION = "Posición";
  static const JUGADORES_ADMIN_CREAR_LABEL_NACIONALIDAD = "Nacionalidad";
  static const JUGADORES_ADMIN_CREAR_LABEL_DORSAL = "Dorsal (opcional)";
  static const String JUGADORES_ADMIN_CREAR_LABEL_VALOR_MERCADO =
      "Valor de mercado";
  static const JUGADORES_ADMIN_CREAR_BOTON_CANCELAR = "Cancelar";
  static const JUGADORES_ADMIN_CREAR_BOTON_CREAR = "Crear";

  // Validación
  static const JUGADORES_ADMIN_VALIDACION_OBLIGATORIOS =
      "Los campos Nombre y Posición son obligatorios.";
  static const String
      JUGADORES_ADMIN_VALIDACION_CAMPOS_OBLIGATORIOS_GENERICO =
      "Los campos obligatorios deben ser válidos.";

  // Confirmaciones
  static const JUGADORES_ADMIN_CONFIRMAR_TITULO = "Confirmación";
  static const JUGADORES_ADMIN_CONFIRMAR_CANCELAR = "Cancelar";
  static const JUGADORES_ADMIN_CONFIRMAR_ACEPTAR = "Aceptar";

  static const JUGADORES_ADMIN_CONFIRMAR_ARCHIVAR =
      "¿Desea archivar el jugador?";
  static const JUGADORES_ADMIN_CONFIRMAR_ACTIVAR = "¿Desea activar el jugador?";
  static const JUGADORES_ADMIN_CONFIRMAR_ELIMINAR =
      "¿Seguro que desea eliminar este jugador?";

  // Tooltips
  static const JUGADORES_ADMIN_TOOLTIP_EDITAR = "Editar jugador";
  static const JUGADORES_ADMIN_TOOLTIP_ARCHIVAR = "Archivar";
  static const JUGADORES_ADMIN_TOOLTIP_ACTIVAR = "Activar";
  static const JUGADORES_ADMIN_TOOLTIP_ELIMINAR = "Eliminar jugador";

  // Columnas
  static const JUGADORES_ADMIN_COLUMNA_ACTIVOS = "Activos ({CANT})";
  static const JUGADORES_ADMIN_COLUMNA_ARCHIVADOS = "Archivados ({CANT})";
  static const String JUGADORES_ADMIN_SUBTITULO_ITEM =
      "{POSICION} • {NACIONALIDAD} • {VALOR}";

  // -----------------------------------------------------------------------------
  // Pantalla: Dashboard del usuario (versión desktop)
  // Archivo: ui__usuario__dashboard__desktop.dart
  // Prefijo: USUARIO_DASHBOARD_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String USUARIO_DASHBOARD_DESKTOP_ERROR_SIN_USUARIO =
      "No hay usuario autenticado.";
  static const String USUARIO_DASHBOARD_DESKTOP_ERROR_CARGA_PARTICIPACIONES =
      "No se pudieron cargar tus participaciones.";
  static const String USUARIO_DASHBOARD_DESKTOP_SUBTITULO_PARTICIPACION =
      "Equipo: {EQUIPO} — Puntos: {PUNTOS}";
  static const String USUARIO_DASHBOARD_DESKTOP_BOTON_VER_RESULTADOS =
      "Ver resultados";
  static const String USUARIO_DASHBOARD_DESKTOP_TITULO_APPBAR =
      "FantasyPro — Inicio";
  static const String USUARIO_DASHBOARD_DESKTOP_TEXTO_BIENVENIDA =
      "Bienvenido a FantasyPro";
  static const String USUARIO_DASHBOARD_DESKTOP_BOTON_CREAR_EQUIPOS =
      "Crear equipos";
  static const String USUARIO_DASHBOARD_DESKTOP_TITULO_VER_RESULTADOS =
      "Ver resultados";
  static const String USUARIO_DASHBOARD_DESKTOP_MENSAJE_SIN_EQUIPOS =
      "Aún no tienes equipos registrados. Crea uno para comenzar.";

  // -----------------------------------------------------------------------------
  // Pantalla: Lista de ligas activas (versión desktop)
  // Archivo: ui__usuario__inicio__lista__desktop.dart
  // Prefijo: USUARIO_INICIO_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String USUARIO_INICIO_DESKTOP_ERROR_CARGA_LIGAS =
      "Error al cargar las ligas activas.";
  static const String USUARIO_INICIO_DESKTOP_ERROR_BUSQUEDA =
      "Error al realizar la búsqueda.";
  static const String USUARIO_INICIO_DESKTOP_SUBTITULO_TEMPORADA =
      "Temporada: {TEMPORADA}";
  static const String USUARIO_INICIO_DESKTOP_BOTON_UNIRSE = "Unirse";
  static const String USUARIO_INICIO_DESKTOP_TITULO_APPBAR =
      "FantasyPro — Ligas activas";
  static const String USUARIO_INICIO_DESKTOP_LABEL_BUSCAR = "Buscar ligas";
  static const String USUARIO_INICIO_DESKTOP_SIN_LIGAS =
      "No hay ligas disponibles.";

  // -----------------------------------------------------------------------------
  // Pantalla: Resultados por fecha (versión desktop)
  // Archivo: ui__usuario__resultados_por_fecha__desktop.dart
  // Prefijo: USUARIO_RESULTADOS_POR_FECHA_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_ERROR_CARGA =
      "No se pudieron cargar los resultados.";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SIN_PUNTAJE = "–";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SIN_PARTICIPACION =
      "El usuario no tiene participación en la liga";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_FECHA_CERRADA =
      "Fecha cerrada";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_FECHA_PENDIENTE =
      "Fecha pendiente";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_TITULO_FECHA =
      "{NUMERO}. {NOMBRE}";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_BOTON_VER_DETALLE =
      "Ver detalle de jugadores";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_TITULO_APPBAR =
      "Resultados por fecha — {LIGA}";
  static const String
  USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SIN_PARTICIPACION_TITULO =
      "Sin participación registrada";
  static const String USUARIO_RESULTADOS_POR_FECHA_DESKTOP_SUBTITULO_LISTA =
      "Puntaje obtenido por fecha";

  // -----------------------------------------------------------------------------
  // Pantalla: Resultados por jugador (versión desktop)
  // Archivo: ui__usuario__resultados__detalle_jugadores__desktop.dart
  // Prefijo: USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_SIN_PUNTAJE =
      "No hay puntaje registrado para esta fecha.";
  static const String USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_ERROR_CARGA =
      "Error al cargar el detalle de jugadores.";
  static const String USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_TITULO =
      "Resultados por jugador";
  static const String
  USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_TITULO_FECHA =
      "{NUMERO}. {NOMBRE}";
  static const String
  USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_EQUIPO_FANTASY =
      "Equipo fantasy";
  static const String
  USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_PUNTAJE_TOTAL =
      "Puntaje total: {PUNTAJE}";
  static const String
      USUARIO_RESULTADOS_DETALLE_JUGADORES_DESKTOP_SUBTITULO_JUGADOR =
      "Equipo: {EQUIPO} — Posición: {POSICION}";

  // -----------------------------------------------------------------------------
  // Pantalla: Edición de alineación (admin, desktop)
  // Archivo: ui__admin__alineacion__editar__desktop.dart
  // Prefijo: ADMIN_ALINEACION_EDITAR_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_TITULO =
      "Editar alineación";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_TOOLTIP_VOLVER =
      "Volver";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_DIALOGO_DESCARTAR_TITULO =
      "Descartar cambios";
  static const String
      ADMIN_ALINEACION_EDITAR_DESKTOP_DIALOGO_DESCARTAR_CONTENIDO =
      "Hay cambios sin guardar. ¿Desea salir igualmente?";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_MENSAJE_SIN_JUGADORES =
      "Debe incluir al menos un jugador.";
  static const String
      ADMIN_ALINEACION_EDITAR_DESKTOP_MENSAJE_FORMATO_INVALIDO =
      "Formato inválido de jugadores.";
  static const String
      ADMIN_ALINEACION_EDITAR_DESKTOP_MENSAJE_PUNTOS_NEGATIVOS =
      "Los puntos no pueden ser negativos.";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_LABEL_FORMACION =
      "Formación:";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_OPCION_FORMACION_442 =
      "4-4-2";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_OPCION_FORMACION_433 =
      "4-3-3";
  static const String
      ADMIN_ALINEACION_EDITAR_DESKTOP_LABEL_IDS_JUGADORES =
      "IDs de jugadores (separados por coma)";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_HINT_IDS_JUGADORES =
      "ej: j1,j2,j3,j4";
  static const String ADMIN_ALINEACION_EDITAR_DESKTOP_LABEL_PUNTOS_TOTALES =
      "Puntos totales";

  // -----------------------------------------------------------------------------
  // Pantalla: Lista de alineaciones (admin, desktop)
  // Archivo: ui__admin__alineacion__lista__desktop.dart
  // Prefijo: ADMIN_ALINEACION_LISTA_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_ALINEACION_LISTA_DESKTOP_DIALOGO_CREAR_TITULO =
      "Crear nueva alineación";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_LABEL_FORMACION =
      "Formación:";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_OPCION_FORMACION_442 =
      "4-4-2";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_OPCION_FORMACION_433 =
      "4-3-3";
  static const String
      ADMIN_ALINEACION_LISTA_DESKTOP_LABEL_ID_EQUIPO_FANTASY =
      "ID del equipo fantasy";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_LABEL_IDS_JUGADORES =
      "IDs de jugadores (separados por coma)";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_HINT_IDS_JUGADORES =
      "ej: j1,j2,j3,j4,j5";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_LABEL_PUNTOS_INICIALES =
      "Puntos iniciales (opcional)";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_ERROR_CAMPOS_REQUERIDOS =
      "Debe ingresar jugadores y ID de equipo.";
  static const String
      ADMIN_ALINEACION_LISTA_DESKTOP_ERROR_FORMATO_JUGADORES =
      "Formato inválido para los IDs de jugadores.";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TITULO_ITEM =
      "Alineación {ID}";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_SUBTITULO_ITEM =
      "Formación: {FORMACION} • Jugadores: {CANT_JUGADORES} • Puntos: {PUNTOS}";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TOOLTIP_EDITAR =
      "Editar alineación";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TOOLTIP_ARCHIVAR =
      "Archivar";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TOOLTIP_ACTIVAR =
      "Activar";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_MENSAJE_ARCHIVAR =
      "¿Desea archivar esta alineación?";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_MENSAJE_ACTIVAR =
      "¿Desea activar esta alineación?";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TOOLTIP_ELIMINAR =
      "Eliminar alineación";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_MENSAJE_ELIMINAR =
      "¿Eliminar esta alineación definitivamente?";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TITULO_APPBAR =
      "Alineaciones — Usuario {USUARIO}";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TOOLTIP_VOLVER = "Volver";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TEXTO_GESTION =
      "Gestión de alineaciones";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TITULO_ACTIVAS =
      "Activas ({CANT})";
  static const String ADMIN_ALINEACION_LISTA_DESKTOP_TITULO_ARCHIVADAS =
      "Archivadas ({CANT})";

  // -----------------------------------------------------------------------------
  // Pantalla: Edición de equipo real (admin, desktop)
  // Archivo: ui__admin__equipo_real__editar__desktop.dart
  // Prefijo: ADMIN_EQUIPO_REAL_EDITAR_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_EQUIPO_REAL_EDITAR_DESKTOP_TITULO =
      "Editar equipo real";
  static const String ADMIN_EQUIPO_REAL_EDITAR_DESKTOP_LABEL_NOMBRE = "Nombre";
  static const String
      ADMIN_EQUIPO_REAL_EDITAR_DESKTOP_LABEL_DESCRIPCION = "Descripción";

  // -----------------------------------------------------------------------------
  // Pantalla: Lista de equipos reales (admin, desktop)
  // Archivo: ui__admin__equipo_real__lista__desktop.dart
  // Prefijo: ADMIN_EQUIPO_REAL_LISTA_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_EQUIPO_REAL_LISTA_DESKTOP_TITULO_APPBAR =
      "Equipos reales — {LIGA}";
  static const String ADMIN_EQUIPO_REAL_LISTA_DESKTOP_DIALOGO_CREAR_TITULO =
      "Crear equipo real";
  static const String ADMIN_EQUIPO_REAL_LISTA_DESKTOP_LABEL_NOMBRE = "Nombre";
  static const String ADMIN_EQUIPO_REAL_LISTA_DESKTOP_LABEL_DESCRIPCION =
      "Descripción";
  static const String ADMIN_EQUIPO_REAL_LISTA_DESKTOP_TOOLTIP_GESTION_JUGADORES =
      "Gestionar jugadores";
  static const String ADMIN_EQUIPO_REAL_LISTA_DESKTOP_TITULO_ACTIVOS =
      "Activos ({CANT})";
  static const String ADMIN_EQUIPO_REAL_LISTA_DESKTOP_TITULO_ARCHIVADOS =
      "Archivados ({CANT})";

  // -----------------------------------------------------------------------------
  // Pantalla: Lista de fechas (admin, desktop)
  // Archivo: ui__admin__fecha__lista__desktop.dart
  // Prefijo: ADMIN_FECHA_LISTA_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_TITULO =
      "Cerrar fecha";
  static const String ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_CONTENIDO =
      "¿Desea cerrar la fecha {NUMERO}? Esta acción no puede revertirse.";
  static const String ADMIN_FECHA_LISTA_DESKTOP_BOTON_CERRAR = "Cerrar";
  static const String
      ADMIN_FECHA_LISTA_DESKTOP_SNACKBAR_FECHA_CERRADA_OK =
      "Fecha cerrada exitosamente";
  static const String ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_ERROR_TITULO =
      "No se puede cerrar la fecha";
  static const String
      ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CERRAR_ERROR_CONTENIDO =
      "Faltan puntajes por cargar. Complete los puntajes y vuelva a intentarlo.";
  static const String ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CREAR_TITULO =
      "Crear nueva fecha";
  static const String ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_CREAR_CONTENIDO =
      "¿Desea abrir una nueva fecha para esta liga?";
  static const String ADMIN_FECHA_LISTA_DESKTOP_SNACKBAR_SIMULACION_OK =
      "Simulación completa: todos los jugadores recibieron puntajes.";
  static const String ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_SIMULACION_ERROR_TITULO =
      "Error durante la simulación";
  static const String
      ADMIN_FECHA_LISTA_DESKTOP_DIALOGO_SIMULACION_ERROR_CONTENIDO =
      "Ocurrió un error al generar o guardar los puntajes simulados:\n{DETALLE}";
  static const String ADMIN_FECHA_LISTA_DESKTOP_ITEM_FECHA_CERRADA_TITULO =
      "Fecha {NUMERO} — {NOMBRE}";
  static const String ADMIN_FECHA_LISTA_DESKTOP_ITEM_FECHA_CERRADA_ESTADO =
      "Estado: Cerrada";
  static const String ADMIN_FECHA_LISTA_DESKTOP_TITULO_APPBAR =
      "Fechas — {LIGA}";
  static const String ADMIN_FECHA_LISTA_DESKTOP_TITULO_FECHA_ACTIVA =
      "Fecha activa — {NOMBRE}";
  static const String ADMIN_FECHA_LISTA_DESKTOP_SUBTITULO_FECHA_ACTIVA =
      "Número: {NUMERO}";
  static const String ADMIN_FECHA_LISTA_DESKTOP_BOTON_CARGAR_PUNTAJES =
      "Cargar puntajes";
  static const String ADMIN_FECHA_LISTA_DESKTOP_BOTON_CERRAR_FECHA =
      "Cerrar fecha";
  static const String ADMIN_FECHA_LISTA_DESKTOP_BOTON_SIMULAR_PUNTAJES =
      "Simular carga de puntajes reales";
  static const String ADMIN_FECHA_LISTA_DESKTOP_MENSAJE_SIN_FECHA_ACTIVA =
      "No hay fecha activa";
  static const String ADMIN_FECHA_LISTA_DESKTOP_TITULO_FECHAS_CERRADAS =
      "Fechas cerradas";

  // -----------------------------------------------------------------------------
  // Pantalla: Lista de ligas (admin, desktop)
  // Archivo: ui__admin__liga__lista__desktop.dart
  // Prefijo: ADMIN_LIGA_LISTA_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_LIGA_LISTA_DESKTOP_TITULO_APPBAR = "Ligas";
  static const String ADMIN_LIGA_LISTA_DESKTOP_TEXTO_GESTION =
      "Gestión de ligas";
  static const String ADMIN_LIGA_LISTA_DESKTOP_DIALOGO_CREAR_TITULO =
      "Crear liga";
  static const String ADMIN_LIGA_LISTA_DESKTOP_LABEL_NOMBRE = "Nombre";
  static const String ADMIN_LIGA_LISTA_DESKTOP_LABEL_DESCRIPCION =
      "Descripción";
  static const String ADMIN_LIGA_LISTA_DESKTOP_LABEL_TOTAL_FECHAS =
      "Total de fechas (34–50)";
  static const String ADMIN_LIGA_LISTA_DESKTOP_ERROR_NOMBRE_OBLIGATORIO =
      "El nombre es obligatorio";
  static const String ADMIN_LIGA_LISTA_DESKTOP_ERROR_RANGO_FECHAS =
      "Debe estar entre 34 y 50";
  static const String ADMIN_LIGA_LISTA_DESKTOP_SUBTITULO_FECHAS =
      "Fechas: {CREADAS}/{TOTAL}";
  static const String ADMIN_LIGA_LISTA_DESKTOP_TITULO_ACTIVAS =
      "Activas ({CANT})";
  static const String ADMIN_LIGA_LISTA_DESKTOP_TITULO_ARCHIVADAS =
      "Archivadas ({CANT})";

  // -----------------------------------------------------------------------------
  // Pantalla: Edición de participación (admin, desktop)
  // Archivo: ui__admin__participacion__editar__desktop.dart
  // Prefijo: ADMIN_PARTICIPACION_EDITAR_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_PARTICIPACION_EDITAR_DESKTOP_TITULO =
      "Editar participación";
  static const String ADMIN_PARTICIPACION_EDITAR_DESKTOP_ERROR_NOMBRE =
      "El nombre no puede estar vacío.";
  static const String ADMIN_PARTICIPACION_EDITAR_DESKTOP_ERROR_PUNTOS =
      "Los puntos no pueden ser negativos.";
  static const String ADMIN_PARTICIPACION_EDITAR_DESKTOP_LABEL_ID_USUARIO =
      "ID Usuario";
  static const String
      ADMIN_PARTICIPACION_EDITAR_DESKTOP_LABEL_NOMBRE_EQUIPO_FANTASY =
      "Nombre del equipo fantasy";
  static const String ADMIN_PARTICIPACION_EDITAR_DESKTOP_LABEL_PUNTOS =
      "Puntos";

  // -----------------------------------------------------------------------------
  // Pantalla: Lista de participaciones (admin, desktop)
  // Archivo: ui__admin__participacion__lista__desktop.dart
  // Prefijo: ADMIN_PARTICIPACION_LISTA_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_DIALOGO_CREAR_TITULO =
      "Crear participación en {LIGA}";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_LABEL_ID_USUARIO =
      "ID de usuario";
  static const String
      ADMIN_PARTICIPACION_LISTA_DESKTOP_LABEL_NOMBRE_EQUIPO_FANTASY =
      "Nombre del equipo fantasy";
  static const String
      ADMIN_PARTICIPACION_LISTA_DESKTOP_ERROR_CAMPOS_OBLIGATORIOS =
      "El usuario y el nombre del equipo no pueden estar vacíos.";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TITULO_APPBAR =
      "Participantes — {LIGA}";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_VOLVER =
      "Volver";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TEXTO_GESTION =
      "Gestión de participaciones";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TITULO_ACTIVOS =
      "Activos ({CANT})";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TITULO_ARCHIVADOS =
      "Archivados ({CANT})";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_SUBTITULO_USUARIO =
      "Usuario: {ID_USUARIO}";
  static const String
      ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_GESTION_ALINEACIONES =
      "Gestionar alineaciones";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_EDITAR =
      "Editar participación";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_ARCHIVAR =
      "Archivar";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_ACTIVAR =
      "Activar";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_MENSAJE_ARCHIVAR =
      "¿Archivar esta participación?";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_MENSAJE_ACTIVAR =
      "¿Activar esta participación?";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_TOOLTIP_ELIMINAR =
      "Eliminar participación";
  static const String ADMIN_PARTICIPACION_LISTA_DESKTOP_MENSAJE_ELIMINAR =
      "¿Eliminar esta participación definitivamente?";

  // -----------------------------------------------------------------------------
  // Pantalla: Lista de puntajes reales (admin, desktop)
  // Archivo: ui__admin__puntajes_reales__lista__desktop.dart
  // Prefijo: ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_SNACKBAR_GUARDADO =
      "Puntajes guardados";
  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TITULO_APPBAR =
      "Puntajes reales — Fecha {NUMERO}";
  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_LIGA =
      "Liga: {LIGA}";
  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_FECHA =
      "Fecha: {NOMBRE} (N° {NUMERO})";
  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TITULO_JUGADOR =
      "{NOMBRE} ({POSICION}{DORSAL})";
  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_DORSAL =
      " - #{DORSAL}";
  static const String
      ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_MENSAJE_FECHA_CERRADA =
      "La fecha está cerrada. Los puntajes no pueden modificarse.";
  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_HINT_EQUIPO =
      "Seleccionar equipo";
  static const String ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_TEXTO_PUNTAJE_REAL =
      "Puntaje real";
  static const String
      ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_HINT_PUNTAJE_JUGADOR =
      "Seleccione";
  static const String
      ADMIN_PUNTAJES_REALES_LISTA_DESKTOP_LABEL_GUARDAR_PUNTAJES =
      "Guardar puntajes";
}
