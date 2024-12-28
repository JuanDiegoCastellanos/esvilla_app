import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSource(this.client);

  Future<String> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('https://api.example.com/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token']; // Retorna el token
    } else {
      throw Exception('Failed to login');
    }
  }
}
