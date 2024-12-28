class AuthMockDataSource {
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

     const users = {
      'test': '1234',
      'admin': 'admin',
    };

    if (users[email] == password) {
      return 'mock_token_${email.hashCode}'; // Simula un token de autenticación
    } else {
      throw Exception('Invalid email or password');
    }
  }
}