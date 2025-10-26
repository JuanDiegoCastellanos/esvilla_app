import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/announcements/announcements_remote_data_source.dart';
import 'package:esvilla_app/data/models/announcements/announcements_model.dart';
import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late AnnouncementsRemoteDataSource ds;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'http://localhost'));
    adapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = adapter;
    ds = AnnouncementsRemoteDataSource(dio);
  });

  test('getAnnouncementsWithPagination parsea {data, meta}', () async {
    final responseBody = {
      'data': [
        {
          '_id': 'a1',
          'title': 'T',
          'description': 'D',
          'mainImage': 'mi',
          'body': 'b',
          'secondaryImage': 'si',
          'publicationDate': DateTime.now().toIso8601String(),
          'createdBy': 'u1',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
        }
      ],
      'meta': {
        'page': 1,
        'limit': 10,
        'total': 1,
        'totalPages': 1,
        'hasNextPage': false,
        'hasPrevPage': false,
      }
    };

    adapter.onGet(
      '/announcements',
      (server) => server.reply(200, responseBody),
      queryParameters: {
        'page': 1,
        'limit': 10,
      },
    );

    final result = await ds.getAnnouncementsWithPagination(
      AnnouncementsQueryParams(page: 1, limit: 10),
    );

    expect(result, isA<PaginatedResponse<AnnouncementModel>>());
    expect(result.data.length, 1);
    expect(result.meta.page, 1);
    expect(result.meta.total, 1);
    expect(result.data.first.id, 'a1');
  });
}


