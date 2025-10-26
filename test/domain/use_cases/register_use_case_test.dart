import 'package:esvilla_app/domain/entities/auth/auth_response_entity.dart';
import 'package:esvilla_app/domain/entities/auth/register_request_entity.dart';
import 'package:esvilla_app/domain/repositories/register_repository.dart';
import 'package:esvilla_app/domain/use_cases/register_use_cart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRegisterRepo extends Mock implements RegisterRepository {}

void main() {
  late _MockRegisterRepo repo;
  late RegisterUseCase useCase;

  setUp(() {
    repo = _MockRegisterRepo();
    useCase = RegisterUseCase(repo);
  });

  test('registra y retorna AuthResponseEntity', () async {
    final request = RegisterRequestEntity(
        name: 'Juan',
        document: '123',
        email: 'a@b.com',
        phone: '300',
        password: 'x',
        direccion: 'addr');
    when(() => repo.register(request))
        .thenAnswer((_) async => AuthResponseEntity(
              accessToken: 'acc',
              refreshToken: 'ref',
              role: 'user',
              expiration: 3600,
            ));

    final res = await useCase(request);
    expect(res.accessToken, 'acc');
    expect(res.role, 'user');
  });
}
