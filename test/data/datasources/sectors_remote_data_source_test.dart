import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/sectors/sectors_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late SectorsRemoteDataSource ds;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    ds = SectorsRemoteDataSource(dio);
  });

  test('getSectors retorna lista parseada', () async {
    final now = DateTime.now().toIso8601String();
    final item = {
      '_id': 'sec1',
      'nombre': 'Centro',
      'descripcion': 'desc',
      'ubicacion': {
        'type': 'Polygon',
        'coordinates': [
          [
            [0.0, 0.0],
            [1.0, 0.0],
            [1.0, 1.0],
          ]
        ],
      },
      'createdAt': now,
      'updatedAt': now,
    };
    adapter.onGet('/sectors', (server) => server.reply(200, [item]));
    final list = await ds.getSectors();
    expect(list.length, 1);
    expect(list.first.id, 'sec1');
  });
}
