/*
  Archivo: prueba_validaciones_autenticacion_test.dart
  Descripción: Pruebas unitarias de validación local (sin Firebase) para email y contraseña.
*/

import 'package:flutter_test/flutter_test.dart';

bool validarEmailBasico(String email) {
  return email.contains('@') && email.contains('.');
}

bool validarContrasenaBasica(String contrasena) {
  return contrasena.length >= 6;
}

void main() {
  test('Email válido', () {
    expect(validarEmailBasico('usuario@dominio.com'), true);
    expect(validarEmailBasico('usuario'), false);
  });

  test('Contraseña válida', () {
    expect(validarContrasenaBasica('123456'), true);
    expect(validarContrasenaBasica('123'), false);
  });
}
