import 'package:dio/dio.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException.fromDioStatusCode', () {
    DioException build(int status) => DioException(
          requestOptions: RequestOptions(path: '/'),
          response: Response(
              requestOptions: RequestOptions(path: '/'), statusCode: status),
        );

    test('400 -> Bad Request', () {
      final ex = AppException.fromDioStatusCode(build(400));
      expect(ex.code, 400);
      expect(ex.message, contains('Bad Request'));
    });

    test('401 -> No autenticado', () {
      final ex = AppException.fromDioStatusCode(build(401));
      expect(ex.code, 401);
      expect(ex.message, contains('No autenticado'));
    });

    test('404 -> No encontrado', () {
      final ex = AppException.fromDioStatusCode(build(404));
      expect(ex.code, 404);
      expect(ex.message, contains('No se encontró'));
    });

    test('500 -> Error interno', () {
      final ex = AppException.fromDioStatusCode(build(500));
      expect(ex.code, 500);
      expect(ex.message, contains('Error interno'));
    });

    test('Otro -> Error desconocido', () {
      final ex = AppException.fromDioStatusCode(build(418));
      expect(ex.code, 418);
      expect(ex.message, contains('Error desconocido'));
    });
  });

  group('AppException.fromDioExceptionType', () {
    test('connectionTimeout', () {
      final ex =
          AppException.fromDioExceptionType(DioExceptionType.connectionTimeout);
      expect(ex.message, contains('connectionTimeout'));
    });
    test('sendTimeout', () {
      final ex =
          AppException.fromDioExceptionType(DioExceptionType.sendTimeout);
      expect(ex.message, contains('sendTimeout'));
    });
    test('receiveTimeout', () {
      final ex =
          AppException.fromDioExceptionType(DioExceptionType.receiveTimeout);
      expect(ex.message, contains('receiveTimeout'));
    });
    test('badCertificate', () {
      final ex =
          AppException.fromDioExceptionType(DioExceptionType.badCertificate);
      expect(ex.message, contains('Certificado'));
    });
    test('badResponse', () {
      final ex =
          AppException.fromDioExceptionType(DioExceptionType.badResponse);
      expect(ex.code, 401); // comportamiento actual del código
      expect(ex.message, contains('Error de respuesta'));
    });
    test('cancel', () {
      final ex = AppException.fromDioExceptionType(DioExceptionType.cancel);
      expect(ex.message, contains('cancelada'));
    });
    test('connectionError', () {
      final ex =
          AppException.fromDioExceptionType(DioExceptionType.connectionError);
      expect(ex.message, contains('conexión'));
    });
    test('unknown', () {
      final ex = AppException.fromDioExceptionType(DioExceptionType.unknown);
      expect(ex.message, contains('desconocido'));
    });
  });
}
