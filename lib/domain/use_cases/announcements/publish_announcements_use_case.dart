import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class PublishAnnouncementsUseCase {
  final AnnouncementsRepository _repository;

  PublishAnnouncementsUseCase(this._repository);

  Future<AnnouncementsEntity> call(String id) async => await _repository.publishAnnouncement(id); 
}