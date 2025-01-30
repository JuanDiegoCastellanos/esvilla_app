import 'package:dio/dio.dart';
import 'package:esvilla_app/core/config/app_config.dart';
import 'package:esvilla_app/core/utils/dio_logging_interceptor.dart';
import 'package:esvilla_app/presentation/providers/auth_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioClientProvider = Provider(
  (ref) {
    final token = ref.watch(authTokenProvider);
    return DioClient(token);
  });

class DioClient {
  final Dio _dio = Dio();

  DioClient(String? token) {

    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    );

    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
    // Añadir interceptores
    _dio.interceptors.add(DioLoggingInterceptor());
  }

  Dio get dio => _dio;
}