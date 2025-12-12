import 'package:fantasypro/controladores/controlador_fechas.dart';
import 'package:fantasypro/controladores/controlador_jugadores_reales.dart';
import 'package:fantasypro/controladores/controlador_ligas.dart';
import 'package:fantasypro/controladores/controlador_participaciones.dart';
import 'package:fantasypro/core/app_strings.dart';
import 'package:test/test.dart';

void main() {
  group('Controladores utilizan AppStrings', () {
    test('ControladorFechas usa mensaje centralizado para idLiga vacío', () async {
      final controlador = ControladorFechas();

      await expectLater(
        controlador.crearFecha(''),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            AppStrings.text(AppStrings.controladorFechasIdLigaVacio),
          ),
        ),
      );
    });

    test('ControladorParticipaciones centraliza idUsuario vacío', () async {
      final controlador = ControladorParticipaciones();

      await expectLater(
        controlador.crearParticipacionSiNoExiste('liga', '', 'equipo'),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            AppStrings.text(AppStrings.controladorParticipacionesIdUsuarioVacio),
          ),
        ),
      );
    });

    test('ControladorLigas reutiliza AppStrings en validaciones', () async {
      final controlador = ControladorLigas();

      await expectLater(
        controlador.obtenerPorId('   '),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            AppStrings.text(AppStrings.controladorLigasIdLigaVacio),
          ),
        ),
      );
    });

    test('ControladorJugadoresReales valida idEquipoReal con AppStrings',
        () async {
      final controlador = ControladorJugadoresReales();

      await expectLater(
        controlador.crearJugadorReal('', 'nombre', 'POR'),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            AppStrings.text(AppStrings.controladorJugadoresRealesIdEquipoVacio),
          ),
        ),
      );
    });
  });
}
