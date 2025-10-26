import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/use_cases/announcements/get_all_with_pagination_use_case.dart';
import 'package:esvilla_app/presentation/providers/announcements/announcements_list_state_notifier_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetAllWithPagination extends Mock implements GetAllWithPaginationUseCase {}
class _ParamsFake extends Fake implements AnnouncementsQueryParams {}

void main() {
  setUpAll(() {
    registerFallbackValue(_ParamsFake());
  });

  test('loadInitialNews carga primera página y data no vacía', () async {
    final useCase = _MockGetAllWithPagination();
    final entity = AnnouncementsEntity(
      id: 'a1', title: 't', description: 'd', mainImage: 'm', body: 'b', secondaryImage: 's',
      publicationDate: DateTime.now(), createdBy: 'u1', createdAt: DateTime.now(), updatedAt: DateTime.now(),
    );
    final page = PaginatedResponse<AnnouncementsEntity>(data: [entity], meta: PaginationMeta(page: 1, limit: 20, total: 1, totalPages: 1, hasNextPage: false, hasPrevPage: false));
    when(() => useCase.call(any())).thenAnswer((_) async => page);

    final notifier = AnnouncementsListStateNotifierProvider(useCase);
    await notifier.loadInitialNews();
    expect(notifier.state.hasValue, true);
    expect(notifier.state.value!.data.first.id, 'a1');
  });
}


