import 'package:esvilla_app/data/datasources/users/users_remote_data_source.dart';
import 'package:esvilla_app/data/models/users/user_model.dart';
import 'package:esvilla_app/data/repositories/users/user_repository_impl.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockUsersDs extends Mock implements UsersRemoteDataSource {}

void main() {
  late _MockUsersDs ds;
  late UserRemoteRepositoryImpl repo;

  setUp(() {
    ds = _MockUsersDs();
    repo = UserRemoteRepositoryImpl(ds);
  });

  test('myProfile retorna UserEntity', () async {
    when(() => ds.myProfile()).thenAnswer((_) async => UserModel(
          id: 'u1',
          name: 'Juan',
          email: 'a@b.com',
          documentNumber: '123',
          phone: '300',
          mainAddress: 'addr',
          password: '',
          role: 'user',
        ));

    final entity = await repo.myProfile();
    expect(entity, isA<UserEntity>());
    expect(entity.id, 'u1');
    expect(entity.name, 'Juan');
  });
}


