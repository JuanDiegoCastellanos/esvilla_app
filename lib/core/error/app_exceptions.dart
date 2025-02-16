import 'package:dio/dio.dart';

class AppException implements Exception {
  int? code;
  final String message;

  AppException({this.code, required this.message});

  factory AppException.fromDioStatusCode(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return  AppException(code: 400, message: 'Bad Request, por favor revise los campos');
      case 401:
        return  AppException(code: 401, message: 'No autenticado, por favor revise sus credenciales');
      case 404:
        return  AppException(code: 404, message: 'No se encontró la página solicitada');
      case 500:
        return  AppException(code: 500, message: 'Error interno del servidor, inténtelo más tarde');
      default:
        return AppException( code: error.response?.statusCode ?? 0, message: 'Error desconocido');
    }
  }
  factory AppException.fromDioExceptionType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return AppException(message: '⏳ Tiempo de espera agotado por connectionTimeout');
      case DioExceptionType.sendTimeout:
        return AppException(message: '⏳ Tiempo de espera agotado por sendTimeout');       
      case DioExceptionType.receiveTimeout:
        return AppException(message: '⏳ Tiempo de espera agotado por receiveTimeout');
      case DioExceptionType.badCertificate:
        return AppException(message: '🔒 Certificado no válido');
      case DioExceptionType.badResponse:
        return AppException(code: 401, message: '📥 Error de respuesta');
      case DioExceptionType.cancel:
        return AppException(message: '❌ Solicitud cancelada');
      case DioExceptionType.connectionError:
        return AppException(message: '📡 Error de conexión');
      case DioExceptionType.unknown:
        return AppException(message: '❓ Error desconocido');
  }
  }
  @override
  String toString() => 'AppException(code: $code, message: $message)';
}
