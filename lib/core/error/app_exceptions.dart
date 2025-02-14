import 'package:dio/dio.dart';

class AppException implements Exception {
  final int code;
  final String message;

  const AppException({required this.code, required this.message});

  factory AppException.fromDioError(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return const AppException(code: 400, message: 'Bad Request, por favor revise los campos');
      case 401:
        return const AppException(code: 401, message: 'No autenticado, por favor inicie sesión');
      case 404:
        return const AppException(code: 404, message: 'No se encontró la página solicitada');
      case 500:
        return const AppException(code: 500, message: 'Error interno del servidor, inténtelo más tarde');
      default:
        return AppException(code: error.response?.statusCode ?? 0, message: 'Error desconocido');
    }
  }

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}
