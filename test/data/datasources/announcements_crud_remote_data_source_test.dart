import 'package:dio/dio.dart';
import 'package:esvilla_app/data/datasources/announcements/announcements_remote_data_source.dart';
import 'package:esvilla_app/data/models/announcements/create_announcement_request.dart';
import 'package:esvilla_app/data/models/announcements/update_announcements_request.dart';
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

  test('createAnnouncement 201 retorna modelo', () async {
    final now = DateTime.now().toIso8601String();
    final body = {
      '_id': 'a1',
      'title': 'T',
      'description': 'D',
      'mainImage': 'mi',
      'body': 'b',
      'secondaryImage': 'si',
      'publicationDate': now,
      'createdBy': 'u1',
      'createdAt': now,
      'updatedAt': now,
    };
    adapter.onPost('/announcements', (server) => server.reply(201, body),
        data: Matchers.any);

    final req = CreateAnnouncementRequest(
        title: 'T',
        description: 'D',
        mainImage: 'mi',
        body: 'b',
        secondaryImage: 'si',
        publicationDate: DateTime.parse(now));
    final model = await ds.createAnnouncement(req);
    expect(model.id, 'a1');
  });

  test('updateAnnouncement 200 retorna modelo', () async {
    final now = DateTime.now().toIso8601String();
    final body = {
      '_id': 'a1',
      'title': 'T2',
      'description': 'D',
      'mainImage': 'mi',
      'body': 'b',
      'secondaryImage': 'si',
      'publicationDate': now,
      'createdBy': 'u1',
      'createdAt': now,
      'updatedAt': now,
    };
    adapter.onPatch('/announcements/a1', (server) => server.reply(200, body),
        data: Matchers.any);

    final req = UpdateAnnouncementRequest(id: 'a1', title: 'T2');
    final model = await ds.updateAnnouncement(req);
    expect(model.title, 'T2');
  });

  test('publishAnnouncement 200 retorna modelo', () async {
    final now = DateTime.now().toIso8601String();
    final body = {
      '_id': 'a1',
      'title': 'T',
      'description': 'D',
      'mainImage': 'mi',
      'body': 'b',
      'secondaryImage': 'si',
      'publicationDate': now,
      'createdBy': 'u1',
      'createdAt': now,
      'updatedAt': now,
    };
    adapter.onPatch(
        '/announcements/a1/publish', (server) => server.reply(200, body));
    final model = await ds.publishAnnouncement('a1');
    expect(model.id, 'a1');
  });
}
