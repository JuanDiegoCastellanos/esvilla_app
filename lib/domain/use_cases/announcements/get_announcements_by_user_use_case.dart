import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class GetAnnouncementsByUserUseCase {
  final AnnouncementsRepository _repository;

  GetAnnouncementsByUserUseCase(this._repository);

  Future<List<AnnouncementsEntity>> call(String id) async =>
  await _repository.getAnnouncementsByUser(id);

}