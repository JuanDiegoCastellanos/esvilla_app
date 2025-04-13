import 'package:esvilla_app/domain/entities/announcements/announcements_entity.dart';
import 'package:esvilla_app/domain/repositories/announcements_repository.dart';

class GetMyAnnouncementsUseCase {
  final AnnouncementsRepository _repository;

  GetMyAnnouncementsUseCase(this._repository);

  Future<List<AnnouncementsEntity>> call() async => await _repository.getMyAnnouncements();
}