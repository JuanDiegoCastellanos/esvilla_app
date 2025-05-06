import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/data/datasources/announcements/announcements_remote_data_source.dart';
import 'package:esvilla_app/data/mappers/announcements/announcements_mapper.dart';
import 'package:esvilla_app/data/models/announcements/announcements_query_params.dart';
import 'package:esvilla_app/data/models/announcements/paginated_reponse.dart';
import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/create_announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/update_announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class AnnouncementsRepositoryImpl implements AnnouncementsRepository {
  final AnnouncementsRemoteDataSource _announcementsRemoteDataSource;

  AnnouncementsRepositoryImpl(this._announcementsRemoteDataSource);

  @override
  Future<AnnouncementsEntity> add(
      CreateAnnouncementsRequestEntity entity) async {
    try {
      final request = AnnouncementsMapper.toCreateAnnouncementRequest(entity);
      final response =
          await _announcementsRemoteDataSource.createAnnouncement(request);
      return AnnouncementsMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<AnnouncementsEntity> delete(String id) async {
    try {
      final response =
          await _announcementsRemoteDataSource.deleteAnnouncement(id);
      return AnnouncementsMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<AnnouncementsEntity>> getAll() async {
    try {
      final response = await _announcementsRemoteDataSource.getAnnouncements();
      return AnnouncementsMapper.toEntityList(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<AnnouncementsEntity> getById(String id) async {
    try {
      final response =
          await _announcementsRemoteDataSource.getAnnouncementByID(id);
      return AnnouncementsMapper.toEntity(response);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<AnnouncementsEntity> update(
      String id, UpdateAnnouncementsRequestEntity entity) async {
    try {
      final updateRequestModel =
          AnnouncementsMapper.toUpdateAnnouncementRequest(entity);
      final request = await _announcementsRemoteDataSource
          .updateAnnouncement(updateRequestModel);
      return AnnouncementsMapper.toEntity(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<AnnouncementsEntity>> getAnnouncementsBetweenCreationDates(
      String startDate, String endDate) async {
    try {
      final request = await _announcementsRemoteDataSource
          .getAnnouncementsByCreationDate(startDate, endDate);
      return AnnouncementsMapper.toEntityList(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<AnnouncementsEntity>> getAnnouncementsBetweenPublishDates(
      String startDate, String endDate) async {
    try {
      final request = await _announcementsRemoteDataSource
          .getAnnouncementsByPublishDate(startDate, endDate);
      return AnnouncementsMapper.toEntityList(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<AnnouncementsEntity>> getAnnouncementsByUser(String id) async {
    try {
      final request =
          await _announcementsRemoteDataSource.getAnnouncementsByUser(id);
      return AnnouncementsMapper.toEntityList(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<AnnouncementsEntity>> getMyAnnouncements() async {
    try {
      final request = await _announcementsRemoteDataSource.getMyAnnouncements();
      return AnnouncementsMapper.toEntityList(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<AnnouncementsEntity>> getMyAnnouncementsBetweenCreationDates(
      String startDate, String endDate) async {
    try {
      final request = await _announcementsRemoteDataSource
          .getMyAnnouncementsByCreationDate(startDate, endDate);
      return AnnouncementsMapper.toEntityList(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<List<AnnouncementsEntity>> getMyAnnouncementsBetweenPublishDates(
      String startDate, String endDate) async {
    try {
      final request = await _announcementsRemoteDataSource
          .getMyAnnouncementsByPublicationDate(startDate, endDate);
      return AnnouncementsMapper.toEntityList(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<AnnouncementsEntity> publishAnnouncement(String id) async {
    try {
      final request =
          await _announcementsRemoteDataSource.publishAnnouncement(id);
      return AnnouncementsMapper.toEntity(request);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<PaginatedResponse<AnnouncementsEntity>> getAnnouncementsWithPagination(
      AnnouncementsQueryParams queryParams) async {
    try {
      final response = await _announcementsRemoteDataSource
          .getAnnouncementsWithPagination(queryParams);
      return PaginatedResponse(
          data: AnnouncementsMapper.toEntityList(response.data),
          meta: response.meta);
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }
}
