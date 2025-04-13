import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class DeleteAnnouncementsUseCase {
  final AnnouncementsRepository _repository;

  DeleteAnnouncementsUseCase(this._repository);

  Future<AnnouncementsEntity> call(String id) async => await _repository.delete(id);
}