import 'package:esvilla_app/data/datasources/announcements/announcements_remote_data_source.dart';
import 'package:esvilla_app/data/models/announcements/announcements_model.dart';
import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/data/repositories/announcements/announcements_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAnnouncementsDs extends Mock
    implements AnnouncementsRemoteDataSource {}

class _ParamsFake extends Fake implements AnnouncementsQueryParams {}

void main() {
  late _MockAnnouncementsDs ds;
  late AnnouncementsRepositoryImpl repo;

  setUp(() {
    ds = _MockAnnouncementsDs();
    repo = AnnouncementsRepositoryImpl(ds);
  });

  setUpAll(() {
    registerFallbackValue(_ParamsFake());
  });

  test('getAnnouncementsWithPagination mapea modelos a entidades', () async {
    final now = DateTime.now();
    final model = AnnouncementModel(
      id: 'a1',
      title: 'T',
      description: 'D',
      mainImage: 'mi',
      body: 'b',
      secondaryImage: 'si',
      publicationDate: now,
      createdBy: 'u1',
      createdAt: now,
      updatedAt: now,
    );
    final page = PaginatedResponse<AnnouncementModel>(
      data: [model],
      meta: PaginationMeta(
        page: 1,
        limit: 10,
        total: 1,
        totalPages: 1,
        hasNextPage: false,
        hasPrevPage: false,
      ),
    );

    when(() => ds.getAnnouncementsWithPagination(
            any(that: isA<AnnouncementsQueryParams>())))
        .thenAnswer((_) async => page);

    final result = await repo.getAnnouncementsWithPagination(
        AnnouncementsQueryParams(page: 1, limit: 10));
    expect(result.data.length, 1);
    expect(result.data.first.id, 'a1');
    expect(result.meta.page, 1);
    expect(result.meta.total, 1);
  });
}
