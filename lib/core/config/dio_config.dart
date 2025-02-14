import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_config.dart';
import 'package:esvilla_app/core/utils/dio_logging_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClientProvider = Provider(
  (ref) {
    return DioClient(ref);
  });

class DioClient {
  final Dio _dio = Dio();
  final Ref ref;

  DioClient(this.ref) {

    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
      contentType: 'application/json',
    );
    // Añadir interceptores
    _dio.interceptors.addAll([
      DioLoggingInterceptor()
      ]);
  }

  Dio get dio => _dio;
}