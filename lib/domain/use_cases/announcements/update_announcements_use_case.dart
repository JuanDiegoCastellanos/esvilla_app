import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/entities/announcements/update_announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class UpdateAnnouncementsUseCase {
  final AnnouncementsRepository _repository;

  UpdateAnnouncementsUseCase(this._repository);

  Future<AnnouncementsEntity> call(
          String id, UpdateAnnouncementsRequestEntity request) async =>
      await _repository.update(id, request);
}
