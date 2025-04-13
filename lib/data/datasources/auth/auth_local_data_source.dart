import 'package:esvilla_app/data/models/auth/auth_response.dart';

class AuthLocalDataSource {
  Future<AuthResponse> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

    const users = {
      '1002676988': 'admin',
      '1023927661': 'user1',
    };

    if (users[email] == password) {
      return AuthResponse(
        accessToken: 'mock_token_${email.hashCode}',
        role: 'user',
        refreshToken: 'mock_refresh_token_${email.hashCode}',
        expiresIn: 3600,
      );
    } else {
      throw Exception('Invalid email or password');
    }
  }
}