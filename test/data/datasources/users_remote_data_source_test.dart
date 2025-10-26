import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/users/users_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late UsersRemoteDataSource ds;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    ds = UsersRemoteDataSource(dio);
  });

  test('myProfile 200 retorna modelo de usuario parseado', () async {
    final body = {
      '_id': 'u1',
      'name': 'Juan',
      'documentNumber': '123',
      'email': 'a@b.com',
      'phone': '300',
      'mainAddress': 'addr',
      'role': 'user',
    };
    adapter.onGet('/users/profile', (server) => server.reply(200, body));

    final user = await ds.myProfile();
    expect(user.id, 'u1');
    expect(user.name, 'Juan');
    expect(user.role, 'user');
  });
}
