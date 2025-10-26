import 'package:esvilla_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators', () {
    group('validateEmail', () {
      test('retorna error cuando el email es null', () {
        expect(Validators.validateEmail(null), 'El correo electrónico es requerido');
      });

      test('retorna error cuando el email está vacío', () {
        expect(Validators.validateEmail(''), 'El correo electrónico es requerido');
      });

      test('retorna error cuando el email no tiene formato válido', () {
        expect(Validators.validateEmail('correo'), isNotNull);
        expect(Validators.validateEmail('correo@'), isNotNull);
        expect(Validators.validateEmail('correo@dominio'), isNotNull);
        expect(Validators.validateEmail('@dominio.com'), isNotNull);
      });

      test('retorna null cuando el email es válido', () {
        expect(Validators.validateEmail('correo@dominio.com'), isNull);
        expect(Validators.validateEmail('correo.test@dominio.co.uk'), isNull);
      });
    });

    group('validatePassword', () {
      test('retorna error cuando la contraseña es null', () {
        expect(Validators.validatePassword(null), 'La contraseña es requerida');
      });

      test('retorna error cuando la contraseña está vacía', () {
        expect(Validators.validatePassword(''), 'La contraseña es requerida');
      });

      test('retorna error cuando la contraseña tiene menos de 6 caracteres', () {
        expect(Validators.validatePassword('12345'), 'La contraseña debe tener al menos 6 caracteres');
      });

      test('retorna null cuando la contraseña es válida', () {
        expect(Validators.validatePassword('123456'), isNull);
        expect(Validators.validatePassword('contraseña_segura'), isNull);
      });
    });

    group('validateRequired', () {
      test('retorna error cuando el valor es null', () {
        expect(Validators.validateRequired(null), 'Este campo es requerido');
      });

      test('retorna error cuando el valor está vacío', () {
        expect(Validators.validateRequired(''), 'Este campo es requerido');
      });

      test('retorna error cuando el valor solo tiene espacios', () {
        expect(Validators.validateRequired('   '), 'Este campo es requerido');
      });

      test('retorna error con nombre de campo personalizado', () {
        expect(Validators.validateRequired('', fieldName: 'Nombre'), 'Nombre es requerido');
      });

      test('retorna null cuando el valor no está vacío', () {
        expect(Validators.validateRequired('valor'), isNull);
      });
    });

    group('validatePhone', () {
      test('retorna error cuando el teléfono es null', () {
        expect(Validators.validatePhone(null), 'El número de teléfono es requerido');
      });

      test('retorna error cuando el teléfono está vacío', () {
        expect(Validators.validatePhone(''), 'El número de teléfono es requerido');
      });

      test('retorna error cuando el teléfono no tiene 10 dígitos', () {
        expect(Validators.validatePhone('123'), isNotNull);
        expect(Validators.validatePhone('12345678901'), isNotNull);
        expect(Validators.validatePhone('123abc456'), isNotNull);
      });

      test('retorna null cuando el teléfono es válido', () {
        expect(Validators.validatePhone('1234567890'), isNull);
      });
    });

    group('validateDocument', () {
      test('retorna error cuando el documento es null', () {
        expect(Validators.validateDocument(null), 'El documento es requerido');
      });

      test('retorna error cuando el documento está vacío', () {
        expect(Validators.validateDocument(''), 'El documento es requerido');
      });

      test('retorna error cuando el documento tiene menos de 6 dígitos', () {
        expect(Validators.validateDocument('12345'), isNotNull);
      });

      test('retorna error cuando el documento tiene más de 12 dígitos', () {
        expect(Validators.validateDocument('1234567890123'), isNotNull);
      });

      test('retorna error cuando el documento contiene caracteres no numéricos', () {
        expect(Validators.validateDocument('123abc456'), isNotNull);
      });

      test('retorna null cuando el documento es válido', () {
        expect(Validators.validateDocument('123456'), isNull);
        expect(Validators.validateDocument('1234567890'), isNull);
        expect(Validators.validateDocument('123456789012'), isNull);
      });
    });
  });
}