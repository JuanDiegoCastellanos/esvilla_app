import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/create_announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/update_announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/generic_repository.dart';

abstract class AnnouncementsRepository implements GenericRepository<AnnouncementsEntity, CreateAnnouncementsRequestEntity, UpdateAnnouncementsRequestEntity> {
  Future<List<AnnouncementsEntity>> getMyAnnouncements();

  Future<List<AnnouncementsEntity>> getAnnouncementsByUser(String id);

  Future<List<AnnouncementsEntity>> getMyAnnouncementsBetweenCreationDates(String startDate, String endDate);

  Future<List<AnnouncementsEntity>> getAnnouncementsBetweenCreationDates(String startDate, String endDate);

  Future<List<AnnouncementsEntity>> getMyAnnouncementsBetweenPublishDates(String startDate, String endDate);

  Future<List<AnnouncementsEntity>> getAnnouncementsBetweenPublishDates(String startDate, String endDate);

  Future<AnnouncementsEntity> publishAnnouncement(String id);

  Future<PaginatedResponse<AnnouncementsEntity>> getAnnouncementsWithPagination(AnnouncementsQueryParams queryParams);
}