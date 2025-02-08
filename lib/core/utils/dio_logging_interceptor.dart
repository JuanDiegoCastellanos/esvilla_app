import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_logger.dart';

class DioLoggingInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d("🚀 REQUEST: [${options.method}] ${options.uri}");
    if (options.data != null) AppLogger.d("🔍 Body: ${options.data}");
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i("✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.uri}");
    handler.next(response);
  }
}
