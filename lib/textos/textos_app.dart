// ignore_for_file: constant_identifier_names

/*
  Archivo: textos_app.dart
  Descripción:
    Centraliza todos los textos visibles de la aplicación.
    Estructura:
      PANTALLA_COMPONENTE_ACCION
*/

class TextosApp {
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
  // (si en el futuro querés agregar defaults, quedan definidas aquí)
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
  static const JUGADORES_ADMIN_CREAR_BOTON_CANCELAR = "Cancelar";
  static const JUGADORES_ADMIN_CREAR_BOTON_CREAR = "Crear";

  // Validación
  static const JUGADORES_ADMIN_VALIDACION_OBLIGATORIOS =
      "Los campos Nombre y Posición son obligatorios.";

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
}
