import 'package:esvilla_app/core/config/dio_config.dart';
import 'package:esvilla_app/data/datasources/auth/refresh_token_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final refreshTokenServiceProvider = Provider<RefreshTokenService>((ref) {
  // Usamos la misma instancia de Dio de nuestro cliente configurado
  final dio = ref.read(dioClientProvider).dio;
  return RefreshTokenService(dio: dio);
});