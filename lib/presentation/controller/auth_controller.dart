import 'package:esvilla_app/domain/use_cases/login_use_case.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {

  final LoginUseCase loginUseCase;

  String _token = '';
  bool _isLoading = false;

  String get token => _token;
  bool get isLoading => _isLoading;

  AuthController(this.loginUseCase);

  Future<void> login(String email, String password) async{
    _isLoading = true;
    notifyListeners();

    try{
      _token = await loginUseCase(email, password);
    }
    catch(e){
      print('$e');
    }

    _isLoading = false;
    notifyListeners();

  }
}