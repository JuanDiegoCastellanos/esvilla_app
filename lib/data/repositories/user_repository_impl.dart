import 'dart:convert';

import 'package:esvilla_app/data/models/user_model.dart';
import 'package:http/http.dart' as http;
class UserRepositoryImpl {

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200){
      final List<dynamic> json = jsonDecode(response.body);

      return json.map((data) => UserModel.fromJson(data)).toList();
    }
    else{
      throw Exception('Failed to load users');
    }
    
  }
}