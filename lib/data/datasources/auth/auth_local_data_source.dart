class AuthLocalDataSource {
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));

     const users = {
      '1002676988': 'admin',
      '1023927661': 'user1',
    };

    if (users[email] == password) {
      return 'mock_token_${email.hashCode}';
    } else {
      throw Exception('Invalid email or password');
    }
  }
}