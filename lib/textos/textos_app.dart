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
  // Logs - Aplicación
  // ---------------------------------------------------------------------------
  static const LOG_APP_INICIANDO_FIREBASE = "Iniciando carga de Firebase...";
  static const LOG_APP_PLATAFORMA_DETECTADA = "Plataforma detectada:";

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
  static const LOG_LIGA_BUSCAR_NOMBRE = "Buscar ligas por nombre:";
  static const LOG_LIGA_EDITADA = "Liga editada:";
  static const LOG_LIGA_ERROR_EDITAR = "Error al editar liga:";
  static const LOG_LIGA_ARCHIVADA = "Liga archivada:";
  static const LOG_LIGA_ERROR_ARCHIVAR = "Error al archivar liga:";
  static const LOG_LIGA_ACTIVADA = "Liga activada:";
  static const LOG_LIGA_ERROR_ACTIVAR = "Error al activar liga:";
  static const LOG_LIGA_ELIMINADA = "Liga eliminada:";
  static const LOG_LIGA_ERROR_ELIMINAR = "Error al eliminar liga:";
  static const LOG_LIGA_LISTAR_ACTIVAS = "Listar ligas activas";
  static const LOG_LIGA_OBTENER = "Recuperando liga por id:";

  // ---------------------------------------------------------------------------
  // Logs – Equipos fantasy
  // ---------------------------------------------------------------------------
  static const LOG_EQUIPO_FANTASY_CREADO = "EquipoFantasy creado:";
  static const LOG_EQUIPO_FANTASY_EDITADO = "EquipoFantasy editado:";
  static const LOG_EQUIPO_FANTASY_ARCHIVADO = "EquipoFantasy archivado:";
  static const LOG_EQUIPO_FANTASY_ACTIVADO = "EquipoFantasy activado:";
  static const LOG_EQUIPO_FANTASY_ELIMINADO = "EquipoFantasy eliminado:";
  static const LOG_EQUIPO_FANTASY_LISTANDO_ACTIVOS =
      "Listando equipos fantasy activos de la liga";
  static const LOG_EQUIPO_FANTASY_PLANTEL_ACTUALIZADO =
      "EquipoFantasy actualizado (plantel inicial):";

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
  // Logs – Controladores: Alineaciones
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_ALINEACIONES_CREANDO =
      "Creando alineación para usuario";
  static const LOG_CTRL_ALINEACIONES_LISTANDO =
      "Listando alineaciones de usuario";
  static const LOG_CTRL_ALINEACIONES_ARCHIVANDO =
      "Archivando alineación";
  static const LOG_CTRL_ALINEACIONES_ACTIVANDO =
      "Activando alineación";
  static const LOG_CTRL_ALINEACIONES_ELIMINANDO =
      "Eliminando alineación";
  static const LOG_CTRL_ALINEACIONES_EDITANDO = "Editando alineación";
  static const LOG_CTRL_ALINEACIONES_GUARDAR_PLANTEL =
      "Guardando plantel inicial para usuario";
  static const LOG_CTRL_ALINEACIONES_BUSCAR_PARTICIPACION =
      "Buscando participación del usuario";
  static const LOG_CTRL_ALINEACIONES_PARTICIPACION_ENCONTRADA =
      "Participación encontrada:";
  static const LOG_CTRL_ALINEACIONES_PARTICIPACION_ACTUALIZADA =
      "Participación actualizada correctamente.";
  static const LOG_CTRL_ALINEACIONES_PARTICIPACION_MARCAR =
      "Marcando participación como plantelCompleto=true para";
  static const LOG_CTRL_ALINEACIONES_BUSCAR_ACTIVA =
      "Buscando alineación activa o más reciente para usuario";
  static const LOG_CTRL_ALINEACIONES_SIN_ACTIVA =
      "No hay alineación activa — devolviendo la más reciente:";

  // ---------------------------------------------------------------------------
  // Logs – Controladores: Equipos fantasy
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_EQUIPO_FANTASY_CREAR =
      "Creando equipo fantasy para usuario";
  static const LOG_CTRL_EQUIPO_FANTASY_DUPLICADO =
      "El usuario ya tiene un equipo en esta liga.";
  static const LOG_CTRL_EQUIPO_FANTASY_FECHA_ACTIVA =
      "No se puede crear equipo: ya existe una fecha activa en la liga.";
  static const LOG_CTRL_EQUIPO_FANTASY_LISTAR_USUARIO =
      "Listando equipos fantasy del usuario";
  static const LOG_CTRL_EQUIPO_FANTASY_LISTAR_LIGA =
      "Listando equipos fantasy del usuario";
  static const LOG_CTRL_EQUIPO_FANTASY_EDITAR = "Editando equipo fantasy";
  static const LOG_CTRL_EQUIPO_FANTASY_ARCHIVAR =
      "Archivando equipo fantasy";
  static const LOG_CTRL_EQUIPO_FANTASY_ACTIVAR = "Activando equipo fantasy";
  static const LOG_CTRL_EQUIPO_FANTASY_ELIMINAR = "Eliminando equipo fantasy";
  static const LOG_CTRL_EQUIPO_FANTASY_OBTENER =
      "Obteniendo equipo fantasy para usuario";
  static const LOG_CTRL_EQUIPO_FANTASY_GUARDAR_PLANTEL =
      "Guardando plantel inicial para equipo";
  static const LOG_CTRL_EQUIPO_FANTASY_PLANTEL_OK =
      "Plantel inicial guardado correctamente.";

  // ---------------------------------------------------------------------------
  // Logs – Controladores: Equipos reales
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_EQUIPO_REAL_CREAR =
      "Creando equipo real en liga";
  static const LOG_CTRL_EQUIPO_REAL_LISTAR =
      "Listando equipos reales de liga";
  static const LOG_CTRL_EQUIPO_REAL_EDITAR = "Editando equipo real";
  static const LOG_CTRL_EQUIPO_REAL_ACTIVAR = "Activando equipo real";
  static const LOG_CTRL_EQUIPO_REAL_ARCHIVAR = "Archivando equipo real";
  static const LOG_CTRL_EQUIPO_REAL_ELIMINAR = "Eliminando equipo real";

  // ---------------------------------------------------------------------------
  // Logs – Controladores: Fechas
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_FECHAS_CREAR = "Creando nueva fecha para liga";
  static const LOG_CTRL_FECHAS_ACTUALIZAR_CONTADOR =
      "Actualizando contador de fechas de la liga:";
  static const LOG_CTRL_FECHAS_OBTENER = "Obteniendo fechas de liga";
  static const LOG_CTRL_FECHAS_CERRAR = "Intentando cerrar fecha";
  static const LOG_CTRL_FECHAS_APLICAR_PUNTAJES =
      "Aplicando puntajes fantasy a participaciones de la liga";
  static const LOG_CTRL_FECHAS_ARCHIVAR_LIGA =
      "La última fecha fue cerrada; archivando liga";
  static const LOG_CTRL_FECHAS_CERRADA_OK = "Fecha cerrada correctamente.";

  // ---------------------------------------------------------------------------
  // Logs – Controladores: Jugadores reales
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_JUGADORES_REALES_CREAR =
      "Creando jugador real para equipo";
  static const LOG_CTRL_JUGADORES_REALES_LISTAR =
      "Listando jugadores reales de equipo";
  static const LOG_CTRL_JUGADORES_REALES_EDITAR = "Editando jugador real";
  static const LOG_CTRL_JUGADORES_REALES_ACTIVAR = "Activando jugador real";
  static const LOG_CTRL_JUGADORES_REALES_ARCHIVAR = "Archivando jugador real";
  static const LOG_CTRL_JUGADORES_REALES_ELIMINAR = "Eliminando jugador real";
  static const LOG_CTRL_JUGADORES_REALES_LISTA_ORDENADA =
      "Jugadores obtenidos (ordenados por posición)";
  static const LOG_CTRL_JUGADORES_REALES_OBTENER_IDS =
      "Obteniendo jugadores reales por IDs";
  static const LOG_CTRL_JUGADORES_REALES_OBTENIDOS_IDS =
      "Jugadores obtenidos por IDs";

  // ---------------------------------------------------------------------------
  // Logs – Controladores: Participaciones
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_PARTICIPACIONES_REGISTRAR =
      "Registrando participación de usuario";
  static const LOG_CTRL_PARTICIPACIONES_OBTENER =
      "Recuperando participación de usuario";
  static const LOG_CTRL_PARTICIPACIONES_EDITAR =
      "Actualizando participación";
  static const LOG_CTRL_PARTICIPACIONES_LISTAR =
      "Listando participaciones para liga";
  static const LOG_CTRL_PARTICIPACIONES_APLICAR_PUNTAJES =
      "Aplicando puntajes fantasy a participación";
  static const LOG_CTRL_PARTICIPACIONES_VERIFICAR =
      "Verificando participación de usuario en liga";
  static const LOG_CTRL_PARTICIPACIONES_USUARIO_EXISTE =
      "El usuario ya participa en la liga";
  static const LOG_CTRL_PARTICIPACIONES_CREANDO_ETAPA1 =
      "Creando participación (Etapa 1)";
  static const LOG_CTRL_PARTICIPACIONES_CREAR_EQUIPO_AUTO =
      "Creando equipo fantasy automáticamente tras registrar participación";
  static const LOG_CTRL_PARTICIPACIONES_LISTAR_USUARIO =
      "Listando participaciones del usuario";
  static const LOG_CTRL_PARTICIPACIONES_PUNTAJES_USUARIO =
      "Obteniendo puntajes fantasy para usuario en liga";
  static const LOG_CTRL_PARTICIPACIONES_SIN_EQUIPO =
      "No se encuentra equipo fantasy para la participación";
  static const LOG_CTRL_PARTICIPACIONES_SIN_ALINEACION =
      "No se encontró alineación para usuario";
  static const LOG_CTRL_PARTICIPACIONES_PUNTAJE_EXISTENTE =
      "Puntaje fantasy ya aplicado para participación y fecha";
  static const LOG_CTRL_PARTICIPACIONES_PUNTAJE_GUARDADO =
      "Guardando puntaje fantasy para participación";
  static const LOG_CTRL_PARTICIPACIONES_PUNTAJE_ACTUALIZADO =
      "Puntos acumulados actualizados para participación";
  static const LOG_CTRL_PARTICIPACIONES_FINALIZADO =
      "Cálculo de puntajes fantasy finalizado para liga y fecha";
  static const LOG_CTRL_PARTICIPACIONES_ARCHIVAR =
      "Archivando participación";
  static const LOG_CTRL_PARTICIPACIONES_ACTIVAR =
      "Activando participación";
  static const LOG_CTRL_PARTICIPACIONES_ELIMINAR =
      "Eliminando participación";

  // ---------------------------------------------------------------------------
  // Logs – Controladores: Puntajes reales
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_PUNTAJES_REALES_CREAR =
      "Creando puntaje real para jugador";
  static const LOG_CTRL_PUNTAJES_REALES_LISTAR =
      "Listando puntajes reales";
  static const LOG_CTRL_PUNTAJES_REALES_EDITAR =
      "Editando puntaje real";
  static const LOG_CTRL_PUNTAJES_REALES_ELIMINAR =
      "Eliminando puntaje real";
  static const LOG_CTRL_PUNTAJES_REALES_VERIFICAR =
      "Verificando completitud de puntajes en fecha";

  // ---------------------------------------------------------------------------
  // Logs – Controladores: Router
  // ---------------------------------------------------------------------------
  static const LOG_CTRL_ROUTER_RUTA_NO_ENCONTRADA =
      "Ruta no encontrada en router";

  // ---------------------------------------------------------------------------
  // Errores – Controladores (genéricos)
  // ---------------------------------------------------------------------------
  static const ERR_CTRL_ID_LIGA_VACIO = "El ID de la liga no puede estar vacío.";
  static const ERR_CTRL_ID_USUARIO_VACIO =
      "El ID del usuario no puede estar vacío.";
  static const ERR_CTRL_ID_EQUIPO_FANTASY_VACIO =
      "El ID del equipo fantasy no puede estar vacío.";
  static const ERR_CTRL_ID_ALINEACION_VACIO =
      "El ID de la alineación no puede estar vacío.";
  static const ERR_CTRL_ID_EQUIPO_VACIO = "El ID del equipo no puede estar vacío.";
  static const ERR_CTRL_ID_JUGADOR_VACIO =
      "El ID del jugador no puede estar vacío.";
  static const ERR_CTRL_JUGADOR_SELECCION_REQUERIDA =
      "Debe seleccionar al menos un jugador.";
  static const ERR_CTRL_PUNTOS_NEGATIVOS = "Los puntos no pueden ser negativos.";
  static const ERR_CTRL_FORMACION_INVALIDA = "Formación no válida:";
  static const ERR_CTRL_PARTICIPACION_NO_ENCONTRADA =
      "Participación no encontrada.";
  static const ERR_CTRL_PARTICIPACION_DUPLICADA =
      "El usuario ya participa en esta liga.";
  static const ERR_CTRL_TITULARES_INSUFICIENTES =
      "Debe seleccionar exactamente 11 titulares.";
  static const ERR_CTRL_SUPLENTES_INSUFICIENTES =
      "Debe seleccionar exactamente 4 suplentes.";
  static const ERR_CTRL_JUGADORES_NO_COINCIDEN =
      "Jugadores seleccionados no coinciden con el plantel.";
  static const ERR_CTRL_PLANTEL_TAMANIO =
      "Debe seleccionar exactamente 15 jugadores.";
  static const ERR_CTRL_LIGA_CON_FECHA_ACTIVA =
      "No se puede armar el plantel: la liga tiene una fecha activa.";
  static const ERR_CTRL_LIGA_SIN_TOTAL_FECHAS =
      "La liga ya alcanzó el número máximo de fechas.";
  static const ERR_CTRL_LIGA_CON_FECHA_ACTIVA_PARA_CREAR =
      "No se puede crear una nueva fecha mientras exista otra activa.";
  static const ERR_CTRL_LIGA_NO_ENCONTRADA = "No se encontró la liga solicitada.";
  static const ERR_CTRL_LIGA_ASOCIADA_NO_ENCONTRADA =
      "No se encontró la liga asociada.";
  static const ERR_CTRL_FECHA_NO_ACTIVA = "Solo se pueden cerrar fechas activas.";
  static const ERR_CTRL_FALTAN_PUNTAJES = "Faltan puntajes para cerrar la fecha.";
  static const ERR_CTRL_JUGADOR_INACTIVO =
      "El jugador no está disponible para actualizar puntajes.";
  static const ERR_CTRL_NOMBRE_VACIO = "El nombre no puede estar vacío.";
  static const ERR_CTRL_NOMBRE_EQUIPO_VACIO =
      "El nombre del equipo no puede estar vacío.";
  static const ERR_CTRL_BUSQUEDA_TEXTO_VACIO =
      "Intento de búsqueda con texto vacío";
  static const ERR_CTRL_TOTAL_FECHAS_RANGO =
      "El total de fechas debe estar entre 34 y 50.";
  static const ERR_CTRL_FECHAS_CREADAS_NEGATIVAS =
      "Las fechas creadas no pueden ser negativas.";
  static const ERR_CTRL_EQUIPO_DUPLICADO_LIGA =
      "Ya existe un equipo fantasy para este usuario en esta liga.";
  static const ERR_CTRL_FECHAS_ACTIVAS_EN_LIGA =
      "No se puede crear un equipo con fechas activas en la liga.";
  static const ERR_CTRL_PARTICIPACION_AUSENTE =
      "No existe participación registrada para el usuario en la liga.";
  static const ERR_CTRL_PUNTAJE_EXISTENTE =
      "Ya existe un puntaje para este jugador en la fecha indicada.";
  static const ERR_CTRL_ID_FECHA_VACIO = "El ID de la fecha no puede estar vacío.";
  static const ERR_CTRL_ID_PARTICIPACION_VACIO =
      "El ID de la participación no puede estar vacío.";
  static const ERR_CTRL_FECHA_NO_VALIDA =
      "Fecha no válida para la liga especificada.";
  static const ERR_CTRL_FECHA_NO_CERRADA = "La fecha no está cerrada.";
  static const ERR_CTRL_POSICION_JUGADOR_REAL =
      "La posición debe ser POR, DEF, MED o DEL.";
  static const ERR_CTRL_JUGADOR_REAL_DORSAL_RANGO =
      "El dorsal debe estar entre 1 y 99.";
  static const ERR_CTRL_JUGADOR_REAL_VALOR_RANGO =
      "El valor de mercado debe estar entre 1 y 1000.";
  static const ERR_CTRL_LISTA_IDS_VACIA = "La lista de IDs no puede estar vacía.";
  static const ERR_CTRL_PUNTAJE_JUGADOR_REAL_RANGO =
      "El puntaje del jugador real debe estar entre 1 y 10.";
  static const ERR_CTRL_JUGADOR_REAL_NO_ENCONTRADO =
      "Jugador real no encontrado o no activo.";

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
  static const LIGA_NOMBRE_FECHA = "Fecha {NUMERO}";

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
  // Logs – Alineaciones
  // ---------------------------------------------------------------------------
  static const LOG_ALINEACION_CREAR = "Crear alineación:";
  static const LOG_ALINEACION_GUARDAR_INICIAL = "Guardar alineación inicial:";
  static const LOG_ALINEACION_EDITAR = "Editar alineación:";
  static const LOG_ALINEACION_ARCHIVAR = "Archivar alineación:";
  static const LOG_ALINEACION_ACTIVAR = "Activar alineación:";
  static const LOG_ALINEACION_ELIMINAR = "Eliminar alineación:";
  static const LOG_ALINEACION_LISTAR_ACTIVAS =
      "Listando alineaciones activas de la liga";

  // ---------------------------------------------------------------------------
  // Logs – Puntajes reales
  // ---------------------------------------------------------------------------
  static const LOG_PUNTAJES_REALES_GUARDAR =
      "Guardar puntajes reales (doc único por jugador):";
  static const LOG_PUNTAJES_REALES_LISTAR_FECHA =
      "Listar puntajes reales de la fecha:";
  static const LOG_PUNTAJE_NO_ENCONTRADO = "Puntaje no encontrado:";
  static const LOG_PUNTAJES_REALES_OBTENER_LIGA_FECHA =
      "Obteniendo puntajes reales por liga y fecha:";

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

  // -----------------------------------------------------------------------------
  // Pantalla: Detalle de liga (usuario, desktop)
  // Archivo: ui__usuario__liga__detalle__desktop.dart
  // Prefijo: USUARIO_LIGA_DETALLE_DESKTOP_
  // -----------------------------------------------------------------------------

  static const String USUARIO_LIGA_DETALLE_DESKTOP_ERROR_SIN_USUARIO =
      "No hay usuario autenticado.";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_ERROR_CARGA =
      "Error al cargar los datos de la liga.";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_ERROR_NOMBRE_VACIO =
      "Debés ingresar un nombre para tu equipo fantasy.";
  static const String
      USUARIO_LIGA_DETALLE_DESKTOP_ERROR_PARTICIPACION_NO_RECUPERADA =
      "No se pudo recuperar la participación creada.";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_ERROR_CREAR_PARTICIPACION =
      "Error al crear la participación en la liga.";
  static const String
      USUARIO_LIGA_DETALLE_DESKTOP_ERROR_ALINEACION_NO_ENCONTRADA =
      "No se encontró la alineación inicial.";
  static const String
      USUARIO_LIGA_DETALLE_DESKTOP_ERROR_EQUIPO_FANTASY_NO_ENCONTRADO =
      "No se encontró el equipo fantasy.";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_ERROR_RESUMEN =
      "Error al cargar el resumen del equipo.";

  static const String USUARIO_LIGA_DETALLE_DESKTOP_APPBAR_TITULO =
      "Liga: {LIGA}";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_TEXTO_TEMPORADA =
      "Temporada: {TEMPORADA}";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_ADVERTENCIA_FECHA_ACTIVA =
      "No podés crear ni modificar tu equipo mientras haya una fecha activa en curso.";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_TEXTO_ELEGIR_NOMBRE =
      "Elegí un nombre para tu equipo fantasy:";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_LABEL_NOMBRE_EQUIPO =
      "Nombre del equipo";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_BOTON_CREAR_EQUIPO =
      "Crear equipo fantasy";
  static const String
      USUARIO_LIGA_DETALLE_DESKTOP_TEXTO_EQUIPO_PENDIENTE_COMPLETAR =
      "Tenés un equipo fantasy pendiente de completar.";
  static const String
      USUARIO_LIGA_DETALLE_DESKTOP_BOTON_CONTINUAR_ARMADO =
      "Continuar armado del equipo";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_TEXTO_EQUIPO_COMPLETO =
      "Tu equipo fantasy ya está completo.";
  static const String USUARIO_LIGA_DETALLE_DESKTOP_BOTON_VER_EQUIPO =
      "Ver mi equipo fantasy";
}
