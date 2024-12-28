import 'dart:convert';

import 'package:esvilla_app/data/models/user_model.dart';
import 'package:esvilla_app/domain/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

import '../datasources/user/auth_mock_data_source.dart';
class UserRepositoryImpl implements UserRepository{

  final UserMockDataSource mockDataSource;

  UserRepositoryImpl(this.mockDataSource);

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      print(response);

    if (response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);

      return json.map((data) => UserModel.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed to load users');
    }
    
  }

  Future<List<UserModel>> getUsers() async {
    final models = await mockDataSource.getUsers();
    return models
        .map((model) => UserModel(id: model.id, name: model.name, email: model.email))
        .toList();
  }
}