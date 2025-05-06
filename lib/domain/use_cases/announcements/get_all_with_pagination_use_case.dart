import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class GetAllWithPaginationUseCase {
  final AnnouncementsRepository repository;

  GetAllWithPaginationUseCase(this.repository);

  Future<PaginatedResponse<AnnouncementsEntity>> call(
          AnnouncementsQueryParams params) async =>
      await repository.getAnnouncementsWithPagination(params);
}
