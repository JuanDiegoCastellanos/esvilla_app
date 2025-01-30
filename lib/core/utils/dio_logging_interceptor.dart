import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioLoggingInterceptor extends Interceptor {
  final Logger _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d("🚀 REQUEST: [${options.method}] ${options.uri}");
    if (options.data != null) _logger.d("🔍 Body: ${options.data}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i("✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e("❌ ERROR[${err.response?.statusCode}] => ${err.message}");
    if (err.response?.data != null) {
      _logger.e("📦 Error Data: ${err.response?.data}");
    }
    handler.next(err);
  }
}
