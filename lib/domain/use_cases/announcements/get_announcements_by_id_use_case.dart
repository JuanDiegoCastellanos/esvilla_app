import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class GetAnnouncementsByIdUseCase {
  final AnnouncementsRepository _repository;

  GetAnnouncementsByIdUseCase(this._repository);

  Future<AnnouncementsEntity> call(String id) async => await _repository.getById(id);
  
}