import 'dart:convert';

import 'package:esvilla_app/data/models/user_model.dart';
import 'package:esvilla_app/domain/entities/user_entity.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

import '../datasources/user/users_local_data_source.dart';
class UserLocalRepositoryImpl implements UserRepository{

  final UserLocalRepositoryImpl mockDataSource;

  UserLocalRepositoryImpl(this.mockDataSource);

  Future<List<UserModel>> getUsers() async {
    final models = await mockDataSource.getUsers();
    return models
        .map((model) => UserModel(id: model.id, name: model.name, email: model.email))
        .toList();
  }

  @override
  Future<List<UserEntity>> loadUsers() {
    // TODO: implement loadUsers
    throw UnimplementedError();
  }

}