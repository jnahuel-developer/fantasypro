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
  // Bloque: Mensajes de log
  // ---------------------------------------------------------------------------

  static const LOG_REGISTRO_USUARIO_CREADO = "Usuario creado con UID";

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
}
