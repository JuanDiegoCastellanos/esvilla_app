import 'package:esvilla_app/data/datasources/auth/auth_remote_data_source.dart';
import 'package:esvilla_app/data/models/auth/auth_response.dart';
import 'package:esvilla_app/data/repositories/auth/auth_repository_impl.dart';
import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late AuthRemoteRepositoryImpl repo;

  setUp(() {
    remote = _MockRemote();
    repo = AuthRemoteRepositoryImpl(remote);
  });

  test('login retorna AuthResponseEntity con tokens', () async {
    when(() => remote.login('user', 'pass')).thenAnswer((_) async => AuthResponse(
          accessToken: 'acc',
          refreshToken: 'ref',
          role: 'user',
          expiresIn: 3600,
        ));
    final result = await repo.login('user', 'pass');
    expect(result, isA<AuthResponseEntity>());
    expect(result.accessToken, 'acc');
    expect(result.refreshToken, 'ref');
    expect(result.role, 'user');
    expect(result.expiration, 3600);
  });
}

// Sin fakes adicionales: usamos AuthResponse real para simplificar el mock


