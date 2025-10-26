import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/auth/refresh_token_service.dart';
import 'package:esvilla_app/data/models/auth/auth_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late RefreshTokenService refreshTokenService;

  setUp(() {
    mockDio = MockDio();
    refreshTokenService = RefreshTokenService(dio: mockDio);
  });

  group('RefreshTokenService', () {
    test('refreshToken retorna AuthResponse con nuevos tokens', () async {
      when(() => mockDio.post(
            '/auth/refresh',
            data: {'refresh_token': 'old-refresh-token'},
          )).thenAnswer((_) async => Response(
            data: {
              'access_token': 'new-access-token',
              'refresh_token': 'new-refresh-token',
              'role': 'user',
              'expires_in': 3600,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: '/auth/refresh'),
          ));

      final result =
          await refreshTokenService.refreshToken('old-refresh-token');

      expect(result, isA<AuthResponse>());
      expect(result.accessToken, 'new-access-token');
      expect(result.refreshToken, 'new-refresh-token');
      expect(result.role, 'user');
      expect(result.expiresIn, 3600);
    });

    test('refreshToken lanza excepción cuando falla la petición', () async {
      when(() => mockDio.post(
            '/auth/refresh',
            data: {'refresh_token': 'invalid-token'},
          )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/auth/refresh'),
        response: Response(
          statusCode: 401,
          data: {'message': 'Invalid refresh token'},
          requestOptions: RequestOptions(path: '/auth/refresh'),
        ),
      ));

      expect(
        () => refreshTokenService.refreshToken('invalid-token'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
