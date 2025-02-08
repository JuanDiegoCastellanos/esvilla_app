import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Número de llamadas en la pila
      errorMethodCount: 5,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart
    ),
  );

  // Métodos públicos para diferentes niveles de log
  static void d(String message) => _logger.d(message); // Debug
  static void t(String message) => _logger.t(message); // Trace
  static void i(String message) => _logger.i(message); // Información
  static void w(String message) => _logger.w(message); // Advertencias
  static void f(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.f(message, error: error, stackTrace: stackTrace); // Fatal Error
  static void e(String message) => _logger.e(message); // Errores
}
