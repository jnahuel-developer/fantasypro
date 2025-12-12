# fantasypro

Aplicación Flutter para gestión de ligas y equipos fantasy.

## Convención de textos en controladores

Los mensajes de logs y validaciones se centralizan en `lib/core/app_strings.dart`
usando la convención de clave `controller_name.message_key`. Ejemplos:

- `controlador_fechas.id_liga_vacio` → `AppStrings.text(AppStrings.controladorFechasIdLigaVacio)`.
- `controlador_participaciones.log_crear_equipo` → se usa con placeholders: 
  `AppStrings.text(AppStrings.controladorParticipacionesLogCrearEquipo, args: {'idUsuario': '123', 'idLiga': 'ABC', 'nombre': 'Mi Equipo'})`.

Patrones a seguir al agregar textos nuevos:

1. Crear la clave descriptiva en `app_strings.dart` dentro de la sección del controlador.
2. Mantener los placeholders `{nombre}` o `{idLiga}` en el recurso central y reemplazarlos con `args` desde el controlador.
3. Evitar literales directos en controladores; preferir `AppStrings.text(...)` o constantes existentes en `TextosApp` para compatibilidad.

## Comandos útiles

- Formateo: `dart format lib test`
- Análisis estático: `dart analyze`
- Pruebas unitarias: `dart test`
