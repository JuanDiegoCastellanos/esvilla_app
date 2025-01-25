import 'package:esvilla_app/domain/use_cases/get_local_users_use_case.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';

class UserController extends ChangeNotifier{

  final GetUsersUseCase  useCase;

  UserController(this.useCase);

  List<UserEntity> _users = [];
  
  bool _isLoading = false;

  List<UserEntity> get users => _users;
  bool get isLoading => _isLoading;


  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await useCase.execute();
    }
    catch (e) {
      print('Error fetching users: $e');
    }

    _isLoading = false;
    notifyListeners();

  }

}