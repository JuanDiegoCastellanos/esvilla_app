import 'package:esvilla_app/data/mappers/users/user_mapper.dart';
import 'package:esvilla_app/data/models/users/create_user_request.dart';
import 'package:esvilla_app/data/models/users/user_model.dart';
import 'package:esvilla_app/data/models/users/user_update_request.dart';
import 'package:esvilla_app/data/models/users/update_password_request.dart';
import 'package:esvilla_app/domain/entities/user/create_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_password_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/update_user_request_entity.dart';
import 'package:esvilla_app/domain/entities/user/user_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserMapper toEntity/toModel round trip', () {
    final model = UserModel(
      id: 'u1',
      name: 'Juan',
      email: 'a@b.com',
      documentNumber: '123',
      phone: '300',
      mainAddress: 'addr',
      password: 'pwd',
      role: 'user',
    );
    final entity = UserMapper.toEntity(model);
    expect(entity.id, model.id);
    expect(entity.name, model.name);
    expect(entity.role, model.role);

    final back = UserMapper.toModel(entity);
    expect(back.id, entity.id);
    expect(back.email, entity.email);
    expect(back.password, entity.password);
  });

  test('UserMapper toCreateRequest', () {
    final e = CreateUserRequestEntity(
      documentNumber: '123', name: 'Juan', email: 'a@b.com', phone: '300', mainAddress: 'addr', password: 'pwd', role: 'user'
    );
    final r = UserMapper.toCreateRequest(e);
    expect(r, isA<CreateUserRequest>());
    expect(r.documentNumber, '123');
    expect(r.role, 'user');
  });

  test('UserMapper toUpdateRequest', () {
    final e = UpdateUserRequestEntity(
      id: 'u1', name: 'Juan', email: 'a@b.com', documentNumber: '123', phone: '300', mainAddress: 'addr', role: 'admin', password: 'pwd'
    );
    final r = UserMapper.toUpdateRequest(e);
    expect(r, isA<UpdateUserRequest>());
    expect(r.id, 'u1');
    expect(r.role, 'admin');
  });

  test('UserMapper toUpdatePasswordRequest', () {
    final e = UpdatePasswordRequestEntity(oldPassword: 'o', newPassword: 'n', confirmNewPassword: 'n');
    final r = UserMapper.toUpdatePasswordRequest(e);
    expect(r, isA<UpdatePasswordRequest>());
    expect(r.newPassword, 'n');
  });
}


