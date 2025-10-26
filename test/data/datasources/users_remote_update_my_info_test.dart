import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/users/users_remote_data_source.dart';
import 'package:esvilla_app/data/models/users/user_update_request.dart';
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

  test('updateMyInfo 409 mapea a AppException con mensaje', () async {
    const errorBody = {
      'message': {'message': 'Email ya registrado'}
    };
    adapter.onPatch('/users/profile', (server) => server.reply(409, errorBody),
        data: Matchers.any);

    final req = UpdateUserRequest(id: 'u1', email: 'dup@example.com');
    expect(
      () async => ds.updateMyInfo(req),
      throwsA(isA<Exception>()),
    );
  });
}
